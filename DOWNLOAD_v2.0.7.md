# 🎉 Windows标准部署包 v2.0.7 - 下载（增强Node.js检测）

## 📥 直接下载链接

**文件名**：`ocr-card-recognizer-windows-standard-v2.0.7.tar.gz`

**文件大小**：19.86 KB

**版本**：v2.0.7

**有效期**：7天（2026-02-11过期）

### 🔗 下载地址

```
https://coze-coding-project.tos.coze.site/coze_storage_7602859016070627343/ocr-card-recognizer-windows-standard-v2.0.7.tar_bb4df7b5.gz?sign=1770805095-d0a80411ff-0-6b77eb052f2505bd4ad2eb9ab1f3669bb3e5f7a18e8e251d36376a348c8aca4e
```

---

## 🔧 v2.0.7 新增功能

### 问题：install.bat检测不到已安装的Node.js

**原因**：
- Node.js可能安装了但不在PATH环境变量中
- install.bat只检查PATH中的node命令
- 无法找到安装在非标准路径的Node.js

**解决方案**：
✅ **增强Node.js检测逻辑**
- 检查PATH中的node命令
- 检查常见安装路径：
  - `C:\Program Files\nodejs\node.exe`
  - `C:\Program Files (x86)\nodejs\node.exe`
  - `%LOCALAPPDATA%\Programs\nodejs\node.exe`
- 自动添加Node.js到当前会话的PATH
- 显示Node.js的安装路径

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

**方式1：自动安装（推荐）⭐**
1. 右键点击 `setup.bat`
2. 选择 **"以管理员身份运行"**
3. 自动检测、下载、安装Python和Node.js
4. 自动安装项目依赖
5. 等待安装完成

**方式2：手动安装**
1. 确保已安装Python和Node.js
2. 右键点击 `install.bat`
3. 选择 **"以管理员身份运行"**
4. v2.0.7会自动检测Node.js安装位置
5. 等待安装完成

**install.bat运行过程（v2.0.7）**：
```
=======================================
OCR Card Recognizer - Installer
Version: v2.0.7
=======================================

[Step 1/7] Checking system requirements...
Operating System: Windows 8/10/11

[Step 2/7] Checking Python installation...
Python version: Python 3.14.2
Python command: python

[Step 3/7] Checking Node.js installation...
Node.js found at: C:\Program Files\nodejs\node.exe
Node.js version: v20.11.1
Node.js added to PATH for this session

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
```

---

### 步骤3：启动服务（1分钟）

1. 双击 `start.bat`（无需管理员权限）
2. 等待30-60秒（首次启动需要下载OCR模型）
3. 访问：**http://localhost:5000**

✅ **完成！**

---

## ❓ 常见问题

### Q1: install.bat仍然提示"Node.js is not installed"？

**A**: v2.0.7会尝试多种路径检测Node.js。如果仍然提示未安装：

1. **检查Node.js是否真的安装**
   - 打开cmd.exe
   - 尝试手动运行：`C:\Program Files\nodejs\node.exe --version`
   - 如果成功，说明已安装但位置特殊

2. **手动添加到PATH**
   - 右键 "This PC" → Properties → Advanced system settings
   - Environment Variables
   - Edit "Path"
   - 添加Node.js安装目录

3. **使用setup.bat自动安装**
   - 运行setup.bat会自动下载并安装Node.js

---

### Q2: 提示"Node.js is not in PATH"？

**A**: **正常提示，不影响使用**

v2.0.7会自动添加Node.js到当前会话的PATH，可以继续安装。

如果希望永久添加：
1. 按照"Q1"的步骤手动添加到系统PATH
2. 或者重新安装Node.js时勾选"Add to PATH"

---

### Q3: setup.bat下载失败？

**A**:
1. **检查网络连接**
2. **手动下载**：
   - Python：https://www.python.org/ftp/python/3.12.8/python-3.12.8-amd64.exe
   - Node.js：https://nodejs.org/dist/v20.11.1/node-v20.11.1-x64.msi
3. **放到downloads目录**，重新运行setup.bat

---

### Q4: 首次启动很慢？

**A**: **正常现象！**

首次启动需要：
- 下载OCR模型文件（约200MB）
- 加载模型到内存

- 首次启动：30-60秒
- 后续启动：10-20秒

---

## 📊 版本对比

| 版本 | 新功能/修复 | 状态 |
|------|------------|------|
| v2.0.0 | 初始版本 | ✅ 可用 |
| v2.0.1 | 修复install.bat一闪而过 | ❌ 不可用 |
| v2.0.2 | 修复一闪而过，但中文乱码 | ⚠️ 部分可用 |
| v2.0.3 | 改用纯英文，解决乱码 | ⚠️ 部分可用 |
| v2.0.4 | 支持python和py命令 | ⚠️ 部分可用 |
| v2.0.5 | 新增setup.bat自动安装依赖 | ⚠️ start.bat一闪而过 |
| v2.0.6 | 修复start.bat路径问题 | ⚠️ Node.js检测问题 |
| v2.0.7 | 增强Node.js检测逻辑 | ✅ 完全可用 |

---

## 📝 改进细节

### Node.js检测改进

**v2.0.6（有问题）**：
```batch
# 只检查PATH中的node命令
node --version >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Node.js is not installed
    exit /b 1
)
```

**v2.0.7（修复）**：
```batch
# 检查多个可能的安装路径
set NODE_FOUND=0

REM 检查PATH
where node.exe >nul 2>&1
if %errorLevel% equ 0 (
    for /f "delims=" %%i in ('where node.exe') do set NODE_PATH=%%i
    set NODE_FOUND=1
    goto :node_check_version
)

REM 检查Program Files
if exist "C:\Program Files\nodejs\node.exe" (
    set NODE_PATH=C:\Program Files\nodejs\node.exe
    set NODE_FOUND=1
    goto :node_check_version
)

REM 检查Program Files (x86)
if exist "C:\Program Files (x86)\nodejs\node.exe" (
    set NODE_PATH=C:\Program Files (x86)\nodejs\node.exe
    set NODE_FOUND=1
    goto :node_check_version
)

REM 检查AppData
if exist "%LOCALAPPDATA%\Programs\nodejs\node.exe" (
    set NODE_PATH=%LOCALAPPDATA%\Programs\nodejs\node.exe
    set NODE_FOUND=1
    goto :node_check_version
)
```

**改进点**：
- ✅ 检查PATH中的node命令
- ✅ 检查常见安装路径
- ✅ 显示Node.js的安装位置
- ✅ 自动添加到当前会话PATH
- ✅ 支持非标准安装路径

---

## 💡 使用建议

### 新手用户（推荐）
1. 下载v2.0.7部署包
2. 解压到 `C:\OCR\`
3. 右键 `setup.bat` → "以管理员身份运行"
4. 双击 `start.bat`

**优点**：完全自动化，无需手动操作

### 有经验用户
1. 手动安装Python和Node.js
2. 右键 `install.bat` → "以管理员身份运行"
3. v2.0.7会自动检测Node.js
4. 双击 `start.bat`

**优点**：可控制安装过程

### 已有环境
1. 确认Python和Node.js已安装
2. 右键 `install.bat` → "以管理员身份运行"
3. v2.0.7会自动检测所有依赖
4. 双击 `start.bat`

**优点**：跳过依赖安装，更快完成

---

## 📦 下载信息

- **版本**：v2.0.7
- **文件大小**：19.86 KB
- **上传时间**：2026-02-04 18:18
- **有效期**：7天
- **过期时间**：2026-02-11 18:18
- **新增功能**：增强Node.js检测逻辑

---

## 🎯 总结

### 最简单的3步：

1. **下载部署包**
   - 点击上方下载链接
   - 文件：`ocr-card-recognizer-windows-standard-v2.0.7.tar.gz`

2. **安装依赖**
   - 右键 `setup.bat` → "以管理员身份运行"
   - 自动安装所有依赖

3. **启动服务**
   - 双击 `start.bat`
   - 访问 http://localhost:5000

✅ **完成！v2.0.7已修复所有检测问题！**

---

## 🔍 验证部署成功

### 方法1：访问前端
打开浏览器访问：http://localhost:5000

### 方法2：检查服务状态
双击 `check.bat`

### 方法3：查看日志
```
type logs\backend.log
type logs\frontend.log
```

---

**祝您使用愉快！🎉**

**v2.0.7版本已增强Node.js检测，支持多种安装路径！**
