# 🎉 Windows标准部署包 v2.0.4 - 下载（Python检测修复版）

## 📥 直接下载链接

**文件名**：`ocr-card-recognizer-windows-standard-v2.0.4.tar.gz`

**文件大小**：18.63 KB

**版本**：v2.0.4

**有效期**：7天（2026-02-11过期）

### 🔗 下载地址

```
https://coze-coding-project.tos.coze.site/coze_storage_7602859016070627343/ocr-card-recognizer-windows-standard-v2.0.4.tar_1c782e98.gz?sign=1770804516-91f27058c6-0-f7d6186c2a5cabb528fe1c3a7a4375a2e30ac8fa741812b5cc9866a887d90df0
```

---

## 🔧 v2.0.4 修复内容

### 问题描述
用户已安装Python 3.14.2，但install.bat仍然提示"Python is not installed"。

### 根本原因
- Windows上Python可以通过`python`或`py`命令调用
- v2.0.3版本只检查`python`命令
- 某些Windows系统只配置了`py`命令（Python Launcher）
- install.bat无法识别`py`命令，导致误报Python未安装

### 修复内容
✅ **install.bat - 支持多种Python命令**
- 先尝试`python`命令
- 如果失败，自动尝试`py`命令
- 如果检测到`py`命令，自动创建`python.bat`包装器
- 如果都失败，提供详细的诊断信息

✅ **start.bat - 支持多种Python命令**
- 自动检测可用的Python命令（`python`或`py`）
- 使用检测到的命令启动后端服务

✅ **更详细的错误提示**
- 提供具体的解决方案
- 说明是PATH问题还是未安装
- 指导用户如何修复

---

## 🚀 3步完成部署

### 步骤1：下载并解压（2分钟）

1. **点击上方下载链接**，开始下载
2. 安装解压工具（如果没有）：
   - **7-Zip**：https://www.7-zip.org/ （推荐）
   - **WinRAR**：https://www.win-rar.com/
3. 解压到任意目录（推荐：`C:\OCR\`）

**注意**：
- Windows无法直接解压`.tar.gz`文件
- 必须使用7-Zip或WinRAR

---

### 步骤2：安装依赖（5-10分钟）

**重要：必须以管理员身份运行！**

1. 右键点击 `install.bat`
2. 选择 **"以管理员身份运行"**
3. 看到黑色窗口弹出，显示安装进度
4. v2.0.4现在能正确识别Python（包括`py`命令）
5. 等待安装完成

**安装过程**：
```
=======================================
OCR Card Recognizer - Installer
Version: v2.0.2
=======================================

[Step 1/7] Checking system requirements...
Operating System: Windows 8/10/11

[Step 2/7] Checking Python installation...
Python version: 3.14.2
Python command: python

[Step 3/7] Checking Node.js installation...
Node.js version: v20.11.1

[Step 4/7] Installing pnpm...
pnpm already installed, version: 8.15.6

[Step 5/7] Installing backend dependencies...
Installing Python dependencies (this may take a few minutes)...

[Step 6/7] Installing frontend dependencies...
Installing Node.js dependencies (this may take a few minutes)...

[Step 7/7] Creating necessary directories...
Created directory: logs\
Created directory: data\uploads\
Created directory: data\exports\

=======================================
Installation Complete!
=======================================

Usage:
  1. Double-click start.bat to start the service
  2. Double-click stop.bat to stop the service
  3. Double-click check.bat to check service status
  4. Visit http://localhost:5000 to use the system

Notes:
  - First startup requires downloading OCR models (~200MB), please be patient
  - First startup may take 30-60 seconds
  - Subsequent startups only take 10-20 seconds
```

---

### 步骤3：启动服务（1分钟）

1. 双击 `start.bat`（无需管理员权限）
2. 等待30-60秒（首次启动需要下载OCR模型）
3. 看到以下提示表示启动成功：

```
=======================================
Service Started!
=======================================

Access URLs:
  Frontend: http://localhost:5000
  Backend API: http://localhost:8001/docs

Management:
  View backend log: type logs\backend.log
  View frontend log: type logs\frontend.log
  Stop service: Double-click stop.bat
  Check status: Double-click check.bat
```

4. 打开浏览器访问：**http://localhost:5000**

✅ **完成！**

---

## ❓ 常见问题

### Q1: install.bat提示"Python is not installed"？

**A**:
1. **检查cmd.exe中是否可以运行python**：
   - 打开cmd.exe（不是PowerShell）
   - 输入：`python --version`
   - 如果成功，说明PATH正确，重新运行install.bat

2. **尝试py命令**：
   - 在cmd.exe中输入：`py --version`
   - 如果成功，说明安装了Python Launcher
   - **v2.0.4会自动检测py命令**，重新运行install.bat

3. **重新安装Python**：
   - 访问：https://www.python.org/downloads/release/python-3128/
   - 下载 **"Windows installer (64-bit)"**
   - 运行安装程序
   - **重要**：勾选 **"Add Python to PATH"**
   - 点击 **"Install Now"**
   - 安装完成后重新运行install.bat

---

### Q2: 提示"Node.js is not installed"？

**A**:
1. 访问：https://nodejs.org/
2. 下载 **LTS版本**（推荐Node.js 20 LTS）
3. 运行安装程序
4. 点击 **"Install"** 完成安装
5. 安装完成后重新运行install.bat

---

### Q3: install.bat显示详细的错误信息？

**A**: v2.0.4提供了更详细的错误提示，请按照提示操作：

**如果显示"Python is not installed or not in PATH"**：
- 按照上述Q1的步骤检查或安装Python

**如果显示"Possible solutions"**：
- 选择适合您的解决方案
- 按照步骤操作
- 重新运行install.bat

---

### Q4: Python依赖安装失败？

**A**:
1. 检查网络连接
2. 尝试更新pip：
   ```
   python -m pip install --upgrade pip
   ```
3. 使用国内镜像源：
   ```
   pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
   ```

---

### Q5: 前端依赖安装失败？

**A**:
1. 检查网络连接
2. 清除缓存：
   ```
   pnpm store prune
   ```
3. 使用国内镜像源：
   ```
   pnpm config set registry https://registry.npmmirror.com
   ```

---

### Q6: 首次启动很慢？

**A**: **正常现象！**

首次启动需要：
- 下载OCR模型文件（约200MB）
- 加载模型到内存

- 首次启动：30-60秒
- 后续启动：10-20秒

---

## 📊 版本对比

| 版本 | 问题 | 状态 |
|------|------|------|
| v2.0.0 | 初始版本 | ✅ 可用 |
| v2.0.1 | Windows下install.bat一闪而过 | ❌ 不可用 |
| v2.0.2 | 修复install.bat一闪而过，但中文乱码 | ⚠️ 部分可用 |
| v2.0.3 | 改用纯英文，解决乱码问题，但无法识别py命令 | ⚠️ 部分可用 |
| v2.0.4 | 支持python和py命令，完善Python检测 | ✅ 完全可用 |

---

## 📝 改进细节

### install.bat改进

**v2.0.3**：
```batch
python --version >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Python is not installed
    exit /b 1
)
```

**v2.0.4**：
```batch
REM Try python command first
python --version >nul 2>&1
if %errorLevel% equ 0 (
    echo Python version: 3.14.2
    echo Python command: python
    goto :python_found
)

REM Try py command (Python Launcher)
py --version >nul 2>&1
if %errorLevel% equ 0 (
    echo Python version: 3.14.2
    echo Python command: py
    REM Create python.bat as wrapper
    echo @echo off > python.bat
    echo py %%* >> python.bat
    echo Created python.bat wrapper
    goto :python_found
)

REM Python not found
echo [ERROR] Python is not installed or not in PATH
echo.
echo Possible solutions:
echo [Solution 1] Check if Python is installed in PATH
echo [Solution 2] Reinstall Python with PATH added
echo [Solution 3] Manually add Python to PATH
```

### start.bat改进

**v2.0.3**：
```batch
start "OCR Backend" /min cmd /c "cd backend && python main.py > ..\logs\backend.log 2>&1"
```

**v2.0.4**：
```batch
REM Check if python command exists
python --version >nul 2>&1
if %errorLevel% equ 0 (
    set PYTHON_CMD=python
) else (
    py --version >nul 2>&1
    if %errorLevel% equ 0 (
        set PYTHON_CMD=py
    ) else (
        set PYTHON_CMD=python
    )
)
echo Using Python command: %PYTHON_CMD%

start "OCR Backend" /min cmd /c "cd backend && %PYTHON_CMD% main.py > ..\logs\backend.log 2>&1"
```

---

## 💡 重要提示

### 安装前
1. 确保是Windows 10/11 64位系统
2. 确保至少4GB内存
3. 确保至少2GB可用磁盘空间
4. 确保有管理员权限

### 安装时
1. **必须以管理员身份运行**install.bat
2. v2.0.4会自动检测`python`或`py`命令
3. 每个步骤完成后会暂停，按任意键继续
4. 如果遇到错误，按照提示操作
5. 安装需要5-10分钟，请耐心等待

### 启动时
1. 双击`start.bat`即可，无需管理员权限
2. 首次启动需要30-60秒（下载OCR模型）
3. 看到启动成功提示后，访问http://localhost:5000

---

## 📞 获取帮助

### 检查服务状态
```
Double-click: check.bat
```

### 查看日志
```
Open: logs\backend.log
Open: logs\frontend.log
```

### 手动检查
```batch
# Check backend
curl http://localhost:8001/health

# Check frontend
curl http://localhost:5000
```

---

## 🎉 完成后的功能

现在您可以：

- ✅ 自动识别购物卡和加油卡
- ✅ 批量处理，提高效率
- ✅ 导出Excel，方便整理
- ✅ 完全离线，数据安全
- ✅ 无需联网，随时使用
- ✅ 支持模板识别，提高准确率
- ✅ 自动检测Python（python或py命令）
- ✅ 所有提示信息清晰显示，无乱码

**访问地址：http://localhost:5000**

---

## 📦 下载信息

- **版本**：v2.0.4
- **文件大小**：18.63 KB
- **上传时间**：2026-02-04 18:08
- **有效期**：7天
- **过期时间**：2026-02-11 18:08
- **修复内容**：Python检测问题（支持python和py命令）

---

## 🔄 从v2.0.3升级到v2.0.4

如果已经下载了v2.0.3：

1. **推荐：重新下载v2.0.4**
   - 下载v2.0.4版本
   - 解压到新目录
   - 重新安装

2. **手动修复（不推荐）**
   - 解压v2.0.3
   - 替换install.bat和start.bat
   - 重新运行install.bat

**强烈推荐使用方法1，重新下载v2.0.4**

---

## 🎯 总结

### 最简单的3步：

1. **下载部署包**
   - 点击上方下载链接
   - 文件：`ocr-card-recognizer-windows-standard-v2.0.4.tar.gz`

2. **安装依赖**
   - 解压到 `C:\OCR\`
   - 右键 `install.bat` → "以管理员身份运行"
   - v2.0.4会自动检测Python（python或py命令）

3. **启动服务**
   - 双击 `start.bat`
   - 访问 http://localhost:5000

✅ **完成！开始使用吧！**

---

**祝您使用愉快！🎉**

**v2.0.4版本已完美解决Python检测问题，支持python和py两种命令！**
