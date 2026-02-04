# 非 Docker 部署 - 完整故障排除指南

## 🔧 快速诊断

### 检查清单

运行以下命令检查系统状态：

```cmd
REM 检查 Python
python --version
REM 应该输出: Python 3.12.x

REM 检查 pip
pip --version
REM 应该输出: pip 24.x.x

REM 检查 Node.js
node --version
REM 应该输出: v18.x.x 或更高

REM 检查 pnpm
pnpm --version
REM 应该输出: 8.x.x 或更高

REM 检查端口占用
netstat -ano | findstr :5000
netstat -ano | findstr :8001
REM 如果有输出，说明端口被占用

REM 检查进程
tasklist | findstr python
tasklist | findstr node
REM 应该看到相关进程
```

---

## ❌ 常见错误及解决方案

### 错误 1：'python' 不是内部或外部命令

**症状**：
```
'python' is not recognized as an internal or external command
```

**原因**：Python 未安装或未添加到 PATH

**解决方案**：

**方案 1：重新安装 Python**
1. 下载 Python 3.12：https://www.python.org/downloads/release/python-3127/
2. **重要**：安装时勾选 "Add Python to PATH"
3. 安装完成后重启命令提示符

**方案 2：手动添加到 PATH**
1. 右键"此电脑" → "属性" → "高级系统设置"
2. 点击"环境变量"
3. 在"系统变量"中找到 "Path"，点击"编辑"
4. 添加以下路径（根据你的安装位置调整）：
   ```
   C:\Python312\Scripts\
   C:\Python312\
   ```
5. 重启命令提示符

**验证**：
```cmd
python --version
```

---

### 错误 2：pip 安装失败

**症状**：
```
ERROR: Could not find a version that satisfies the requirement
```

**原因**：网络问题或 pip 版本过旧

**解决方案**：

**方案 1：更新 pip**
```cmd
python -m pip install --upgrade pip
```

**方案 2：使用国内镜像**
```cmd
cd backend
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
```

**方案 3：使用阿里云镜像**
```cmd
pip install -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/
```

**方案 4：手动逐个安装**
```cmd
pip install fastapi uvicorn python-multipart -i https://pypi.tuna.tsinghua.edu.cn/simple
pip install paddlepaddle paddleocr -i https://pypi.tuna.tsinghua.edu.cn/simple
pip install Pillow numpy opencv-python-headless -i https://pypi.tuna.tsinghua.edu.cn/simple
pip install pydantic pydantic-settings python-dotenv -i https://pypi.tuna.tsinghua.edu.cn/simple
```

---

### 错误 3：PaddleOCR 安装失败

**症状**：
```
ERROR: Could not build wheels for paddlepaddle
```

**原因**：缺少 C++ 编译器或 Python 版本不匹配

**解决方案**：

**方案 1：使用预编译版本**
```cmd
pip install paddlepaddle -i https://mirror.baidu.com/pypi/simple
```

**方案 2：安装 CPU 版本**
```cmd
pip install paddlepaddle -i https://pypi.tuna.tsinghua.edu.cn/simple
pip install paddleocr -i https://pypi.tuna.tsinghua.edu.cn/simple
```

**方案 3：检查 Python 版本**
```cmd
python --version
REM 必须是 Python 3.12.x
```

如果不是 3.12，请下载并安装 Python 3.12

---

### 错误 4：导入模块失败

**症状**：
```
ModuleNotFoundError: No module named 'paddleocr'
```

**原因**：依赖未正确安装或虚拟环境问题

**解决方案**：

**方案 1：重新安装依赖**
```cmd
cd backend
pip uninstall paddleocr paddlepaddle -y
pip install paddleocr paddlepaddle -i https://pypi.tuna.tsinghua.edu.cn/simple
```

**方案 2：检查安装位置**
```cmd
pip show paddleocr
```
查看 `Location` 字段，确认安装路径

**方案 3：使用 Python 运行**
```cmd
cd backend
python main.py
```

---

### 错误 5：端口被占用

**症状**：
```
Error: Port 5000 is already in use
```

**原因**：其他程序占用了端口

**解决方案**：

**方案 1：查找并结束进程**
```cmd
REM 查找占用 5000 端口的进程
netstat -ano | findstr :5000

REM 结束进程（替换 <PID> 为实际的进程 ID）
taskkill /PID <PID> /F
```

**方案 2：更改端口**
```cmd
REM 修改 .env 文件
echo PORT=5001 > .env
```

**方案 3：重启电脑**
最简单的方法，但可能不是最优解

---

### 错误 6：前端构建失败

**症状**：
```
Error: Cannot find module 'xxx'
```

**原因**：Node.js 依赖未安装

**解决方案**：

**方案 1：清除缓存并重新安装**
```cmd
rmdir /s /q node_modules
del pnpm-lock.yaml
pnpm install
```

**方案 2：使用 npm 代替 pnpm**
```cmd
npm install
npm run build
```

**方案 3：检查 Node.js 版本**
```cmd
node --version
REM 应该是 v18.x.x 或更高
```

---

### 错误 7：模型下载失败

**症状**：
```
Model download timeout or connection error
```

**原因**：网络问题或防火墙阻止

**解决方案**：

**方案 1：设置国内镜像**
```cmd
set HF_ENDPOINT=https://hf-mirror.com
```

**方案 2：手动下载模型**
1. 访问 PaddleOCR 模型仓库
2. 下载模型文件到 `backend/models/` 目录

**方案 3：使用代理**
```cmd
set HTTP_PROXY=http://proxy:port
set HTTPS_PROXY=http://proxy:port
```

---

### 错误 8：后端启动后无响应

**症状**：
```
Backend starts but no response
```

**原因**：PaddleOCR 模型加载失败或内存不足

**解决方案**：

**方案 1：检查日志**
```cmd
type logs\backend.log
```

**方案 2：增加内存**
- 关闭其他程序
- 增加虚拟内存

**方案 3：使用 CPU 模式**
编辑 `backend/main.py`：
```python
ocr = PaddleOCR(use_angle_cls=True, lang="ch", use_gpu=False)
```

---

### 错误 9：前端无法连接后端

**症状**：
```
Network Error: Failed to connect to backend
```

**原因**：后端未启动或端口错误

**解决方案**：

**方案 1：检查后端是否运行**
```cmd
netstat -ano | findstr :8001
```

**方案 2：检查防火墙**
1. 打开"Windows Defender 防火墙"
2. 点击"允许应用通过防火墙"
3. 添加 Python 和 Node.js

**方案 3：检查配置**
```cmd
type .env
REM 确保 PADDLEOCR_API_URL=http://localhost:8001
```

---

### 错误 10：OCR 识别结果不准确

**症状**：
```
OCR recognition results are incorrect
```

**原因**：图片质量差或识别模式不当

**解决方案**：

**方案 1：提高图片质量**
- 确保图片清晰
- 使用适当的分辨率（800-1200 像素）
- 避免模糊、反光

**方案 2：调整识别模式**
- 尝试不同的识别模式
- 使用模板框选模式

**方案 3：预处理图片**
```python
# 在上传前调整图片对比度和亮度
```

---

## 🔍 高级诊断

### 查看详细日志

**后端日志**：
```cmd
type logs\backend.log
```

**前端日志**：
1. 打开浏览器
2. 按 F12 打开开发者工具
3. 切换到 "Console" 标签

### 检查系统资源

```cmd
REM 检查内存
wmic OS get TotalVisibleMemorySize,FreePhysicalMemory /format:table

REM 检查磁盘空间
wmic logicaldisk get size,freespace,caption
```

### 测试服务

**测试后端**：
```cmd
curl http://localhost:8001/health
```

**测试前端**：
```cmd
curl http://localhost:5000
```

---

## 🛠️ 工具和实用程序

### 推荐工具

1. **7-Zip** - 解压文件
   - https://www.7-zip.org/

2. **Process Explorer** - 查看进程
   - https://learn.microsoft.com/en-us/sysinternals/downloads/process-explorer

3. **TCPView** - 查看端口占用
   - https://learn.microsoft.com/en-us/sysinternals/downloads/tcpview

4. **PowerShell** - 高级诊断
   - Windows 自带

---

## 📞 获取帮助

### 收集诊断信息

创建一个批处理文件 `diagnose.bat`：

```batch
@echo off
echo System Information > diagnose.txt
echo ==================== >> diagnose.txt

echo. >> diagnose.txt
echo Python Version: >> diagnose.txt
python --version >> diagnose.txt 2>&1

echo. >> diagnose.txt
echo Node Version: >> diagnose.txt
node --version >> diagnose.txt 2>&1

echo. >> diagnose.txt
echo pnpm Version: >> diagnose.txt
pnpm --version >> diagnose.txt 2>&1

echo. >> diagnose.txt
echo Port 5000: >> diagnose.txt
netstat -ano | findstr :5000 >> diagnose.txt 2>&1

echo. >> diagnose.txt
echo Port 8001: >> diagnose.txt
netstat -ano | findstr :8001 >> diagnose.txt 2>&1

echo. >> diagnose.txt
echo Running Processes: >> diagnose.txt
tasklist | findstr python >> diagnose.txt 2>&1
tasklist | findstr node >> diagnose.txt 2>&1

echo. >> diagnose.txt
echo Backend Log (last 20 lines): >> diagnose.txt
powershell "Get-Content logs\backend.log -Tail 20" >> diagnose.txt 2>&1

echo.
echo Diagnosis saved to diagnose.txt
pause
```

运行后，将 `diagnose.txt` 的内容发送给技术支持。

---

## ✅ 预防措施

1. **定期更新依赖**
   ```cmd
   cd backend
   pip install --upgrade -r requirements.txt
   cd ..
   pnpm update
   ```

2. **保持系统清洁**
   ```cmd
   # 清理 pip 缓存
   pip cache purge

   # 清理 npm 缓存
   pnpm store prune
   ```

3. **备份配置**
   - 备份 `.env` 文件
   - 备份 `models/` 目录

---

**最后更新**：2025-02-04
