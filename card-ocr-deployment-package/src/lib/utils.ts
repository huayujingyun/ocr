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
 * 日志工具
 */
export const logger = {
  info: (message: string, data?: any) => {
    if (process.env.NODE_ENV === 'development') {
      console.log(`[INFO] ${message}`, data || '');
    }
  },
  error: (message: string, error?: any) => {
    console.error(`[ERROR] ${message}`, error || '');
  },
  warn: (message: string, data?: any) => {
    console.warn(`[WARN] ${message}`, data || '');
  },
  debug: (message: string, data?: any) => {
    if (process.env.NODE_ENV === 'development') {
      console.log(`[DEBUG] ${message}`, data || '');
    }
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
