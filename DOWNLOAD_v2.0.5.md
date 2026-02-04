# 🎉 Windows标准部署包 v2.0.5 - 下载（自动安装依赖版）

## 📥 直接下载链接

**文件名**：`ocr-card-recognizer-windows-standard-v2.0.5.tar.gz`

**文件大小**：19.53 KB

**版本**：v2.0.5

**有效期**：7天（2026-02-11过期）

### 🔗 下载地址

```
https://coze-coding-project.tos.coze.site/coze_storage_7602859016070627343/ocr-card-recognizer-windows-standard-v2.0.5.tar_c430c1b1.gz?sign=1770804775-e543f3ad11-0-79a5397a487ce73a211094e3b8511aaf5b85642e1e75dbb86c3144fbb43ffeb6
```

---

## 🔧 v2.0.5 新增功能

### 新增：setup.bat - 自动安装依赖

**问题**：
- 用户不知道如何安装Python和Node.js
- 手动安装步骤繁琐，容易出错
- 不确定需要安装哪些版本

**解决方案**：
✅ **新增setup.bat脚本**
- 自动检测Python和Node.js是否安装
- 自动下载Python 3.12.8安装程序
- 自动下载Node.js 20 LTS安装程序
- 自动启动安装程序
- 安装完成后自动重启脚本检测
- 完成后自动调用install.bat安装项目依赖

### 修复内容

✅ **修复Python版本显示为空的问题**
- 使用`tokens=*`代替`tokens=2`
- 确保完整显示Python版本信息

✅ **修复Node.js版本显示**
- 使用`tokens=*`确保完整显示

---

## 🚀 最简单的2步部署（推荐）

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

### 步骤2：一键自动安装（10-15分钟）

**重要：必须以管理员身份运行！**

1. 右键点击 **`setup.bat`** ⭐（新增！）
2. 选择 **"以管理员身份运行"**
3. 看到黑色窗口弹出，显示安装进度
4. 脚本会自动：
   - 检测Python和Node.js是否安装
   - 如果未安装，自动下载安装程序
   - 自动启动安装程序
   - 安装完成后自动检测
   - 自动调用install.bat安装项目依赖
5. 等待所有安装完成

**setup.bat运行过程**：
```
=======================================
OCR Card Recognizer - Auto Install Dependencies
=======================================

[Step 1/4] Checking Python installation...
[NOT INSTALLED] Python is not installed

[Step 2/4] Checking Node.js installation...
[NOT INSTALLED] Node.js is not installed

Installation Summary:
[ ] Python 3.12
[ ] Node.js 20 LTS

[Step 3/4] Downloading missing dependencies...

[DOWNLOAD] Python 3.12.8 installer...
Download URL: https://www.python.org/ftp/python/3.12.8/python-3.12.8-amd64.exe
Please wait while downloading...
[OK] Python installer downloaded to downloads\python-installer.exe

[DOWNLOAD] Node.js 20 LTS installer...
Download URL: https://nodejs.org/dist/v20.11.1/node-v20.11.1-x64.msi
Please wait while downloading...
[OK] Node.js installer downloaded to downloads\nodejs-installer.msi

[Step 4/4] Installing dependencies...

[INSTALL] Python 3.12.8...
Starting installer in 3 seconds...

[INSTALL] Node.js 20 LTS...
Starting installer in 3 seconds...

[OK] Installation Complete!

Installation Complete!

IMPORTANT: You need to restart this script or open a new cmd window
to make the environment changes take effect.

Press any key to restart the script...
```

**install.bat运行过程**（setup.bat自动调用）：
```
=======================================
OCR Card Recognizer - Installer
Version: v2.0.5
=======================================

[Step 1/7] Checking system requirements...
Operating System: Windows 8/10/11

[Step 2/7] Checking Python installation...
Python version: Python 3.14.2
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

## 📊 部署方式对比

### 方式1：自动安装（推荐）⭐

**适用场景**：
- 第一次部署
- 不熟悉Python和Node.js安装
- 希望一键完成所有依赖安装

**步骤**：
1. 解压部署包
2. 右键 `setup.bat` → "以管理员身份运行"
3. 双击 `start.bat`

**优点**：
- ✅ 全自动化
- ✅ 自动下载和安装依赖
- ✅ 无需手动操作
- ✅ 适合新手

**时间**：10-15分钟

---

### 方式2：手动安装

**适用场景**：
- 已安装Python和Node.js
- 熟悉环境配置
- 希望手动控制安装过程

**步骤**：
1. 解压部署包
2. 手动安装Python（如果未安装）
3. 手动安装Node.js（如果未安装）
4. 右键 `install.bat` → "以管理员身份运行"
5. 双击 `start.bat`

**优点**：
- ✅ 可控制安装过程
- ✅ 可选择特定版本
- ✅ 适合高级用户

**时间**：5-10分钟（如果已安装依赖）

---

## ❓ 常见问题

### Q1: setup.bat下载速度慢？

**A**:
1. **耐心等待**：Python安装程序约25MB，Node.js安装程序约30MB
2. **检查网络**：确保网络连接稳定
3. **手动下载**：如果自动下载失败，可以手动下载：
   - Python：https://www.python.org/ftp/python/3.12.8/python-3.12.8-amd64.exe
   - Node.js：https://nodejs.org/dist/v20.11.1/node-v20.11.1-x64.msi
4. **手动安装**：下载后放到`downloads`目录，重新运行setup.bat

---

### Q2: Python安装时忘记勾选"Add Python to PATH"？

**A**:
1. setup.bat会检测到Python已安装
2. 但install.bat可能找不到Python命令
3. 解决方案：
   - 方案1：卸载Python，重新运行setup.bat
   - 方案2：手动添加Python到PATH环境变量

---

### Q3: 安装后找不到python命令？

**A**:
1. **重启cmd窗口**：安装完成后必须打开新的cmd窗口
2. **检查PATH**：在cmd中输入`python --version`
3. **重新运行**：如果仍然不行，重启电脑

---

### Q4: 首次启动很慢？

**A**: **正常现象！**

首次启动需要：
- 下载OCR模型文件（约200MB）
- 加载模型到内存

- 首次启动：30-60秒
- 后续启动：10-20秒

---

## 📝 文件说明

### setup.bat ⭐（新增）
**用途**：自动安装Python和Node.js
**运行方式**：右键 → "以管理员身份运行"
**功能**：
- 检测依赖是否安装
- 自动下载安装程序
- 自动启动安装
- 自动调用install.bat

### install.bat
**用途**：安装项目依赖
**运行方式**：右键 → "以管理员身份运行"
**前提**：Python和Node.js已安装
**功能**：
- 检查Python和Node.js版本
- 安装pnpm
- 安装后端Python依赖
- 安装前端Node.js依赖
- 创建必要目录

### start.bat
**用途**：启动服务
**运行方式**：双击（无需管理员权限）
**功能**：
- 检查端口占用
- 启动后端服务
- 启动前端服务
- 显示服务状态

### stop.bat
**用途**：停止服务
**运行方式**：双击
**功能**：
- 停止前端服务
- 停止后端服务
- 清理进程残留

### check.bat
**用途**：检查服务状态
**运行方式**：双击
**功能**：
- 显示后端服务状态
- 显示前端服务状态
- 显示进程信息

---

## 📊 版本对比

| 版本 | 新功能 | 状态 |
|------|--------|------|
| v2.0.0 | 初始版本 | ✅ 可用 |
| v2.0.1 | 修复install.bat一闪而过 | ❌ 不可用 |
| v2.0.2 | 修复一闪而过，但中文乱码 | ⚠️ 部分可用 |
| v2.0.3 | 改用纯英文，解决乱码 | ⚠️ 部分可用 |
| v2.0.4 | 支持python和py命令 | ⚠️ 部分可用 |
| v2.0.5 | 新增setup.bat自动安装依赖 | ✅ 完全可用 |

---

## 💡 使用建议

### 新手用户
**推荐方式：自动安装**
1. 解压部署包
2. 右键 `setup.bat` → "以管理员身份运行"
3. 双击 `start.bat`

**优点**：完全自动化，无需手动操作

---

### 有经验用户
**推荐方式：手动安装**
1. 手动安装Python 3.12
2. 手动安装Node.js 20 LTS
3. 右键 `install.bat` → "以管理员身份运行"
4. 双击 `start.bat`

**优点**：可控制安装过程

---

### 已有环境
**推荐方式：直接安装项目依赖**
1. 确认Python和Node.js已安装
2. 右键 `install.bat` → "以管理员身份运行"
3. 双击 `start.bat`

**优点**：跳过依赖安装，更快完成

---

## 🎯 总结

### 最简单的3步：

1. **下载部署包**
   - 点击上方下载链接
   - 文件：`ocr-card-recognizer-windows-standard-v2.0.5.tar.gz`

2. **一键自动安装依赖** ⭐
   - 右键 `setup.bat` → "以管理员身份运行"
   - 自动下载并安装Python和Node.js
   - 自动安装项目依赖

3. **启动服务**
   - 双击 `start.bat`
   - 访问 http://localhost:5000

✅ **完成！开始使用吧！**

---

## 📦 下载信息

- **版本**：v2.0.5
- **文件大小**：19.53 KB
- **上传时间**：2026-02-04 18:12
- **有效期**：7天
- **过期时间**：2026-02-11 18:12
- **新增功能**：setup.bat自动安装依赖

---

## 🔄 从v2.0.4升级到v2.0.5

如果已经下载了v2.0.4：

1. **推荐：重新下载v2.0.5**
   - 下载v2.0.5版本
   - 解压到新目录
   - 使用setup.bat一键安装

2. **手动添加setup.bat（不推荐）**
   - 从v2.0.5中提取setup.bat
   - 复制到v2.0.4目录
   - 重新运行setup.bat

**强烈推荐使用方法1，重新下载v2.0.5**

---

**祝您使用愉快！🎉**

**v2.0.5版本新增setup.bat，一键自动安装所有依赖，超简单！**
