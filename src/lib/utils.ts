/**
 * 工具函数集合
 */

/**
 * 显示图片预览模态框
 */
export function showImageModal(imageSrc: string, title?: string) {
  const modal = document.createElement('div');
  modal.className = 'fixed inset-0 z-[10000] flex items-center justify-center p-4';
  modal.style.backgroundColor = 'rgba(0,0,0,0.75)';
  modal.onclick = () => modal.remove();
  
  const contentHtml = title
    ? `
        <div class="bg-white p-4 rounded-lg max-w-2xl max-h-[80vh] overflow-auto">
          <p class="text-center font-semibold mb-3">${title}</p>
          <img src="${imageSrc}" class="max-w-full object-contain" onclick="event.stopPropagation()" />
        </div>
      `
    : `<img src="${imageSrc}" class="max-w-full max-h-full object-contain" onclick="event.stopPropagation()" />`;
  
  modal.innerHTML = contentHtml;
  document.body.appendChild(modal);
}

/**
 * 格式化日期用于文件名
 */
export function formatDateForFilename(): string {
  const now = new Date();
  const date = `${now.getFullYear()}${String(now.getMonth() + 1).padStart(2, '0')}${String(now.getDate()).padStart(2, '0')}`;
  const time = `${String(now.getHours()).padStart(2, '0')}${String(now.getMinutes()).padStart(2, '0')}`;
  return `${date}_${time}`;
}

/**
 * 规范化标签名称（处理中英文）
 */
export function normalizeLabel(label: string): 'cardNumber' | 'password' {
  const lowerLabel = label.toLowerCase();
  if (lowerLabel.includes('卡号') || lowerLabel.includes('card') || lowerLabel.includes('number')) {
    return 'cardNumber';
  }
  if (lowerLabel.includes('密码') || lowerLabel.includes('password') || lowerLabel.includes('pwd')) {
    return 'password';
  }
  // 默认返回 cardNumber
  return 'cardNumber';
}

/**
 * 日志级别
 */
type LogLevel = 'none' | 'error' | 'warn' | 'info' | 'debug';

/**
 * 获取当前日志级别
 */
function getLogLevel(): LogLevel {
  // 从环境变量或 localStorage 读取
  if (typeof window !== 'undefined') {
    const savedLevel = localStorage.getItem('log-level') as LogLevel;
    if (savedLevel && ['none', 'error', 'warn', 'info', 'debug'].includes(savedLevel)) {
      return savedLevel;
    }
  }
  // 默认只显示错误和警告
  return 'warn';
}

/**
 * 日志工具
 */
export const logger = {
  setLevel: (level: LogLevel) => {
    if (typeof window !== 'undefined') {
      localStorage.setItem('log-level', level);
    }
  },
  getLevel: () => getLogLevel(),

  info: (message: string, data?: any) => {
    if (getLogLevel() === 'none') return;
    // 只在 debug 级别显示详细日志
    if (getLogLevel() === 'debug' && process.env.NODE_ENV === 'development') {
      console.log(`[INFO] ${message}`, data || '');
    }
  },

  error: (message: string, error?: any) => {
    if (getLogLevel() === 'none') return;
    console.error(`[ERROR] ${message}`, error || '');
  },

  warn: (message: string, data?: any) => {
    if (getLogLevel() === 'none') return;
    console.warn(`[WARN] ${message}`, data || '');
  },

  debug: (message: string, data?: any) => {
    if (getLogLevel() === 'none') return;
    if (getLogLevel() === 'debug' && process.env.NODE_ENV === 'development') {
      console.log(`[DEBUG] ${message}`, data || '');
    }
  },

  // 专门用于显示关键统计信息（识别数量等）
  stats: (message: string, data?: any) => {
    if (getLogLevel() === 'none') return;
    console.log(`[STATS] ${message}`, data || '');
  }
};

/**
 * 创建带超时的fetch请求
 */
export async function fetchWithTimeout(
  url: string,
  options: RequestInit,
  timeoutMs: number = 30000
): Promise<Response> {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), timeoutMs);

  try {
    const response = await fetch(url, {
      ...options,
      signal: controller.signal,
    });
    clearTimeout(timeoutId);
    return response;
  } catch (error) {
    clearTimeout(timeoutId);
    throw error;
  }
}

/**
 * 下载Blob文件
 */
export function downloadBlob(blob: Blob, filename: string) {
  const url = window.URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = filename;
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  window.URL.revokeObjectURL(url);
}
