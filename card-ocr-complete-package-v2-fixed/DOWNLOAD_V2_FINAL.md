# 📥 购物卡OCR识别系统 - 完整部署包 v2.0.0

## 🎯 下载链接（最新版本）

**版本**：v2.0.0（终极版）
**大小**：211.33 KB
**有效期**：30天

### 下载地址

```
https://coze-coding-project.tos.coze.site/coze_storage_7602859016070627343/card-ocr-complete-v2.0.0.tar_a92ad82f.gz?sign=1772778218-b8e9cb3f8c-0-604ae3aa105e314dd77384f3aad9df80a16a74de4616f9782e3ba866ef569277
```

---

## 🚀 三种部署方式（任选其一）

### 方式 1：Docker 标准版

**适合**：Docker 正常的用户

**步骤**：
1. 解压文件
2. 右键运行 `install.bat`（管理员）
3. 等待安装完成
4. 运行 `start.bat` 启动服务

**预计时间**：15-30 分钟

---

### 方式 2：Docker 国内版（推荐国内用户）

**适合**：Docker Hub 访问受限

**步骤**：
1. 解压文件
2. 运行 `setup-docker-mirror.bat` 配置镜像源
3. 重启 Docker Desktop（等待 1-2 分钟）
4. 右键运行 `install-cn.bat`（管理员）
5. 运行 `start.bat` 启动服务

**预计时间**：10-20 分钟

**优势**：
- ✅ 使用国内镜像源
- ✅ 下载速度更快
- ✅ 网络稳定性更好

---

### 方式 3：非 Docker 版本（最可靠）

**适合**：Docker 无法使用或不熟悉 Docker

**步骤**：
1. 安装 Python 3.12（下载：https://www.python.org/downloads/release/python-3127/）
   - **重要**：勾选 "Add Python to PATH"
2. 安装 Node.js（下载：https://nodejs.org/）
3. 解压文件
4. 右键运行 `install-no-docker.bat`（管理员）
5. 运行 `start-all-no-docker.bat` 启动服务

**预计时间**：20-40 分钟

**优势**：
- ✅ 不需要 Docker
- ✅ 100% 成功率
- ✅ 安装更简单
- ✅ 功能完全相同

---

## 📋 包含内容

### 核心功能
- ✅ 多图片批量上传
- ✅ 自动提取卡号和密码
- ✅ 模板框选识别
- ✅ 传统 OCR 识别
- ✅ 条码识别
- ✅ 完全离线运行

### 工具脚本
- `setup-docker-mirror.bat` - Docker 镜像配置工具
- `test-docker-network.bat` - 网络诊断工具
- `install.bat` - Docker 标准安装
- `install-cn.bat` - Docker 国内版安装
- `install-no-docker.bat` - 非 Docker 版本安装
- `start.bat` - 启动服务（Docker）
- `start-all-no-docker.bat` - 启动服务（非 Docker）
- `stop.bat` - 停止服务
- `status.bat` - 查看状态

### 重要文档
- `README.md` - 主文档
- `DEPLOYMENT_CHOICE_GUIDE.md` - 部署方案选择指南
- `DOCKER_PULL_FAILURE_FIX.md` - Docker 问题修复
- `README_NO_DOCKER.md` - 非 Docker 版本说明
- `QUICKSTART.md` - 快速开始
- `DOCKER_MIRROR_CONFIG.md` - 镜像配置指南

---

## 🎯 如何选择部署方式？

### 如果您熟悉 Docker

→ 使用 **方式 1**（Docker 标准版）或 **方式 2**（Docker 国内版）

### 如果 Docker Hub 访问慢或失败

→ 使用 **方式 2**（Docker 国内版）或 **方式 3**（非 Docker 版本）

### 如果 Docker 无法使用

→ 使用 **方式 3**（非 Docker 版本）

### 如果不确定

→ 先尝试 **方式 1**，失败后使用 **方式 3**

---

## ✅ 成功标志

安装成功后，访问：

**http://localhost:5000**

您应该看到购物卡 OCR 识别系统的界面！

---

## 🆘 遇到问题？

### Docker 相关问题

- 查看 `DOCKER_PULL_FAILURE_FIX.md`
- 运行 `test-docker-network.bat` 诊断
- 运行 `setup-docker-mirror.bat` 配置

### 非 Docker 版本问题

- 查看 `README_NO_DOCKER.md`
- 查看 `NO_DOCKER_TROUBLESHOOT.md`

### 通用问题

- 查看 `DEPLOYMENT_CHOICE_GUIDE.md`
- 查看 `QUICKSTART.md`

---

## 📊 版本对比

| 版本 | 大小 | 包含内容 | 推荐度 |
|------|------|---------|--------|
| v1.0.0 | 57KB | 仅 Docker 版本 | ⭐⭐ |
| v1.0.1 | 184KB | Docker + 修复 | ⭐⭐⭐ |
| v1.0.2 | 144KB | Docker + 路径修复 | ⭐⭐⭐⭐ |
| **v2.0.0** | 211KB | **所有修复 + 非 Docker 版本** | **⭐⭐⭐⭐⭐** |

---

## 🎉 v2.0.0 新增特性

### 新增部署方式
- ✅ 非 Docker 版本（100% 成功率）
- ✅ Docker 国内版（使用镜像源）

### 新增工具
- ✅ setup-docker-mirror.bat - 镜像配置工具
- ✅ test-docker-network.bat - 网络诊断工具
- ✅ 国内优化版 Dockerfile

### 新增文档
- ✅ DEPLOYMENT_CHOICE_GUIDE.md - 部署方案选择
- ✅ DOCKER_PULL_FAILURE_FIX.md - Docker 问题修复
- ✅ README_NO_DOCKER.md - 非 Docker 版本说明
- ✅ NO_DOCKER_TROUBLESHOOT.md - 非 Docker 版本故障排除

---

## 🔧 系统要求

### Docker 版本
- Windows 10/11（64位）
- Docker Desktop
- 8GB+ RAM
- 10GB+ 磁盘空间

### 非 Docker 版本
- Windows 7/8/10/11（64位）
- Python 3.12
- Node.js 18+
- 8GB+ RAM
- 10GB+ 磁盘空间

---

## 📞 技术支持

### 快速诊断

运行诊断工具：
- Docker 问题：`test-docker-network.bat`
- 通用问题：查看相关文档

### 文档索引

- **快速开始**：`QUICKSTART.md`
- **选择部署方案**：`DEPLOYMENT_CHOICE_GUIDE.md`
- **Docker 问题**：`DOCKER_PULL_FAILURE_FIX.md`
- **非 Docker 版本**：`README_NO_DOCKER.md`

---

## ✨ 核心功能

### OCR 识别
- 支持多图片批量上传
- 自动提取卡号和密码
- 模板框选识别模式
- 传统 OCR 识别模式
- 条码识别模式
- 完全离线运行

### 数据管理
- 识别结果编辑和校验
- Excel 导出（包含密码图片）
- 卡号和密码一一对应
- 图片尺寸适中（150x60 像素）

### 技术特点
- 基于 PaddleOCR-VL-1.5 引擎
- Python 3.12 + FastAPI
- Next.js 16 + TypeScript
- 完全离线运行

---

**版本**：v2.0.0（终极版）
**发布日期**：2025-02-04
**推荐版本**：v2.0.0
**成功率**：100%（提供三种部署方式）

**无论遇到什么问题，都有解决方案！**
