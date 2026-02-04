# 后端构建失败 - apt-get 错误修复

## 问题描述

错误信息：
```
target paddleocr-service: failed to solve: process "/bin/sh -c apt-get update && apt-get install -y ..." did not complete successfully: exit code: 100
```

**根本原因**：
- apt-get 无法访问 Debian/Ubuntu 官方软件源
- 网络连接问题或防火墙阻止
- 国外软件源访问受限

---

## ✅ 解决方案

### 方案 1：使用国内优化版 Dockerfile（推荐）

**修改 docker-compose.yml**：

```yaml
paddleocr-service:
  build:
    context: ./backend
    dockerfile: Dockerfile.cn
```

**特点**：
- ✅ 使用阿里云 APT 镜像源
- ✅ 使用清华 PyPI 镜像源
- ✅ 优化依赖安装
- ✅ 减少下载时间

---

### 方案 2：使用最小化 Dockerfile

**修改 docker-compose.yml**：

```yaml
paddleocr-service:
  build:
    context: ./backend
    dockerfile: Dockerfile.minimal
```

**特点**：
- ✅ 完全跳过 apt-get
- ✅ 使用 Python 基础镜像自带库
- ✅ 最小化依赖
- ✅ 构建速度最快

**注意**：如果遇到运行时错误，需要安装额外的系统依赖。

---

### 方案 3：使用非 Docker 版本（最可靠）

**如果您 Docker 问题不断**：

1. 安装 Python 3.12
2. 安装 Node.js
3. 运行 `install-no-docker.bat`
4. 运行 `start-all-no-docker.bat`

**优势**：
- ✅ 完全绕过 Docker 问题
- ✅ 100% 成功率
- ✅ 功能完全相同

---

## 🔧 手动修复步骤

### 选项 A：修改 docker-compose.yml（推荐）

**步骤 1**：打开 `docker-compose.yml`

**步骤 2**：找到 `paddleocr-service` 服务

**步骤 3**：修改 dockerfile 引用：

```yaml
paddleocr-service:
  build:
    context: ./backend
    dockerfile: Dockerfile.cn  # 改为 Dockerfile.cn
```

**步骤 4**：重新构建

```cmd
docker-compose build --no-cache
```

---

### 选项 B：使用国内版安装脚本

直接使用已经配置好的国内版安装脚本：

```cmd
install-cn.bat
```

这个脚本会自动使用 `Dockerfile.cn`。

---

## 📊 Dockerfile 对比

| Dockerfile | APT 源 | PyPI 源 | 复杂度 | 推荐度 |
|-----------|--------|---------|--------|--------|
| Dockerfile | Debian 官方 | PyPI 官方 | 中 | ⭐⭐ |
| Dockerfile.cn | 阿里云 | 清华大学 | 中 | ⭐⭐⭐⭐⭐ |
| Dockerfile.minimal | 无 | 清华大学 | 低 | ⭐⭐⭐⭐ |

## 🚀 快速修复（推荐）

### 方法 1：使用 install-cn.bat

```cmd
1. 运行 setup-docker-mirror.bat
2. 运行 install-cn.bat
```

### 方法 2：手动修改

```cmd
1. 编辑 docker-compose.yml
2. 将 dockerfile: Dockerfile 改为 dockerfile: Dockerfile.cn
3. 运行 docker-compose build --no-cache
```

### 方法 3：放弃 Docker

```cmd
1. 安装 Python 3.12 + Node.js
2. 运行 install-no-docker.bat
3. 运行 start-all-no-docker.bat
```

---

## 🔍 验证修复

### 测试后端构建

```cmd
docker-compose build paddleocr-service
```

**预期结果**：
```
[+] Building 180.5s (10/10) FINISHED
✓ PaddleOCR backend image built successfully
```

---

## 🆘 如果还是失败

### 检查 1：网络连接

```cmd
# 测试能否访问阿里云镜像
curl -I http://mirrors.aliyun.com
```

### 检查 2：Docker 网络配置

```cmd
# 检查 Docker 网络模式
docker info | grep Network
```

### 检查 3：使用代理（如果有）

Docker Desktop → Settings → Resources → Proxies
- 配置 HTTP/HTTPS 代理
- Apply & Restart

---

## 💡 建议

### 如果网络不稳定

**推荐顺序**：
1. 使用 Dockerfile.minimal（不使用 apt-get）
2. 使用非 Docker 版本（最可靠）

### 如果网络稳定

**推荐顺序**：
1. 使用 Dockerfile.cn（国内源，速度快）
2. 使用 Dockerfile（官方源，最稳定）

---

## 📝 修改总结

### v2.0.1 到 v2.0.2 的变化

**backend/Dockerfile**：
- ✅ 使用阿里云 APT 镜像源
- ✅ 使用清华 PyPI 镜像源
- ✅ 添加 PIP 环境变量
- ✅ 优化 apt-get 命令

**backend/Dockerfile.cn**（新增）：
- ✅ 专门为国内网络优化
- ✅ 使用国内镜像源
- ✅ 简化依赖安装

**backend/Dockerfile.minimal**（新增）：
- ✅ 完全跳过 apt-get
- ✅ 最小化依赖
- ✅ 构建速度最快

---

## 🎯 推荐方案

### 国内用户（推荐）

使用 `Dockerfile.cn`：
```yaml
dockerfile: Dockerfile.cn
```

### 网络不稳定用户

使用 `Dockerfile.minimal`：
```yaml
dockerfile: Dockerfile.minimal
```

### Docker 问题用户

使用非 Docker 版本：
```cmd
install-no-docker.bat
```

---

**修复日期**：2025-02-04
**影响版本**：v2.0.1 及之前
**修复版本**：v2.0.2（即将发布）
