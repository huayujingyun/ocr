# 🔧 修复 503 服务不可用错误

## 问题分析

错误信息：`OCR服务返回错误: 503`

**HTTP 503** 表示"Service Unavailable"（服务不可用），这意味着后端服务接收到了请求，但OCR服务没有正确初始化。

### 根本原因

查看后端代码，503 错误在以下情况下返回：

```python
if ocr_service is None:
    raise HTTPException(status_code=503, detail="OCR服务未初始化")
```

**可能的原因**：
1. **PaddleOCR 模型文件未下载** - 首次运行需要下载模型
2. **依赖安装不完整** - 缺少必要的库
3. **Python 环境问题** - Python 版本或配置问题
4. **网络问题** - 模型下载失败

---

## 🔍 诊断步骤

### 步骤1：检查后端启动日志

在运行后端的命令提示符窗口中，查找以下信息：

**✅ 成功的日志**：
```
INFO:     OCR服务初始化成功
INFO:     PaddleOCR-VL-1.5引擎初始化成功
INFO:     Application startup complete
```

**❌ 失败的日志**：
```
ERROR:    OCR服务初始化失败
ERROR:    初始化PaddleOCR失败: ...
```

### 步骤2：检查后端控制台错误

如果看到以下错误，说明PaddleOCR初始化失败：

```
OSError: Unable to open file (file not found)
RuntimeError: Load model failed
ImportError: No module named 'paddle'
```

---

## ✅ 解决方案

### 方案1：重新安装PaddleOCR（推荐）

在命令提示符中执行：

```cmd
cd C:\CARD-OCR-LO\backend
py -m pip uninstall paddleocr paddlepaddle -y
py -m pip install paddleocr paddlepaddle
```

然后重启后端服务：

```cmd
py -m uvicorn main:app --host 0.0.0.0 --port 8000
```

**首次运行时**，PaddleOCR 会自动下载模型文件（约 20-30 MB），请耐心等待。

### 方案2：使用离线模型下载

如果网络不稳定，可以手动下载模型：

1. 访问 PaddleOCR 模型下载页面
2. 下载模型文件
3. 放置到正确目录

但这个比较复杂，建议使用方案1。

### 方案3：检查依赖完整性

确保所有依赖都已安装：

```cmd
cd C:\CARD-OCR-LO\backend
py -m pip list | findstr paddle
```

应该看到：
```
paddleocr          x.x.x
paddlepaddle      x.x.x
```

如果没有，重新安装：

```cmd
py -m pip install paddleocr paddlepaddle opencv-python pillow numpy
```

---

## 🚀 完整的修复步骤

### 步骤1：停止所有服务

在所有命令提示符窗口中按 `Ctrl+C`

### 步骤2：重新安装后端依赖

```cmd
cd C:\CARD-OCR-LO\backend
py -m pip install -r requirements.txt
```

**如果安装失败**，尝试分别安装：

```cmd
py -m pip install paddlepaddle paddleocr opencv-python pillow numpy pydantic pydantic-settings python-dotenv
```

### 步骤3：启动后端服务

```cmd
py -m uvicorn main:app --host 0.0.0.0 --port 8000
```

**观察启动日志**：
- 如果看到 "OCR服务初始化成功"，继续下一步
- 如果看到错误，复制错误信息进行诊断

### 步骤4：启动前端服务

打开新的命令提示符窗口：

```cmd
cd C:\CARD-OCR-LO
pnpm run start
```

### 步骤5：测试OCR功能

1. 访问 http://localhost:5000
2. 上传图片并点击"开始识别"
3. 查看是否正常识别

---

## 🧪 验证修复

### 测试1：访问后端根路径

打开浏览器访问：http://localhost:8000

应该看到：
```json
{
  "service": "PaddleOCR-VL-1.5 API",
  "version": "1.0.0",
  "status": "running"
}
```

### 测试2：检查OCR服务状态

访问：http://localhost:8000/health

应该看到：
```json
{
  "status": "healthy",
  "ocr_ready": true
}
```

如果 `ocr_ready` 为 `false`，说明 OCR 服务没有正确初始化。

### 测试3：测试OCR识别

使用 curl 或 Postman 测试：

```bash
curl -X POST http://localhost:8000/api/ocr/recognize ^
  -H "Content-Type: application/json" ^
  -d "{\"image\":\"base64_encoded_image\"}"
```

---

## 📊 常见错误及解决方案

### 错误1：OSError: Unable to open file

**原因**：模型文件缺失

**解决**：重新安装 PaddleOCR

```cmd
py -m pip uninstall paddleocr -y
py -m pip install paddleocr
```

### 错误2：ImportError: No module named 'paddle'

**原因**：PaddlePaddle 未安装

**解决**：

```cmd
py -m pip install paddlepaddle
```

### 错误3：RuntimeError: Load model failed

**原因**：模型下载失败或不完整

**解决**：
1. 删除模型缓存目录：`C:\Users\你的用户名\.paddleocr`
2. 重新安装 PaddleOCR

```cmd
py -m pip uninstall paddleocr -y
py -m pip install paddleocr
```

### 错误4：CUDA related errors

**原因**：GPU相关问题（但我们使用CPU模式）

**解决**：确保使用 CPU 模式，不需要 NVIDIA 驱动

---

## 💡 预防措施

1. **使用稳定的网络连接** - 首次安装需要下载模型
2. **等待模型下载完成** - 不要中断下载过程
3. **定期更新依赖** - 保持依赖库版本最新
4. **使用虚拟环境** - 避免依赖冲突（可选）

---

## 📞 仍然无法解决？

如果尝试了所有方案仍然无法解决：

1. **检查 Python 版本**：确保是 3.12
2. **检查系统环境**：确保是 Windows 10/11
3. **查看详细错误**：复制完整的错误信息
4. **尝试重新安装**：删除项目，重新开始安装

---

## ✅ 修复确认清单

- [ ] 检查后端启动日志
- [ ] 重新安装 PaddleOCR 和 PaddlePaddle
- [ ] 重启后端服务
- [ ] 确认 OCR 服务初始化成功
- [ ] 重启前端服务
- [ ] 测试 OCR 识别功能
- [ ] 验证不再出现 503 错误

---

**最后更新**：2026-02-04  
**问题**：503 Service Unavailable  
**原因**：OCR服务未正确初始化  
**解决方案**：重新安装 PaddleOCR  
**状态**：等待用户执行修复
