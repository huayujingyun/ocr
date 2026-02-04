# 系统安全分析与改进方案

## 🔍 当前安全风险评估

### 1. 数据传输风险 ⚠️ 高风险
- **问题**：当前使用 HTTP 协议传输，数据未加密
- **风险**：
  - 中间人攻击：黑客可拦截卡号、密码等敏感信息
  - 数据泄露：在网络传输过程中可能被窃听
  - 重放攻击：拦截的数据包可能被重放

### 2. 第三方API调用风险 ⚠️ 高风险
- **问题**：OCR识别时，卡片图片和识别结果会发送给大语言模型服务
- **风险**：
  - 数据外泄：第三方服务可能记录或存储卡片信息
  - 合规问题：违反数据隐私保护法规（如GDPR、个人信息保护法）
  - 供应链攻击：第三方服务被攻击导致数据泄露

### 3. 日志安全风险 ⚠️ 中风险
- **问题**：日志中可能包含完整的卡号和密码信息
- **风险**：
  - 日志泄露：攻击者访问日志可获取敏感信息
  - 存储安全：日志文件未加密存储
  - 审计问题：无法追踪数据访问记录

### 4. 存储安全风险 ⚠️ 中风险
- **问题**：前端使用 sessionStorage 存储模板和识别结果
- **风险**：
  - XSS攻击：恶意脚本可读取浏览器存储
  - 会话劫持：session ID可能被窃取
  - 数据残留：关闭浏览器前数据一直存在

### 5. 访问控制风险 ⚠️ 中风险
- **问题**：没有用户认证和权限控制
- **风险**：
  - 未授权访问：任何人都可以上传图片和查看结果
  - 数据导出：没有限制谁能导出Excel
  - 批量攻击：攻击者可批量上传测试

---

## 🛡️ 安全改进方案

### 方案一：启用 HTTPS（必须）

#### 1.1 使用 Nginx 反向代理 + SSL

```nginx
# /etc/nginx/sites-available/card-ocr
server {
    listen 443 ssl http2;
    server_name your-domain.com;

    ssl_certificate /path/to/your/cert.pem;
    ssl_certificate_key /path/to/your/private.key;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    client_max_body_size 50M;

    location / {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        proxy_redirect off;
    }
}

# HTTP 重定向到 HTTPS
server {
    listen 80;
    server_name your-domain.com;
    return 301 https://$server_name$request_uri;
}
```

#### 1.2 使用 Let's Encrypt 免费证书

```bash
# 安装 Certbot
sudo apt install certbot python3-certbot-nginx

# 获取证书
sudo certbot --nginx -d your-domain.com

# 自动续期
sudo certbot renew --dry-run
```

---

### 方案二：数据加密传输（推荐）

#### 2.1 实现端到端加密

```typescript
// 前端加密
import { encrypt } from '@/lib/crypto';

const handleExtract = async () => {
  // 加密卡片图片数据
  const encryptedImageData = await encrypt(cardImageData);

  const response = await fetch('/api/ocr', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ encryptedImageData }),
  });
};
```

```typescript
// 后端解密
import { decrypt } from '@/lib/crypto';

export async function POST(request: NextRequest) {
  const { encryptedImageData } = await request.json();

  // 解密图片数据
  const imageData = await decrypt(encryptedImageData);

  // 进行OCR识别...
}
```

#### 2.2 使用 AES-256 加密

```typescript
// src/lib/crypto.ts
import crypto from 'crypto';

const ALGORITHM = 'aes-256-gcm';
const KEY_LENGTH = 32;
const IV_LENGTH = 16;
const SALT_LENGTH = 64;
const TAG_LENGTH = 16;
const TAG_POSITION = SALT_LENGTH + IV_LENGTH;
const ENCRYPTED_POSITION = TAG_POSITION + TAG_LENGTH;

// 从环境变量获取密钥
function getKey(): Buffer {
  const secret = process.env.ENCRYPTION_KEY || 'default-secret-key-change-in-production';
  return crypto.scryptSync(secret, 'salt', KEY_LENGTH);
}

export async function encrypt(text: string): Promise<string> {
  const iv = crypto.randomBytes(IV_LENGTH);
  const salt = crypto.randomBytes(SALT_LENGTH);
  const key = getKey();

  const cipher = crypto.createCipheriv(ALGORITHM, key, iv);
  const encrypted = Buffer.concat([cipher.update(text, 'utf8'), cipher.final()]);
  const tag = cipher.getAuthTag();

  return Buffer.concat([salt, iv, tag, encrypted]).toString('base64');
}

export async function decrypt(encryptedText: string): Promise<string> {
  const buffer = Buffer.from(encryptedText, 'base64');

  const salt = buffer.slice(0, SALT_LENGTH);
  const iv = buffer.slice(SALT_LENGTH, TAG_POSITION);
  const tag = buffer.slice(TAG_POSITION, ENCRYPTED_POSITION);
  const encrypted = buffer.slice(ENCRYPTED_POSITION);

  const key = getKey();

  const decipher = crypto.createDecipheriv(ALGORITHM, key, iv);
  decipher.setAuthTag(tag);

  return decipher.update(encrypted) + decipher.final('utf8');
}
```

---

### 方案三：敏感数据脱敏（必须）

#### 3.1 日志脱敏

```typescript
// src/lib/logger.ts
function maskSensitiveData(data: any): any {
  if (typeof data === 'string') {
    // 脱敏卡号和密码
    return data.replace(/\d{16,19}/g, (match) => {
      return match.slice(0, 4) + '*'.repeat(match.length - 8) + match.slice(-4);
    });
  }

  if (typeof data === 'object' && data !== null) {
    const masked: any = {};
    for (const key in data) {
      if (key.toLowerCase().includes('card') || key.toLowerCase().includes('password')) {
        masked[key] = '*** MASKED ***';
      } else {
        masked[key] = maskSensitiveData(data[key]);
      }
    }
    return masked;
  }

  return data;
}

export const logger = {
  info: (message: string, data?: any) => {
    console.log(`[INFO] ${message}`, data ? maskSensitiveData(data) : '');
  },
  error: (message: string, error?: any) => {
    console.error(`[ERROR] ${message}`, error ? maskSensitiveData(error) : '');
  },
  warn: (message: string, data?: any) => {
    console.warn(`[WARN] ${message}`, data ? maskSensitiveData(data) : '');
  },
};
```

#### 3.2 日志脱敏示例

```typescript
// 使用前
logger.info('识别结果', { cardNumber: '1234567890123456', password: '123456' });
// 输出：[INFO] 识别结果 { cardNumber: '1234********3456', password: '*** MASKED ***' }

// 使用后
logger.info('识别成功', { imageId: 'img_001', status: 'success' });
// 输出：[INFO] 识别成功 { imageId: 'img_001', status: 'success' }
```

---

### 方案四：添加访问控制（推荐）

#### 4.1 实现用户认证

```typescript
// src/middleware.ts
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  // 检查认证令牌
  const authHeader = request.headers.get('authorization');
  const token = process.env.API_TOKEN;

  if (authHeader !== `Bearer ${token}`) {
    return NextResponse.json({ error: '未授权访问' }, { status: 401 });
  }

  return NextResponse.next();
}

export const config = {
  matcher: ['/api/:path*', '/template/:path*'],
};
```

#### 4.2 添加 IP 白名单

```typescript
// src/middleware.ts
const ALLOWED_IPS = process.env.ALLOWED_IPS?.split(',') || [];

export function middleware(request: NextRequest) {
  const ip = request.ip || request.headers.get('x-forwarded-for')?.split(',')[0];

  if (ALLOWED_IPS.length > 0 && !ALLOWED_IPS.includes(ip)) {
    return NextResponse.json({ error: 'IP地址未授权' }, { status: 403 });
  }

  return NextResponse.next();
}
```

---

### 方案五：使用私有化部署的大模型（最佳）

#### 5.1 部署本地 OCR 服务

```bash
# 使用 Tesseract OCR（开源）
docker run -d -p 8080:8080 tesseractshadow/tesseractocr-reapi

# 或使用 PaddleOCR
docker run -d -p 8866:8866 paddlepaddle/paddleocr:latest-cpu
```

```typescript
// 调用本地 OCR 服务
const response = await fetch('http://localhost:8866/ocr', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ images: [imageData] }),
});
```

#### 5.2 使用离线模型

```typescript
// 使用 Tesseract.js（浏览器端）
import Tesseract from 'tesseract.js';

const recognizeText = async (imageData: string) => {
  const { data: { text } } = await Tesseract.recognize(
    imageData,
    'chi_sim', // 简体中文
    { logger: m => console.log(m) }
  );

  return text.trim();
};
```

---

### 方案六：数据保留策略（必须）

#### 6.1 前端数据清理

```typescript
// src/app/page.tsx
useEffect(() => {
  return () => {
    // 组件卸载时清理敏感数据
    sessionStorage.removeItem('current-template');
    setSelectedImages([]);
  };
}, []);

// 自动清理
useEffect(() => {
  const timer = setTimeout(() => {
    setSelectedImages([]);
  }, 30 * 60 * 1000); // 30分钟后自动清理

  return () => clearTimeout(timer);
}, [selectedImages]);
```

#### 6.2 后端数据清理

```typescript
// src/app/api/ocr/route.ts
// 识别完成后立即清理临时文件
const tempFilePath = `/tmp/${imageId}.jpg`;
fs.unlink(tempFilePath, (err) => {
  if (err) console.error('删除临时文件失败:', err);
});
```

---

### 方案七：添加安全头部（推荐）

```typescript
// src/middleware.ts
export function middleware(request: NextRequest) {
  const response = NextResponse.next();

  // 添加安全头部
  response.headers.set('X-Content-Type-Options', 'nosniff');
  response.headers.set('X-Frame-Options', 'DENY');
  response.headers.set('X-XSS-Protection', '1; mode=block');
  response.headers.set('Strict-Transport-Security', 'max-age=31536000; includeSubDomains');
  response.headers.set('Content-Security-Policy', "default-src 'self'");

  return response;
}
```

---

## 📋 环境变量配置

创建 `.env.local` 文件：

```env
# 加密密钥（必须更改）
ENCRYPTION_KEY=your-secure-encryption-key-at-least-32-characters-long

# API令牌（用于认证）
API_TOKEN=your-secure-api-token

# 允许的IP地址（多个用逗号分隔）
ALLOWED_IPS=192.168.1.100,192.168.1.101

# 本地OCR服务地址（如果使用）
LOCAL_OCR_URL=http://localhost:8866

# 日志级别
LOG_LEVEL=error
```

---

## 🚀 立即实施的安全措施（优先级排序）

### 🔴 紧急（立即实施）
1. **启用 HTTPS**：防止数据传输被拦截
2. **日志脱敏**：避免敏感信息泄露到日志
3. **添加访问控制**：限制未授权访问
4. **数据清理**：及时清理临时数据

### 🟡 重要（尽快实施）
5. **端到端加密**：即使使用HTTPS也建议实施
6. **安全头部**：防止XSS和点击劫持
7. **IP白名单**：限制访问来源

### 🟢 建议（长期改进）
8. **私有化部署**：使用本地OCR服务
9. **审计日志**：记录所有访问操作
10. **数据加密存储**：对存储的数据加密

---

## ⚠️ 部署在扣子的特别注意事项

如果部署在扣子平台，额外注意：

1. **了解平台安全政策**
   - 查阅扣子的数据使用协议
   - 确认数据是否会被平台记录

2. **使用私有部署**
   - 将整个系统部署在自己的服务器
   - 不依赖扣子的OCR API

3. **数据隔离**
   - 每个用户使用独立的数据库
   - 数据加密后存储

4. **合规性检查**
   - 确保符合《个人信息保护法》
   - 获得用户授权后再处理数据

5. **定期安全审计**
   - 检查是否有未授权访问
   - 审查日志是否有异常记录

---

## 📞 安全检查清单

部署前请检查：

- [ ] 已启用 HTTPS
- [ ] 已实现日志脱敏
- [ ] 已添加认证机制
- [ ] 已设置 IP 白名单
- [ ] 已实现数据加密
- [ ] 已添加安全头部
- [ ] 已配置数据保留策略
- [ ] 已清理敏感日志
- [ ] 已进行安全测试
- [ ] 已制定应急响应计划

---

## 🔐 总结

**当前风险等级：高**

**建议立即实施：**
1. 启用 HTTPS
2. 日志脱敏
3. 添加访问控制

**长期改进方向：**
1. 使用私有化 OCR 服务
2. 实施端到端加密
3. 完善安全审计机制

**最佳实践：**
- 将整个系统部署在您的私有服务器
- 使用开源 OCR 库（如 Tesseract、PaddleOCR）
- 数据不离开您的服务器
- 定期进行安全审计

如有任何安全问题，请及时联系安全专家！
