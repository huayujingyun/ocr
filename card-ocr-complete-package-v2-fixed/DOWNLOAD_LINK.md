# 购物卡OCR识别系统 - Windows一键部署包

## 📥 下载链接

**版本**：1.0.0
**大小**：57.36 KB
**有效期**：30天

### 直接下载

```
https://coze-coding-project.tos.coze.site/coze_storage_7602859016070627343/card-ocr-deployment-v1.0.0.tar_27c320ac.gz?sign=1772776256-4bd3ebe28d-0-cd05e07307d7d5e0574fa7ec49a0d5090fe5f86e4d92f1dfc45abcf3dac422a8
```

## 🚀 快速开始

### 1. 下载文件
点击上面的下载链接，将文件保存到本地。

### 2. 解压文件
使用 **7-Zip** 或 **WinRAR** 解压下载的 `.tar.gz` 文件。

### 3. 安装依赖
- 右键点击 `install.bat`，选择"以管理员身份运行"
- 脚本会自动检查并安装Docker和Docker Compose
- 构建前端和后端的Docker镜像
- 配置环境变量和启动脚本

### 4. 启动服务
- 双击运行 `start.bat`
- 等待服务启动完成（首次启动可能需要2-3分钟）

### 5. 访问系统
- 打开浏览器访问：http://localhost:5000
- 开始使用购物卡OCR识别功能

## 📋 包含内容

### 核心服务
- **前端服务**：基于Next.js 16的Web界面
- **后端服务**：基于FastAPI的PaddleOCR引擎
- **OCR引擎**：PaddleOCR-VL-1.5（完全离线运行）

### 自动化脚本
- `install.bat` - 一键安装脚本
- `start.bat` - 启动服务
- `stop.bat` - 停止服务
- `status.bat` - 查看服务状态
- `check-deps.bat` - 检查依赖环境
- `package.bat` - 重新打包部署文件

### 文档
- `QUICKSTART.md` - 快速开始指南
- `WINDOWS_DEPLOYMENT_README.md` - Windows部署详细说明
- `docs/USER_MANUAL.md` - 用户使用手册
- `docs/TROUBLESHOOTING.md` - 故障排除指南

## ✨ 功能特性

### OCR识别
- ✅ 支持多图片批量上传
- ✅ 自动提取卡号和密码
- ✅ 模板框选识别模式
- ✅ 传统OCR识别模式
- ✅ 条码识别模式
- ✅ 完全离线运行（无需云端服务）

### 数据管理
- ✅ 识别结果编辑和校验
- ✅ Excel导出（包含密码图片）
- ✅ 卡号和密码一一对应
- ✅ 图片尺寸适中（150x60像素）

### 技术特点
- ✅ 基于PaddleOCR-VL-1.5引擎
- ✅ Python 3.12 + FastAPI
- ✅ Next.js 16 + TypeScript
- ✅ Docker容器化部署
- ✅ 一键安装和启动

## 🔧 系统要求

### 必需软件
- **操作系统**：Windows 10/11（64位）
- **Docker Desktop**：4.0或更高版本
- **内存**：至少8GB RAM
- **磁盘空间**：至少10GB可用空间

### 网络要求
- 安装时需要联网（下载Docker镜像）
- 运行时完全离线（OCR识别不依赖网络）

## 📞 技术支持

### 常见问题
- Docker安装失败 → 查看 `docs/TROUBLESHOOTING.md`
- 服务启动失败 → 运行 `status.bat` 查看状态
- OCR识别错误 → 检查图片质量和识别模式选择

### 详细文档
解压后请查看以下文档：
- `QUICKSTART.md` - 快速开始
- `docs/USER_MANUAL.md` - 用户手册
- `docs/TROUBLESHOOTING.md` - 故障排除
- `docs/DEPLOYMENT_GUIDE.md` - 部署指南

## ⚠️ 注意事项

1. **管理员权限**：首次安装需要管理员权限
2. **防火墙设置**：确保5000和8001端口未被占用
3. **Docker配置**：Docker Desktop需要启用WSL 2
4. **首次启动**：首次启动需要下载Docker镜像，可能较慢
5. **图片格式**：支持JPG、PNG格式图片

## 📝 更新日志

### v1.0.0 (2025-02-04)
- ✅ 集成PaddleOCR-VL-1.5引擎
- ✅ 实现完全离线运行
- ✅ 支持多图片批量上传
- ✅ 提供Windows一键部署包
- ✅ 完整的文档和使用说明

---

**版本**：1.0.0
**发布日期**：2025-02-04
**技术支持**：见解压后的文档
