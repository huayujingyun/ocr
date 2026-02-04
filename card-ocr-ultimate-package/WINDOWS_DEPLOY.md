# Windows 单机部署指南

## 📋 部署方案概览

本指南提供三种 Windows 部署方案：

| 方案 | 适用场景 | 优点 | 缺点 |
|------|---------|------|------|
| **方案一：Node.js 直接运行** | 开发测试、个人使用 | 安装简单、启动快 | 需要 Node.js 环境 |
| **方案二：Docker Desktop** | 生产环境、隔离部署 | 环境隔离、易迁移 | 需要安装 Docker |
| **方案三：打包成桌面应用** | 最终用户、无技术背景 | 双击运行、无依赖 | 文件较大、打包复杂 |

---

## 🚀 方案一：Node.js 直接运行（推荐）

### 系统要求
- **操作系统**: Windows 10/11
- **内存**: 4GB 及以上
- **磁盘**: 5GB 可用空间
- **网络**: 可访问外网

### 步骤 1: 下载项目压缩包

访问以下地址下载项目压缩包：
```
https://coze-coding-project.tos.coze.site/coze_storage_7591464861117481002/card-ocr-app.tar_b83867ca.gz?sign=1768399853-b45f1358ec-0-547603e7809ad0a85ecb8bb0afa87881d4e497676d08c25ecd4f497fb97d71b6
```

**提示**：
- 如果无法直接下载，可以复制链接到浏览器下载
- 或使用下载工具（如 IDM、迅雷）下载
- 下载后保存到任意目录，例如 `D:\card-ocr`

### 步骤 2: 解压项目

#### 方法 A: 使用 Windows 自带解压
1. 右键点击压缩包 → "提取到当前文件夹"
2. 解压后会得到项目文件

#### 方法 B: 使用 7-Zip（推荐）
1. 下载并安装 7-Zip：https://www.7-zip.org/
2. 右键点击压缩包 → "7-Zip" → "提取到 card-ocr-app\"

#### 方法 C: 使用 PowerShell
```powershell
# 打开 PowerShell，进入下载目录
cd D:\Downloads

# 解压文件（需要安装 7-Zip 并添加到 PATH）
& "C:\Program Files\7-Zip\7z.exe" x card-ocr-app.tar.gz -oD:\card-ocr
```

### 步骤 3: 安装 Node.js 24.x

1. 访问 Node.js 官网：https://nodejs.org/
2. 下载 **LTS** 版本（推荐）或 **Current** 版本（需要 20.x 或更高）
3. 运行安装程序，一路点击"Next"完成安装
4. 打开 PowerShell 或 CMD，验证安装：
```powershell
node --version
npm --version
```

### 步骤 4: 安装 pnpm

打开 PowerShell（管理员），执行：
```powershell
npm install -g pnpm

# 验证安装
pnpm --version
```

### 步骤 5: 安装依赖

打开 PowerShell 或 CMD，进入项目目录：

```powershell
# 进入项目目录
cd D:\card-ocr

# 安装依赖
pnpm install
```

**提示**：
- 预计耗时：3-10 分钟（取决于网络速度）
- 如果安装失败，尝试切换 npm 镜像：
```powershell
pnpm config set registry https://registry.npmmirror.com
pnpm install
```

### 步骤 6: 构建项目

```powershell
# 进入项目目录
cd D:\card-ocr

# 构建生产版本
pnpm build
```

**提示**：
- 预计耗时：2-5 分钟
- 构建成功后会生成 `.next` 文件夹

### 步骤 7: 启动服务

```powershell
# 进入项目目录
cd D:\card-ocr

# 启动服务
pnpm start
```

**提示**：
- 服务启动后，访问：http://localhost:5000
- 保持 PowerShell 窗口打开，关闭窗口会停止服务

### 步骤 8: 创建快捷启动脚本

创建一个 `启动服务.bat` 文件，内容如下：

```batch
@echo off
chcp 65001 > nul
title 购物卡OCR识别系统
echo 正在启动购物卡OCR识别系统...
echo.
cd /d "%~dp0"
pnpm start
pause
```

**使用方法**：
1. 将上面的内容复制到记事本
2. 保存为 `启动服务.bat`（注意选择"所有文件"类型）
3. 放在项目根目录
4. 双击即可启动服务

### 步骤 9: 开机自启（可选）

#### 方法 A: 添加到启动文件夹
1. 按 `Win + R`，输入 `shell:startup`，回车
2. 将 `启动服务.bat` 的快捷方式复制到启动文件夹

#### 方法 B: 使用任务计划程序
1. 按 `Win + R`，输入 `taskschd.msc`，回车
2. 创建基本任务 → 设置触发器"当计算机启动时"
3. 操作选择"启动程序"，选择 `启动服务.bat`

---

## 🐳 方案二：Docker Desktop 部署

### 步骤 1: 安装 Docker Desktop

1. 访问 Docker Desktop 官网：https://www.docker.com/products/docker-desktop/
2. 下载 Windows 版本
3. 运行安装程序，一路点击"Next"
4. 安装完成后重启电脑
5. 启动 Docker Desktop，等待启动完成

### 步骤 2: 下载并解压项目

与方案一的步骤 2 相同。

### 步骤 3: 构建镜像

```powershell
# 进入项目目录
cd D:\card-ocr

# 构建 Docker 镜像
docker build -t card-ocr-app .
```

**提示**：
- 预计耗时：5-15 分钟（首次构建较慢）
- 构建成功后会显示镜像大小

### 步骤 4: 运行容器

```powershell
# 运行容器
docker run -d --name card-ocr -p 5000:5000 card-ocr-app

# 查看容器状态
docker ps

# 查看日志
docker logs -f card-ocr
```

### 步骤 5: 管理容器

```powershell
# 停止容器
docker stop card-ocr

# 启动容器
docker start card-ocr

# 重启容器
docker restart card-ocr

# 删除容器
docker rm -f card-ocr

# 查看资源占用
docker stats card-ocr
```

### 步骤 6: 使用 Docker Compose（推荐）

如果项目包含 `docker-compose.yml` 文件：

```powershell
# 启动服务
docker compose up -d

# 查看日志
docker compose logs -f

# 停止服务
docker compose down

# 重启服务
docker compose restart
```

---

## 🖥️ 方案三：打包成 Windows 桌面应用（高级）

### 概述

使用 **Electron** 将 Next.js 应用打包成独立的 `.exe` 可执行文件，用户无需安装 Node.js 即可运行。

### 优点
- ✅ 双击运行，无需命令行
- ✅ 无需安装 Node.js
- ✅ 可以打包成单个 exe 文件
- ✅ 可以添加桌面图标

### 缺点
- ❌ 文件体积较大（约 150-300MB）
- ❌ 首次打包配置复杂
- ❌ 内存占用较高

### 步骤 1: 安装打包工具

```powershell
# 进入项目目录
cd D:\card-ocr

# 安装 Electron 打包工具
npm install --save-dev electron electron-builder
```

### 步骤 2: 创建 Electron 主进程文件

创建 `electron/main.js`：

```javascript
const { app, BrowserWindow } = require('electron')
const path = require('path')
const { spawn } = require('child_process')

let mainWindow
let serverProcess

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1200,
    height: 800,
    webPreferences: {
      nodeIntegration: true,
      contextIsolation: false
    }
  })

  // 启动 Next.js 服务器
  const isDev = !app.isPackaged
  const nextBin = isDev ? 'node_modules/.bin/next' : 'node_modules/.bin/next'
  
  serverProcess = spawn('node', [nextBin, 'start'], {
    cwd: path.join(__dirname, '..'),
    stdio: 'inherit',
    shell: true
  })

  serverProcess.on('error', (err) => {
    console.error('Failed to start Next.js server:', err)
  })

  // 等待服务器启动后加载页面
  setTimeout(() => {
    mainWindow.loadURL('http://localhost:5000')
  }, 3000)

  mainWindow.on('closed', () => {
    if (serverProcess) {
      serverProcess.kill()
    }
  })
}

app.whenReady().then(createWindow)

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow()
  }
})

app.on('before-quit', () => {
  if (serverProcess) {
    serverProcess.kill()
  }
})
```

### 步骤 3: 配置打包选项

在 `package.json` 中添加：

```json
{
  "main": "electron/main.js",
  "build": {
    "appId": "com.cardocr.app",
    "productName": "购物卡OCR识别系统",
    "directories": {
      "output": "dist"
    },
    "files": [
      "electron/**/*",
      ".next/**/*",
      "node_modules/**/*",
      "public/**/*",
      "package.json"
    ],
    "win": {
      "target": [
        {
          "target": "nsis",
          "arch": ["x64"]
        }
      ],
      "icon": "assets/icon.ico"
    }
  }
}
```

### 步骤 4: 构建桌面应用

```powershell
# 1. 构建项目
pnpm build

# 2. 打包成 exe
pnpm electron-builder --win
```

### 步骤 5: 安装和使用

打包完成后，`dist` 目录下会生成 `购物卡OCR识别系统 Setup x.x.x.exe` 安装包：

1. 双击运行安装程序
2. 按提示完成安装
3. 桌面上会生成快捷方式
4. 双击快捷方式即可启动应用

### 步骤 6: 创建单文件版本（可选）

如果要创建单文件版本（无需安装），修改配置：

```json
{
  "build": {
    "win": {
      "target": "portable",
      "artifactName": "购物卡OCR识别系统.exe"
    }
  }
}
```

---

## 📁 推荐部署方案对比

### 个人使用（推荐方案一）
- ✅ 最简单，5 分钟即可完成
- ✅ 资源占用低
- ✅ 更新方便
- ❌ 需要保持命令行窗口打开

### 企业使用（推荐方案二）
- ✅ 环境隔离，不影响系统
- ✅ 易于迁移和备份
- ✅ 可以批量部署
- ❌ 需要安装 Docker Desktop

### 最终用户（推荐方案三）
- ✅ 双击运行，最友好
- ✅ 无需安装 Node.js
- ✅ 可以添加桌面图标
- ❌ 文件体积大
- ❌ 打包和更新复杂

---

## 🔧 常见问题

### 问题 1: Node.js 安装后无法识别

**解决方案**：
```powershell
# 重新打开 PowerShell 或 CMD
# 或手动添加环境变量
[System.Environment]::SetEnvironmentVariable('Path', $env:Path + ';C:\Program Files\nodejs', 'User')
```

### 问题 2: pnpm 安装失败

**解决方案**：
```powershell
# 方法一：使用 npm 安装
npm install -g pnpm

# 方法二：切换 npm 镜像
pnpm config set registry https://registry.npmmirror.com
pnpm install
```

### 问题 3: 构建时内存不足

**解决方案**：
```powershell
# 增加内存限制
set NODE_OPTIONS=--max-old-space-size=4096
pnpm build
```

### 问题 4: 端口被占用

**解决方案**：
```powershell
# 查看端口占用
netstat -ano | findstr :5000

# 终止进程（将 <PID> 替换为实际进程 ID）
taskkill /PID <PID> /F
```

### 问题 5: Docker Desktop 无法启动

**解决方案**：
1. 确保 Windows 版本支持（Windows 10 1809+）
2. 在 BIOS 中启用虚拟化（Intel VT-x / AMD-V）
3. 启用 Windows 功能：
   - Hyper-V
   - Windows Subsystem for Linux
4. 重启电脑

### 问题 6: Electron 打包失败

**解决方案**：
```powershell
# 清理缓存
rmdir /s /q .next
rmdir /s /q node_modules\.cache

# 重新安装依赖
pnpm install

# 重新构建
pnpm build
pnpm electron-builder --win --dir
```

---

## 🎯 快速部署检查清单

### 方案一：Node.js 直接部署
- [ ] 已下载项目压缩包
- [ ] 已解压项目文件
- [ ] 已安装 Node.js 24.x
- [ ] 已安装 pnpm
- [ ] 已运行 `pnpm install`
- [ ] 已运行 `pnpm build`
- [ ] 已启动服务（http://localhost:5000）
- [ ] 已创建启动脚本（可选）

### 方案二：Docker Desktop 部署
- [ ] 已安装 Docker Desktop
- [ ] 已下载并解压项目
- [ ] 已构建镜像（`docker build`）
- [ ] 已运行容器（`docker run`）
- [ ] 服务可正常访问（http://localhost:5000）
- [ ] 已设置容器开机自启（可选）

### 方案三：Electron 打包
- [ ] 已安装 Electron 和 electron-builder
- [ ] 已创建 Electron 主进程文件
- [ ] 已配置打包选项
- [ ] 已运行 `pnpm build`
- [ ] 已运行 `pnpm electron-builder --win`
- [ ] 已测试生成的 exe 文件

---

## 🚀 一键部署脚本（Windows PowerShell）

创建 `一键部署.ps1` 文件：

```powershell
# 检查是否以管理员身份运行
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "请以管理员身份运行此脚本！"
    pause
    exit
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  购物卡OCR识别系统 - 一键部署脚本" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查 Node.js
Write-Host "检查 Node.js..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version
    Write-Host "✓ Node.js 版本: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ 未检测到 Node.js" -ForegroundColor Red
    Write-Host "请先安装 Node.js: https://nodejs.org/" -ForegroundColor Yellow
    pause
    exit
}

# 检查 pnpm
Write-Host "检查 pnpm..." -ForegroundColor Yellow
try {
    $pnpmVersion = pnpm --version
    Write-Host "✓ pnpm 版本: $pnpmVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ 未检测到 pnpm，正在安装..." -ForegroundColor Red
    npm install -g pnpm
    Write-Host "✓ pnpm 安装完成" -ForegroundColor Green
}

# 安装依赖
Write-Host "安装项目依赖..." -ForegroundColor Yellow
pnpm install
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ 依赖安装失败" -ForegroundColor Red
    pause
    exit
}
Write-Host "✓ 依赖安装完成" -ForegroundColor Green

# 构建项目
Write-Host "构建项目..." -ForegroundColor Yellow
pnpm build
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ 项目构建失败" -ForegroundColor Red
    pause
    exit
}
Write-Host "✓ 项目构建完成" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  部署完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "运行以下命令启动服务：" -ForegroundColor Yellow
Write-Host "  pnpm start" -ForegroundColor Cyan
Write-Host ""
Write-Host "或双击 '启动服务.bat' 文件" -ForegroundColor Yellow
Write-Host ""
Write-Host "访问地址：http://localhost:5000" -ForegroundColor Green
Write-Host ""
pause
```

**使用方法**：
1. 将上面的内容保存为 `一键部署.ps1`
2. 右键点击 → "使用 PowerShell 运行"
3. 等待自动部署完成

---

## 📞 技术支持

如遇到问题：
1. 查看日志：控制台输出的错误信息
2. 检查端口：确认 5000 端口未被占用
3. 重试：删除 `node_modules` 和 `.next`，重新安装依赖
4. 查看文档：参考项目 README.md

---

## ✅ 部署完成

恭喜！您已成功部署购物卡OCR识别系统。

**访问地址**：http://localhost:5000

开始使用吧！🚀
