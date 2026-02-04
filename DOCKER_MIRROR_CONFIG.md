# Docker 镜像拉取失败 - 完整解决方案

## 🔍 问题分析

错误信息：
```
failed to fetch oauth token: Post "https://auth.docker.io/token": dial tcp 199.59.150.13:443: connectex
```

**根本原因**：
- Docker Hub (docker.io) 访问受限
- 网络连接超时
- 可能被防火墙或网络策略阻止

---

## ✅ 解决方案 1：配置国内镜像源（推荐）

### 步骤 1.1：配置 Docker Desktop 镜像源

1. 打开 Docker Desktop
2. 点击右上角的齿轮图标（设置）
3. 选择 "Docker Engine"
4. 在 JSON 配置中添加以下内容：

```json
{
  "registry-mirrors": [
    "https://docker.m.daocloud.io",
    "https://docker.mirrors.ustc.edu.cn",
    "https://dockerhub.azk8s.cn",
    "https://dockerproxy.com",
    "https://docker.nju.edu.cn"
  ]
}
```

5. 点击 "Apply & Restart"
6. 等待 Docker 重启完成

### 步骤 1.2：验证配置

打开命令提示符，执行：

```cmd
docker pull hello-world
```

如果成功，说明镜像源配置有效！

---

## ✅ 解决方案 2：手动配置 daemon.json

如果 Docker Desktop 设置无法修改，可以手动编辑配置文件。

### 步骤 2.1：创建配置文件

1. 创建目录（如果不存在）：
   ```cmd
   mkdir %USERPROFILE%\.docker
   ```

2. 创建或编辑 `%USERPROFILE%\.docker\daemon.json` 文件

3. 粘贴以下内容：

```json
{
  "registry-mirrors": [
    "https://docker.m.daocloud.io",
    "https://docker.mirrors.ustc.edu.cn",
    "https://dockerhub.azk8s.cn",
    "https://dockerproxy.com",
    "https://docker.nju.edu.cn"
  ],
  "dns": ["8.8.8.8", "114.114.114.114"]
}
```

### 步骤 2.2：重启 Docker Desktop

1. 右键点击系统托盘的 Docker 图标
2. 选择 "Restart"

---

## ✅ 解决方案 3：使用代理

如果您有代理服务器，可以配置 Docker 使用代理。

### 步骤 3.1：Docker Desktop 配置代理

1. 打开 Docker Desktop
2. 进入 "Settings" → "Resources" → "Proxies"
3. 选择 "Manual proxy configuration"
4. 填写代理信息：
   ```
   HTTP proxy: http://proxy-server:port
   HTTPS proxy: http://proxy-server:port
   ```
5. 点击 "Apply & Restart"

### 步骤 3.2：命令行配置代理（临时）

在执行 docker 命令前设置环境变量：

```cmd
set HTTP_PROXY=http://proxy-server:port
set HTTPS_PROXY=http://proxy-server:port
docker-compose build
```

---

## ✅ 解决方案 4：修改 DNS

DNS 解析问题可能导致无法访问 Docker Hub。

### 步骤 4.1：更改系统 DNS

1. 打开"控制面板" → "网络和 Internet" → "网络和共享中心"
2. 点击当前网络连接
3. 点击"属性" → "Internet 协议版本 4 (TCP/IPv4)"
4. 选择"使用下面的 DNS 服务器地址"：
   ```
   首选 DNS 服务器: 8.8.8.8
   备用 DNS 服务器: 114.114.114.114
   ```
5. 点击"确定"

### 步骤 4.2：刷新 DNS

```cmd
ipconfig /flushdns
```

---

## ✅ 解决方案 5：使用本地构建（无网络依赖）

如果以上方案都无法解决，我们可以修改配置，使用本地构建，不依赖外部镜像。

### 步骤 5.1：修改 docker-compose.yml

我已经为您创建了一个本地构建版本的配置文件（见下文）。

### 步骤 5.2：使用本地基础镜像

创建新的 Dockerfile，使用最小化的本地构建方式。

---

## 🚀 快速修复脚本

创建一个批处理文件 `setup-docker-mirror.bat`：

```batch
@echo off
chcp 65001 >nul 2>&1
title Configure Docker Mirror
color 0A

echo.
echo ==========================================
echo  Configure Docker Mirror - Quick Fix
echo ==========================================
echo.

echo This script will configure Docker to use
echo domestic mirror sources to solve network issues.
echo.

REM Create .docker directory if not exists
if not exist "%USERPROFILE%\.docker" mkdir "%USERPROFILE%\.docker"

REM Create daemon.json
echo Creating daemon.json configuration...
(
echo {
echo   "registry-mirrors": [
echo     "https://docker.m.daocloud.io",
echo     "https://docker.mirrors.ustc.edu.cn",
echo     "https://dockerhub.azk8s.cn",
echo     "https://dockerproxy.com",
echo     "https://docker.nju.edu.cn"
echo   ],
echo   "dns": ["8.8.8.8", "114.114.114.114"]
echo }
) > "%USERPROFILE%\.docker\daemon.json"

echo [OK] Configuration file created
echo.
echo Configuration saved to:
echo %USERPROFILE%\.docker\daemon.json
echo.
echo Next steps:
echo 1. Restart Docker Desktop
echo 2. Run install.bat again
echo.

pause

REM Ask if user wants to restart Docker
set /p restart="Do you want to restart Docker Desktop now? (Y/N): "
if /i "%restart%"=="Y" (
    echo.
    echo Restarting Docker Desktop...
    taskkill /F /IM "Docker Desktop.exe" >nul 2>&1
    timeout /t 3 /nobreak >nul
    start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    echo [OK] Docker Desktop restarted
    echo Please wait 1-2 minutes for it to fully start
    echo.
)

pause
```

### 使用方法

1. 复制上面的代码，保存为 `setup-docker-mirror.bat`
2. 右键运行（不需要管理员权限）
3. 按照提示操作

---

## 🔍 诊断工具

创建诊断脚本 `test-docker-network.bat`：

```batch
@echo off
chcp 65001 >nul 2>&1
title Test Docker Network
color 0B

echo.
echo ==========================================
echo  Docker Network Diagnostic
echo ==========================================
echo.

echo [1/5] Testing DNS resolution...
nslookup docker.io
echo.

echo [2/5] Testing Docker Hub connectivity...
curl -I https://registry-1.docker.io
echo.

echo [3/5] Testing mirror connectivity...
curl -I https://docker.m.daocloud.io
echo.

echo [4/5] Testing Docker daemon...
docker info
echo.

echo [5/5] Testing image pull...
docker pull alpine:latest
echo.

echo ==========================================
echo  Diagnostic Complete
echo ==========================================
echo.

pause
```

---

## 📋 推荐解决流程

### 方案 A：最简单（推荐）

1. 运行 `setup-docker-mirror.bat`
2. 重启 Docker Desktop
3. 重新运行 `install.bat`

**预计时间**：5-10 分钟

---

### 方案 B：手动配置

1. 打开 Docker Desktop → Settings → Docker Engine
2. 添加 registry-mirrors 配置
3. Apply & Restart
4. 重新运行 `install.bat`

**预计时间**：10-15 分钟

---

### 方案 C：使用代理

1. 配置代理服务器
2. Docker Desktop → Settings → Resources → Proxies
3. 输入代理地址
4. Apply & Restart
5. 重新运行 `install.bat`

**预计时间**：15-20 分钟

---

## 🆘 如果所有方案都失败

### 选项 1：使用非 Docker 版本

如果 Docker 网络问题无法解决，强烈建议使用**非 Docker 版本**：

- 无需拉取 Docker 镜像
- 直接使用 Python 和 Node.js
- 安装更简单
- 功能完全相同

**查看文档**：`README_NO_DOCKER.md`

---

### 选项 2：手动下载镜像

在有网络的电脑上：
```cmd
docker pull python:3.12-slim
docker pull node:18-alpine
docker save -o python-image.tar python:3.12-slim
docker save -o node-image.tar node:18-alpine
```

复制到目标电脑：
```cmd
docker load -i python-image.tar
docker load -i node-image.tar
```

---

## 📞 获取帮助

### 收集诊断信息

运行诊断脚本后，收集以下信息：

1. `test-docker-network.bat` 的输出
2. Docker Desktop 日志（故障排查 → 诊断与反馈）
3. 网络连接测试结果

---

## ✅ 验证修复

配置完成后，测试是否能正常拉取镜像：

```cmd
docker pull hello-world
```

如果成功输出：
```
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

说明配置成功！可以重新运行 `install.bat` 了。

---

## 📊 国内镜像源列表

| 镜像源 | 地址 | 状态 |
|--------|------|------|
| 道客云 | https://docker.m.daocloud.io | ✅ 推荐 |
| 中科大 | https://docker.mirrors.ustc.edu.cn | ✅ 稳定 |
| Azure | https://dockerhub.azk8s.cn | ✅ 快速 |
| DockerProxy | https://dockerproxy.com | ✅ 可用 |
| 南京大学 | https://docker.nju.edu.cn | ✅ 可用 |

---

**最后更新**：2025-02-04
**推荐方案**：方案 A（使用配置脚本）
**备选方案**：非 Docker 版本
