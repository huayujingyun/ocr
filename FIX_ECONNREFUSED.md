# 🔧 修复连接被拒绝问题

## 问题分析

错误信息显示：
```
TypeError: fetch failed
[cause]: AggregateError: { code: 'ECONNREFUSED' }
```

**根本原因**：前端API路由配置的后端服务端口错误。

- **配置的端口**：8001（在 `src/app/api/ocr/route.ts` 中）
- **实际端口**：8000（后端服务实际运行的端口）

这导致前端无法连接到后端服务，出现连接被拒绝的错误。

---

## ✅ 已修复

### 修改文件：`src/app/api/ocr/route.ts`

**修改前**：
```typescript
const PADDLEOCR_API_URL = process.env.PADDLEOCR_API_URL || 'http://localhost:8001';
```

**修改后**：
```typescript
const PADDLEOCR_API_URL = process.env.PADDLEOCR_API_URL || 'http://localhost:8000';
```

---

## 🚀 需要用户执行的操作

### 1. 重新构建前端

打开命令提示符（CMD），在项目根目录执行：

```cmd
cd C:\CARD-OCR-LO
pnpm run build
```

### 2. 重启前端服务

停止当前运行的前端服务（Ctrl+C），然后重新启动：

```cmd
pnpm run start
```

### 3. 确认后端服务运行

确保后端服务正在运行在 8000 端口：

```cmd
# 在另一个窗口中
cd C:\CARD-OCR-LO\backend
py -m uvicorn main:app --host 0.0.0.0 --port 8000
```

等待看到：
```
INFO:     Uvicorn running on http://0.0.0.0:8000
```

---

## 🧪 验证修复

### 测试步骤

1. **访问应用**
   - 打开浏览器：http://localhost:5000

2. **设置模板**（如果还没有）
   - 点击"设置识别模板"
   - 上传卡片图片
   - 框选卡号和密码区域
   - 点击"使用此模板"

3. **上传并识别**
   - 返回首页
   - 点击"上传卡片图片"
   - 选择图片
   - 点击"开始识别"

4. **检查结果**
   - 应该能看到识别的卡号和密码
   - 不再出现 `ECONNREFUSED` 错误

---

## 📋 完整的启动流程

### 窗口1 - 后端服务

```cmd
cd C:\CARD-OCR-LO\backend
py -m uvicorn main:app --host 0.0.0.0 --port 8000
```

### 窗口2 - 前端服务（先构建）

```cmd
cd C:\CARD-OCR-LO
pnpm run build
pnpm run start
```

---

## ⚠️ 注意事项

1. **必须重新构建前端**
   - 修改了API路由配置后，必须重新构建
   - 否则修改不会生效

2. **确保端口一致**
   - 后端服务：8000 端口
   - 前端配置：8000 端口（已修复）
   - 不要随意更改端口

3. **后端服务必须先启动**
   - 前端依赖后端服务
   - 先启动后端，再启动前端

4. **环境变量（可选）**
   - 如果需要使用其他端口，可以设置环境变量
   - 在 Windows 中：`set PADDLEOCR_API_URL=http://localhost:8001`

---

## 🔍 调试技巧

如果问题仍然存在，可以尝试以下调试方法：

### 1. 检查后端服务

打开浏览器访问：http://localhost:8000

应该看到：
```json
{
  "service": "PaddleOCR-VL-1.5 API",
  "version": "1.0.0",
  "status": "running"
}
```

### 2. 检查后端日志

查看后端命令提示符窗口，确认没有错误信息。

### 3. 测试OCR API

使用 curl 或 Postman 测试后端 API：

```bash
curl -X POST http://localhost:8000/api/ocr/recognize \
  -H "Content-Type: application/json" \
  -d '{"image": "base64_encoded_image"}'
```

### 4. 查看浏览器控制台

按 F12 打开开发者工具：
- 查看 Console 标签的错误信息
- 查看 Network 标签的请求状态

---

## 📊 端口配置总结

| 服务 | 端口 | 用途 |
|------|------|------|
| **后端 API** | 8000 | PaddleOCR 服务 |
| **前端 Web** | 5000 | Next.js 应用 |

---

## ✅ 修复确认清单

- [x] 找到问题原因（端口配置错误）
- [x] 修复端口配置（8001 → 8000）
- [ ] 用户重新构建前端
- [ ] 用户重启前端服务
- [ ] 用户验证OCR功能正常

---

**最后更新**：2026-02-04  
**问题**：ECONNREFUSED - 连接被拒绝  
**修复**：将API端口从8001改为8000  
**状态**：✅ 已修复，等待用户验证
