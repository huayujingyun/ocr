import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

/**
 * 验证API令牌
 */
function verifyAuthToken(request: NextRequest): boolean {
  const authHeader = request.headers.get('authorization');
  const expectedToken = process.env.API_TOKEN;

  // 如果未配置令牌，则跳过验证
  if (!expectedToken) {
    return true;
  }

  if (!authHeader || authHeader !== `Bearer ${expectedToken}`) {
    return false;
  }

  return true;
}

/**
 * 验证IP白名单
 */
function verifyIPWhitelist(request: NextRequest): boolean {
  const allowedIPs = process.env.ALLOWED_IPS?.split(',') || [];

  // 如果未配置白名单，则允许所有
  if (allowedIPs.length === 0) {
    return true;
  }

  // 获取真实IP地址
  const ip = request.headers.get('x-forwarded-for')?.split(',')[0].trim()
    || request.headers.get('x-real-ip')
    || 'unknown';

  return allowedIPs.includes(ip);
}

/**
 * 添加安全头部
 */
function addSecurityHeaders(response: NextResponse): NextResponse {
  // 防止MIME类型嗅探
  response.headers.set('X-Content-Type-Options', 'nosniff');

  // 防止点击劫持
  response.headers.set('X-Frame-Options', 'DENY');

  // XSS保护
  response.headers.set('X-XSS-Protection', '1; mode=block');

  // 强制HTTPS（仅在生产环境）
  if (process.env.NODE_ENV === 'production') {
    response.headers.set('Strict-Transport-Security', 'max-age=31536000; includeSubDomains');
  }

  // 内容安全策略
  response.headers.set(
    'Content-Security-Policy',
    "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: blob:; font-src 'self' data:; connect-src 'self' blob:; frame-ancestors 'none';"
  );

  // Referrer策略
  response.headers.set('Referrer-Policy', 'strict-origin-when-cross-origin');

  return response;
}

/**
 * 主中间件
 */
export function middleware(request: NextRequest) {
  const response = NextResponse.next();

  // 添加安全头部
  addSecurityHeaders(response);

  // 对API路由进行认证验证
  if (request.nextUrl.pathname.startsWith('/api/')) {
    // 验证API令牌
    if (!verifyAuthToken(request)) {
      return NextResponse.json(
        { error: '未授权访问：无效的API令牌' },
        { status: 401 }
      );
    }

    // 验证IP白名单
    if (!verifyIPWhitelist(request)) {
      return NextResponse.json(
        { error: '未授权访问：IP地址不在白名单中' },
        { status: 403 }
      );
    }
  }

  // 对模板页面进行访问控制
  if (request.nextUrl.pathname.startsWith('/template')) {
    // 验证API令牌
    if (!verifyAuthToken(request)) {
      return NextResponse.redirect(new URL('/unauthorized', request.url));
    }

    // 验证IP白名单
    if (!verifyIPWhitelist(request)) {
      return NextResponse.redirect(new URL('/unauthorized', request.url));
    }
  }

  // 记录访问日志（可选）
  if (process.env.ENABLE_ACCESS_LOG === 'true') {
    const ip = request.headers.get('x-forwarded-for')?.split(',')[0] || 'unknown';
    console.log(`[ACCESS] ${new Date().toISOString()} ${ip} ${request.method} ${request.nextUrl.pathname}`);
  }

  return response;
}

/**
 * 中间件配置
 */
export const config = {
  matcher: [
    '/api/:path*',
    '/template/:path*',
  ],
};
