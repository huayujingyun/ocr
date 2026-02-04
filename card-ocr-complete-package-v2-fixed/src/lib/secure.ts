import crypto from 'crypto';

const ALGORITHM = 'aes-256-gcm';
const KEY_LENGTH = 32;
const IV_LENGTH = 16;
const SALT_LENGTH = 64;
const TAG_LENGTH = 16;
const TAG_POSITION = SALT_LENGTH + IV_LENGTH;
const ENCRYPTED_POSITION = TAG_POSITION + TAG_LENGTH;

/**
 * 从环境变量获取加密密钥
 */
function getKey(): Buffer {
  const secret = process.env.ENCRYPTION_KEY || 'default-secret-key-change-in-production';
  return crypto.scryptSync(secret, 'salt', KEY_LENGTH);
}

/**
 * 加密字符串
 */
export function encrypt(text: string): string {
  try {
    const iv = crypto.randomBytes(IV_LENGTH);
    const salt = crypto.randomBytes(SALT_LENGTH);
    const key = getKey();

    const cipher = crypto.createCipheriv(ALGORITHM, key, iv);
    const encrypted = Buffer.concat([cipher.update(text, 'utf8'), cipher.final()]);
    const tag = cipher.getAuthTag();

    return Buffer.concat([salt, iv, tag, encrypted]).toString('base64');
  } catch (error) {
    console.error('加密失败:', error);
    throw new Error('数据加密失败');
  }
}

/**
 * 解密字符串
 */
export function decrypt(encryptedText: string): string {
  try {
    const buffer = Buffer.from(encryptedText, 'base64');

    const salt = buffer.slice(0, SALT_LENGTH);
    const iv = buffer.slice(SALT_LENGTH, TAG_POSITION);
    const tag = buffer.slice(TAG_POSITION, ENCRYPTED_POSITION);
    const encrypted = buffer.slice(ENCRYPTED_POSITION);

    const key = getKey();

    const decipher = crypto.createDecipheriv(ALGORITHM, key, iv);
    decipher.setAuthTag(tag);

    return decipher.update(encrypted) + decipher.final('utf8');
  } catch (error) {
    console.error('解密失败:', error);
    throw new Error('数据解密失败');
  }
}

/**
 * 脱敏敏感数据
 */
export function maskSensitiveData(data: any): any {
  if (typeof data === 'string') {
    // 脱敏卡号（保留前4位和后4位）
    const cardNumberMatch = data.match(/\b\d{16,19}\b/);
    if (cardNumberMatch) {
      return data.replace(/\d{16,19}/g, (match: string) => {
        if (match.length >= 8) {
          return match.slice(0, 4) + '*'.repeat(match.length - 8) + match.slice(-4);
        }
        return '****';
      });
    }

    // 脱敏密码（全部替换为星号）
    if (data.length <= 20 && /^\d+$/.test(data)) {
      return '***MASKED***';
    }

    return data;
  }

  if (typeof data === 'object' && data !== null) {
    if (Array.isArray(data)) {
      return data.map(item => maskSensitiveData(item));
    }

    const masked: any = {};
    for (const key in data) {
      const keyLower = key.toLowerCase();

      // 脱敏包含敏感关键词的字段
      if (
        keyLower.includes('card') ||
        keyLower.includes('password') ||
        keyLower.includes('secret') ||
        keyLower.includes('token') ||
        keyLower.includes('key')
      ) {
        masked[key] = '***MASKED***';
      } else {
        masked[key] = maskSensitiveData(data[key]);
      }
    }
    return masked;
  }

  return data;
}

/**
 * 生成随机Token
 */
export function generateToken(length: number = 32): string {
  return crypto.randomBytes(length).toString('hex');
}

/**
 * 验证Token
 */
export function verifyToken(token: string, expectedToken: string): boolean {
  return crypto.timingSafeEqual(
    Buffer.from(token),
    Buffer.from(expectedToken)
  );
}

/**
 * 安全的日志记录器
 */
export const secureLogger = {
  info: (message: string, data?: any) => {
    console.log(
      `[INFO] ${new Date().toISOString()} ${message}`,
      data ? maskSensitiveData(data) : ''
    );
  },

  error: (message: string, error?: any) => {
    console.error(
      `[ERROR] ${new Date().toISOString()} ${message}`,
      error ? maskSensitiveData(error) : ''
    );
  },

  warn: (message: string, data?: any) => {
    console.warn(
      `[WARN] ${new Date().toISOString()} ${message}`,
      data ? maskSensitiveData(data) : ''
    );
  },

  debug: (message: string, data?: any) => {
    if (process.env.NODE_ENV === 'development') {
      console.debug(
        `[DEBUG] ${new Date().toISOString()} ${message}`,
        data ? maskSensitiveData(data) : ''
      );
    }
  },
};

/**
 * 验证IP地址是否在白名单中
 */
export function isIPAllowed(ip: string, allowedIPs: string[]): boolean {
  if (!allowedIPs || allowedIPs.length === 0) {
    return true; // 未配置白名单则允许所有
  }

  return allowedIPs.includes(ip);
}

/**
 * 验证请求签名
 */
export function verifySignature(
  payload: any,
  signature: string,
  secret: string
): boolean {
  const hmac = crypto.createHmac('sha256', secret);
  const computedSignature = hmac.update(JSON.stringify(payload)).digest('hex');
  return crypto.timingSafeEqual(
    Buffer.from(signature),
    Buffer.from(computedSignature)
  );
}
