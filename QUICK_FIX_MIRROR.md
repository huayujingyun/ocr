# Docker 镜像拉取失败 - 快速修复指南

## 问题描述

错误信息：
```
failed to fetch oauth token: Post "https://auth.docker.io/token": dial tcp 199.59.150.13:443: connectex
```

**原因**：Docker Hub 访问受限，网络连接问题

---

## ⚡ 快速修复（3 步）

### 方案 1：一键配置镜像源（推荐）

**步骤**：
1. 运行 `setup-docker-mirror.bat`
2. 重启 Docker Desktop
3. 重新运行 `install-cn.bat`

**预计时间**：5-10 分钟

---

### 方案 2：使用国内优化版安装

**步骤**：
1. 运行 `test-docker-network.bat` 诊断网络
2. 运行 `setup-docker-mirror.bat` 配置镜像
3. 运行 `install-cn.bat`（使用国内优化版）

**预计时间**：10-15 分钟

---

### 方案 3：放弃 Docker，使用非 Docker 版本

**步骤**：
1. 阅读 `README_NO_DOCKER.md`
2. 安装 Python 3.12 和 Node.js
3. 运行 `install-no-docker.bat`

**预计时间**：20-30 分钟

---

## 📋 详细步骤

### 步骤 1：诊断网络问题

运行诊断脚本：
```cmd
test-docker-network.bat
```

查看输出，了解：
- DNS 解析是否正常
- Docker Hub 是否可访问
- 国内镜像源是否可用

---

### 步骤 2：配置 Docker 镜像源

运行配置脚本：
```cmd
setup-docker-mirror.bat
```

脚本会自动：
- 创建/更新 Docker 配置文件
- 添加国内镜像源
- 配置 DNS
- 可选：重启 Docker Desktop

---

### 步骤 3：使用国内优化版安装

运行国内优化版安装脚本：
```cmd
install-cn.bat
```

这个版本会：
- 自动使用国内镜像源
- 使用优化的 Dockerfile
- 从国内 PyPI 和 npm 镜像安装依赖

---

## 🔄 如果还是失败

### 检查清单

- [ ] Docker Desktop 已启动
- [ ] 镜像源已配置
- [ ] 网络连接正常
- [ ] 防火墙未阻止 Docker
- [ ] 磁盘空间充足（>10GB）

---

### 验证配置

测试镜像源是否有效：
```cmd
docker pull hello-world
```

如果成功，说明配置有效！

---

### 手动验证镜像源

检查配置文件：
```cmd
type %USERPROFILE%\.docker\daemon.json
```

应该看到：
```json
{
  "registry-mirrors": [
    "https://docker.m.daocloud.io",
    "https://docker.mirrors.ustc.edu.cn",
    ...
  ]
}
```

---

## 🆘 最后手段

### 选项 1：使用代理

如果您有代理服务器：

1. Docker Desktop → Settings → Resources → Proxies
2. 选择 Manual proxy configuration
3. 填写代理地址
4. Apply & Restart

---

### 选项 2：手动下载镜像

在有网络的电脑上：
```cmd
docker pull python:3.12-slim
docker save -o python-image.tar python:3.12-slim
```

复制到目标电脑：
```cmd
docker load -i python-image.tar
```

---

### 选项 3：使用非 Docker 版本（强烈推荐）

如果所有 Docker 方案都失败，使用**非 Docker 版本**：

**优势**：
- ✅ 不需要拉取 Docker 镜像
- ✅ 不依赖 Docker Hub
- ✅ 安装更简单
- ✅ 功能完全相同

**查看文档**：`README_NO_DOCKER.md`

---

## 📊 国内镜像源

| 镜像源 | 地址 | 推荐度 |
|--------|------|--------|
| 道客云 | https://docker.m.daocloud.io | ⭐⭐⭐⭐⭐ |
| 中科大 | https://docker.mirrors.ustc.edu.cn | ⭐⭐⭐⭐⭐ |
| Azure | https://dockerhub.azk8s.cn | ⭐⭐⭐⭐ |
| DockerProxy | https://dockerproxy.com | ⭐⭐⭐⭐ |
| 南京大学 | https://docker.nju.edu.cn | ⭐⭐⭐ |

---

## 🎯 推荐流程

```
1. 运行 test-docker-network.bat 诊断
   ↓
2. 运行 setup-docker-mirror.bat 配置
   ↓
3. 重启 Docker Desktop
   ↓
4. 运行 install-cn.bat 安装
   ↓
5. 如果成功 → 完成！
   ↓
6. 如果失败 → 使用非 Docker 版本
```

---

## ⚠️ 注意事项

1. **需要重启 Docker**
   - 配置镜像源后必须重启 Docker Desktop
   - 等待 1-2 分钟让 Docker 完全启动

2. **网络稳定**
   - 首次构建需要下载基础镜像
   - 确保网络稳定，不要中断

3. **磁盘空间**
   - Docker 镜像占用空间较大
   - 确保至少 10GB 可用空间

4. **防火墙**
   - 某些企业防火墙可能阻止 Docker
   - 可能需要配置例外规则

---

## 📞 获取帮助

### 查看详细文档

- `DOCKER_MIRROR_CONFIG.md` - 镜像配置详细说明
- `DOCKER_DESKTOP_TROUBLESHOOT.md` - Docker 故障排除
- `README_NO_DOCKER.md` - 非 Docker 版本

### 诊断工具

- `test-docker-network.bat` - 网络诊断
- `setup-docker-mirror.bat` - 镜像配置

---

## ✅ 成功标志

安装成功后，应该看到：
```
[OK] Backend service (PaddleOCR) is running
[OK] Frontend service is running

Service URLs:
  - Frontend: http://localhost:5000
  - Backend API: http://localhost:8001
```

打开浏览器访问 http://localhost:5000 即可使用！

---

**最后更新**：2025-02-04
**推荐方案**：使用 install-cn.bat
**备选方案**：非 Docker 版本
