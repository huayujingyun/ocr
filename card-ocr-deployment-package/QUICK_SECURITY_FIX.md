# 🔒 安全快速实施指南

本指南帮助您在 **10分钟内** 实施关键安全措施。

---

## ⚡ 10分钟快速实施

### 第1步：配置环境变量（2分钟）

```bash
# 1. 复制环境变量模板
cp .env.example .env.local

# 2. 生成安全的加密密钥
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
# 复制输出的密钥，粘贴到 .env.local 的 ENCRYPTION_KEY

# 3. 生成安全的API令牌
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
# 复制输出的令牌，粘贴到 .env.local 的 API_TOKEN

# 4. 设置IP白名单（可选）
# 如果您知道固定的访问IP，填入 ALLOWED_IPS
# 多个IP用逗号分隔，例如：
# ALLOWED_IPS=192.168.1.100,192.168.1.101
```

### 第2步：启用日志脱敏（2分钟）

编辑 `src/lib/utils.ts`，修改 logger 导出：

```typescript
// 在文件顶部添加
import { secureLogger } from './secure';

// 将原有的 logger 导出改为：
export { secureLogger as logger } from './secure';
```

### 第3步：添加访问控制（3分钟）

编辑 `src/lib/utils.ts`，添加安全的 fetch 方法：

```typescript
import { encrypt } from './secure';

// 创建安全的fetch封装
export async function secureFetch(url: string, options: RequestInit = {}) {
  const headers = {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${process.env.API_TOKEN}`,
    ...options.headers,
  };

  // 如果发送敏感数据，加密后再传输
  if (options.body && typeof options.body === 'string') {
    try {
      const body = JSON.parse(options.body);
      // 加密敏感字段
      if (body.imageData) {
        body.imageData = encrypt(body.imageData);
      }
      options.body = JSON.stringify(body);
    } catch (e) {
      // 不是JSON格式，跳过加密
    }
  }

  return fetch(url, { ...options, headers });
}
```

### 第4步：前端添加认证令牌（2分钟）

编辑 `src/app/page.tsx`，在请求头中添加令牌：

```typescript
// 修改 handleExtract 函数
const handleExtract = async () => {
  // ... 原有代码 ...

  const response = await fetch('/api/ocr', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${process.env.NEXT_PUBLIC_API_TOKEN}`,
    },
    body: JSON.stringify({ ... }),
  });

  // ... 原有代码 ...
};
```

添加 `public` 环境变量到 `.env.local`：

```env
NEXT_PUBLIC_API_TOKEN=your-secure-api-token-change-this
```

### 第5步：启用HTTPS（生产环境必须）（1分钟）

如果您使用 Nginx，配置如下：

```nginx
server {
    listen 443 ssl http2;
    server_name your-domain.com;

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    location / {
        proxy_pass http://localhost:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

server {
    listen 80;
    server_name your-domain.com;
    return 301 https://$server_name$request_uri;
}
```

如果您使用云服务（如阿里云、腾讯云），请购买SSL证书并配置。

---

## ✅ 验证安全措施

### 1. 测试认证令牌

```bash
# 不带令牌，应该返回401
curl -X POST http://localhost:5000/api/ocr \
  -H "Content-Type: application/json" \
  -d '{"imageData":"test"}'

# 带令牌，应该正常访问
curl -X POST http://localhost:5000/api/ocr \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer your-secure-api-token" \
  -d '{"imageData":"test"}'
```

### 2. 测试IP白名单

```bash
# 从白名单外的IP访问，应该返回403
curl -X GET http://localhost:5000/api/health
```

### 3. 检查日志脱敏

```bash
# 查看日志，确认敏感信息已被脱敏
tail -f /app/work/logs/bypass/app.log
```

应该看到类似输出：
```
[INFO] 识别成功 { cardNumber: '1234****5678', password: '***MASKED***' }
```

### 4. 检查HTTPS

访问 `https://your-domain.com`，浏览器应该显示锁图标。

---

## 🚨 立即生效的措施

实施以下措施后，安全风险将大幅降低：

| 措施 | 风险降低 | 实施时间 |
|------|---------|---------|
| 日志脱敏 | ⭐⭐⭐⭐⭐ | 2分钟 |
| 访问控制（令牌） | ⭐⭐⭐⭐⭐ | 5分钟 |
| 环境变量配置 | ⭐⭐⭐⭐ | 2分钟 |
| HTTPS | ⭐⭐⭐⭐⭐ | 5分钟（生产环境）|
| 数据加密 | ⭐⭐⭐⭐ | 10分钟 |

---

## 📋 实施检查清单

完成快速实施后，检查以下项目：

- [ ] 已修改 `.env.local` 文件
- [ ] 已设置强加密密钥
- [ ] 已设置强API令牌
- [ ] 已配置IP白名单（如需要）
- [ ] 日志已脱敏
- [ ] 访问控制已启用
- [ ] 前端已添加认证令牌
- [ ] HTTPS已启用（生产环境）
- [ ] 已测试认证功能
- [ ] 已测试IP白名单（如需要）

---

## 🎯 下一步建议

快速实施完成后，建议按以下优先级继续改进：

### 高优先级
1. **部署私有OCR服务**
   - 使用 Tesseract 或 PaddleOCR
   - 数据不离开您的服务器

2. **定期更换密钥**
   - 每月更换一次加密密钥
   - 每季度更换一次API令牌

3. **启用审计日志**
   - 记录所有访问操作
   - 定期审查日志

### 中优先级
4. **实施速率限制**
   - 防止暴力攻击
   - 限制单个IP的请求频率

5. **数据加密存储**
   - 对存储的图片加密
   - 对导出的Excel加密

6. **备份加密**
   - 备份数据加密存储
   - 确保备份安全

### 低优先级
7. **实施双因素认证**
   - 为管理员账户启用2FA
   - 提高账户安全性

8. **安全扫描**
   - 定期进行安全扫描
   - 及时发现漏洞

---

## 🆘 紧急情况处理

如果发现安全漏洞：

1. **立即采取措施**
   - 更换所有密钥和令牌
   - 禁用API访问
   - 通知相关用户

2. **调查影响范围**
   - 检查访问日志
   - 确认数据泄露情况

3. **报告漏洞**
   - 记录漏洞详情
   - 制定修复计划
   - 实施修复措施

4. **预防措施**
   - 加强监控
   - 完善安全策略
   - 定期安全审计

---

## 📞 获取帮助

如需更多安全建议：
- 阅读完整的安全文档：`SECURITY.md`
- 咨询安全专家
- 参考 OWASP 安全指南

---

## ⚠️ 重要提醒

1. **不要使用默认密钥**
   - 立即修改所有默认配置
   - 使用强随机密钥

2. **不要硬编码敏感信息**
   - 所有密钥存储在环境变量中
   - 不要提交到版本控制

3. **定期更新依赖**
   - 及时更新依赖包
   - 修复已知漏洞

4. **备份密钥**
   - 安全地备份密钥
   - 不要丢失访问权限

开始实施吧！🔒
