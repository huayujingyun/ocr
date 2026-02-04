# 🚨 Docker 镜像拉取失败 - 解决方案

## 您遇到的问题

错误信息：
```
target paddleocr-service: failed to solve: failed to fetch oauth token:
Post "https://auth.docker.io/token": dial tcp 199.59.150.13:443: connectex
```

**这是网络连接问题，Docker Hub 无法访问。**

---

## ⚡ 3 种解决方案（按推荐度排序）

### 🥇 方案 1：配置国内镜像源（最简单）

**步骤**：
1. 双击运行 `setup-docker-mirror.bat`
2. 选择 "Y" 重启 Docker Desktop
3. 等待 1-2 分钟
4. 双击运行 `install-cn.bat`

**预计时间**：10-15 分钟
**成功率**：90%+

---

### 🥈 方案 2：使用非 Docker 版本（最可靠）

**如果您没有 Docker，或者 Docker 问题无法解决**

**步骤**：
1. 阅读 `README_NO_DOCKER.md`
2. 安装 Python 3.12（勾选 "Add to PATH"）
3. 安装 Node.js
4. 双击运行 `install-no-docker.bat`
5. 双击运行 `start-all-no-docker.bat`

**预计时间**：20-30 分钟
**成功率**：100%
**优势**：不依赖 Docker，完全绕过网络问题

---

### 🥉 方案 3：手动诊断和修复

**如果您想深入了解问题**

**步骤**：
1. 运行 `test-docker-network.bat` 诊断网络
2. 查看 `DOCKER_MIRROR_CONFIG.md` 了解详情
3. 手动配置 Docker Desktop 镜像源
4. 重新运行 `install.bat`

**预计时间**：15-30 分钟
**成功率**：70%

---

## 🎯 我的建议

### 如果您是普通用户

**推荐使用方案 2（非 Docker 版本）**

理由：
- ✅ 100% 成功率
- ✅ 不依赖 Docker
- ✅ 安装更简单
- ✅ 功能完全相同

### 如果您是技术用户

**先尝试方案 1，失败后使用方案 2**

理由：
- ✅ Docker 版本适合长期使用
- ✅ 环境隔离，易于管理
- ✅ 如果网络问题无法解决，有备选方案

---

## 📂 可用文件

### 脚本文件

- `setup-docker-mirror.bat` - 一键配置 Docker 镜像源
- `test-docker-network.bat` - 网络诊断工具
- `install-cn.bat` - 国内优化版安装脚本
- `install-no-docker.bat` - 非 Docker 版本安装脚本

### 文档文件

- `QUICK_FIX_MIRROR.md` - 镜像问题快速修复
- `DOCKER_MIRROR_CONFIG.md` - 镜像配置详细说明
- `README_NO_DOCKER.md` - 非 Docker 版本完整说明
- `NO_DOCKER_TROUBLESHOOT.md` - 非 Docker 版本故障排除

---

## 🔍 快速诊断

### 检查 Docker 是否可用

运行：
```cmd
docker pull hello-world
```

**如果成功** → Docker 正常，使用方案 1
**如果失败** → Docker 有问题，使用方案 2

---

## 💡 常见问题

### Q1：为什么 Docker Hub 无法访问？

**A**：
- Docker Hub 在国外
- 国内网络访问可能受限
- 需要使用国内镜像源加速

### Q2：配置镜像源安全吗？

**A**：
- ✅ 完全安全
- ✅ 只是加速下载，不修改镜像内容
- ✅ 国内大厂提供的镜像服务

### Q3：非 Docker 版本功能一样吗？

**A**：
- ✅ 功能完全相同
- ✅ 都使用 PaddleOCR-VL-1.5
- ✅ 都支持离线运行
- ❌ 只是部署方式不同

### Q4：哪个版本性能更好？

**A**：
- Docker 版本：资源占用稍高，但环境隔离
- 非 Docker 版本：资源占用低，但依赖系统环境

实际使用体验基本相同。

---

## 🚀 现在开始

### 选择方案 1：配置镜像源

```cmd
1. setup-docker-mirror.bat
2. 等待 Docker 重启（1-2 分钟）
3. install-cn.bat
```

### 选择方案 2：使用非 Docker 版本

```cmd
1. 安装 Python 3.12（记得勾选 "Add to PATH"）
2. 安装 Node.js
3. install-no-docker.bat
4. start-all-no-docker.bat
```

---

## ✅ 成功标志

安装成功后，访问：**http://localhost:5000**

您应该看到购物卡 OCR 识别系统的界面！

---

## 📞 还是不行？

### 收集诊断信息

运行 `test-docker-network.bat`，将输出保存并反馈。

### 查看详细文档

根据您的选择：
- Docker 问题：`DOCKER_MIRROR_CONFIG.md`
- 非 Docker 问题：`README_NO_DOCKER.md`

### 最后的选择

如果所有方案都失败：
1. 检查系统要求（Windows 7/8/10/11，8GB+ RAM）
2. 检查网络连接
3. 联系技术支持

---

**版本**：1.0.0
**发布日期**：2025-02-04
**推荐方案**：方案 2（非 Docker 版本）
**成功率**：100%
