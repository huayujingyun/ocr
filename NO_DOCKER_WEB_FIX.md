# 非 Docker 版本 - 网页无法打开问题诊断

## 🔍 快速诊断

### 步骤 1：运行诊断工具

运行 `diagnose-no-docker.bat`

这会检查：
- Python 进程是否运行
- Node.js 进程是否运行
- 端口 5000 和 8001 是否被占用
- 后端 API 是否响应
- 前端是否响应
- 日志文件内容

---

## 🎯 常见问题及解决方案

### 问题 1：后端服务未启动

**症状**：
```
[ERROR] No Python processes found!
[ERROR] Port 8001 is NOT in use!
```

**解决方案**：

**方法 1：手动启动后端**
```cmd
cd backend
python main.py
```

保持这个窗口打开，不要关闭。

**方法 2：检查 Python 版本**
```cmd
python --version
```
必须显示 `Python 3.12.x`，如果不是，请重新安装 Python 3.12。

**方法 3：检查依赖**
```cmd
cd backend
pip list | findstr paddle
```
如果没有 paddleocr，安装依赖：
```cmd
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
```

---

### 问题 2：前端服务未启动

**症状**：
```
[ERROR] No Node.js processes found!
[ERROR] Port 5000 is NOT in use!
```

**解决方案**：

**方法 1：手动启动前端**
```cmd
cd ..
pnpm run start
```

**方法 2：检查 pnpm**
```cmd
pnpm --version
```
如果没有安装：
```cmd
npm install -g pnpm
```

**方法 3：重新安装依赖**
```cmd
pnpm install
```

---

### 问题 3：端口被占用

**症状**：
```
[ERROR] Port 5000/8001 is already in use
```

**解决方案**：

**查找占用端口的进程**：
```cmd
netstat -ano | findstr :5000
netstat -ano | findstr :8001
```

**结束进程**：
```cmd
taskkill /PID <进程ID> /F
```

**或者更改端口**：
编辑 `.env` 文件：
```
PORT=5001
```

---

### 问题 4：后端启动但有错误

**查看后端日志**：
```cmd
type logs\backend.log
```

**常见错误及解决**：

**错误 A：ModuleNotFoundError**
```cmd
cd backend
pip install <缺失的模块名> -i https://pypi.tuna.tsinghua.edu.cn/simple
```

**错误 B：模型下载失败**
```cmd
set HF_ENDPOINT=https://hf-mirror.com
cd backend
python main.py
```

**错误 C：端口绑定失败**
```cmd
# 检查端口 8001 是否被占用
netstat -ano | findstr :8001

# 如果被占用，结束进程
taskkill /PID <进程ID> /F
```

---

### 问题 5：前端启动但有错误

**查看前端错误**：
1. 打开浏览器
2. 按 F12 打开开发者工具
3. 切换到 Console 标签
4. 查看错误信息

**常见错误及解决**：

**错误 A：Cannot find module**
```cmd
pnpm install
```

**错误 B：Next.js build failed**
```cmd
pnpm run build
```

**错误 C：Failed to connect to backend**
检查后端是否运行：
```cmd
curl http://localhost:8001/health
```

如果后端未运行，先启动后端。

---

## 🚀 完整的手动启动步骤

### 第 1 步：启动后端

打开第一个命令提示符窗口：

```cmd
cd backend
python main.py
```

**保持这个窗口打开！** 您应该看到：
```
INFO:     Started server process
INFO:     Uvicorn running on http://0.0.0.0:8001
```

### 第 2 步：启动前端（新窗口）

打开第二个命令提示符窗口：

```cmd
cd ..
pnpm run start
```

**保持这个窗口打开！** 您应该看到：
```
ready - started server on 0.0.0.0:5000, url: http://localhost:5000
```

### 第 3 步：访问网页

打开浏览器，访问：
```
http://localhost:5000
```

---

## 🔧 一键启动脚本修复

如果 `start-all-no-docker.bat` 有问题，使用这个修复版本：

```batch
@echo off
chcp 65001 >nul 2>&1
title Start Services - Fixed Version
color 0A

echo.
echo ==========================================
echo  Starting Services
echo ==========================================
echo.

REM Check if backend is already running
curl -s http://localhost:8001/health >nul 2>&1
if %errorLevel% equ 0 (
    echo [INFO] Backend is already running
) else (
    echo Starting backend service...
    cd backend
    start "PaddleOCR Backend" python main.py
    cd ..
    echo [OK] Backend started
    echo Waiting 5 seconds for backend to initialize...
    timeout /t 5 /nobreak >nul
)

REM Check if frontend is already running
curl -s http://localhost:5000 >nul 2>&1
if %errorLevel% equ 0 (
    echo [INFO] Frontend is already running
) else (
    echo Starting frontend service...
    start "Frontend" cmd /c "pnpm run start"
    echo [OK] Frontend started
)

echo.
echo Waiting for services to be ready...
timeout /t 5 /nobreak >nul

echo.
echo ==========================================
echo  Service Status
echo ==========================================
echo.

curl -s http://localhost:8001/health >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] Backend: http://localhost:8001
) else (
    echo [ERROR] Backend is NOT responding!
)

curl -s -o nul -w "Frontend HTTP Status: %%{http_code}\n" http://localhost:5000
if %errorLevel% equ 0 (
    echo [OK] Frontend: http://localhost:5000
) else (
    echo [ERROR] Frontend is NOT responding!
)

echo.
echo Opening browser...
timeout /t 2 /nobreak >nul
start http://localhost:5000

echo.
echo ==========================================
echo.

echo Press any key to view service status...
pause >nul

REM Show status
echo.
echo Current processes:
tasklist | findstr python
tasklist | findstr node

echo.
echo Port status:
netstat -ano | findstr :5000
netstat -ano | findstr :8001

echo.
echo Press any key to stop all services...
pause >nul

echo.
echo Stopping services...

taskkill /F /FI "WINDOWTITLE eq PaddleOCR Backend*" >nul 2>&1
taskkill /F /IM python.exe >nul 2>&1
taskkill /F /IM node.exe >nul 2>&1

echo [OK] All services stopped.
pause
```

保存为 `start-services-fixed.bat`

---

## 📋 检查清单

在报告问题前，请确认：

- [ ] Python 3.12 已安装（`python --version` 显示 3.12.x）
- [ ] Node.js 已安装（`node --version` 显示 v18+）
- [ ] pnpm 已安装（`pnpm --version` 显示版本）
- [ ] 后端依赖已安装（`cd backend && pip list`）
- [ ] 前端依赖已安装（`pnpm list`）
- [ ] 后端已启动（看到 Uvicorn running 消息）
- [ ] 前端已启动（看到 ready started server 消息）
- [ ] 端口未被占用（`netstat` 检查）
- [ ] 防火墙未阻止（Windows Defender 设置）

---

## 🆘 获取帮助

### 收集诊断信息

1. 运行 `diagnose-no-docker.bat`
2. 截图输出
3. 查看日志文件：
   - `logs/backend.log`
   - 浏览器控制台（F12）

### 常见原因

1. **Python 版本不对**：必须是 3.12
2. **依赖未安装**：运行 `install-no-docker.bat`
3. **端口被占用**：结束占用进程或更改端口
4. **防火墙阻止**：允许端口 5000 和 8001
5. **路径错误**：确保在正确的目录运行

---

## ✅ 成功标志

当一切正常时，您应该看到：

```
[OK] Backend: http://localhost:8001
[OK] Frontend: http://localhost:5000
ready - started server on 0.0.0.0:5000, url: http://localhost:5000
```

浏览器自动打开，显示购物卡 OCR 识别系统界面！

---

**最后更新**：2025-02-04
**推荐诊断工具**：`diagnose-no-docker.bat`
**推荐启动脚本**：`start-services-fixed.bat`
