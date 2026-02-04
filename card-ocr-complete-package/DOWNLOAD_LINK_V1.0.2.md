# 购物卡OCR识别系统 - Windows一键部署包 v1.0.2

## 📥 下载链接

**版本**：1.0.2
**大小**：144.00 KB
**有效期**：30天

### 直接下载

```
https://coze-coding-project.tos.coze.site/coze_storage_7602859016070627343/card-ocr-deployment-v1.0.2.tar_0f472397.gz?sign=1772777318-80e6642fbd-0-aba20f17a4d4fd9290951670949b7713e4aaf2b169a6f483162587614227fd31
```

## 🔧 v1.0.2 修复内容

### 问题修复

**v1.0.2 (最新版本)**：
- ✅ **修复脚本目录路径问题**
  - 添加 `cd /d "%~dp0"` 确保脚本在正确目录执行
  - 防止从其他目录运行脚本导致找不到配置文件
  
- ✅ **添加配置文件检查**
  - 所有脚本现在会检查 `docker-compose.yml` 是否存在
  - 如果找不到，显示明确的错误信息和当前目录
  
- ✅ **改进错误提示**
  - 显示当前工作目录
  - 提供明确的解决建议

**v1.0.1**：
- ✅ 修复批处理文件编码问题
- ✅ 移除中文字符，改用英文显示
- ✅ 修复语法错误

### 修复的具体脚本

1. **install.bat** - 一键安装脚本
   - 添加目录切换
   - 添加 docker-compose.yml 存在性检查
   - 显示当前目录信息

2. **start.bat** - 启动服务
   - 添加目录切换
   - 添加配置文件检查

3. **stop.bat** - 停止服务
   - 添加目录切换
   - 添加配置文件检查

4. **status.bat** - 查看状态
   - 添加目录切换
   - 添加配置文件检查

## 🚀 快速开始

### 1. 下载文件
点击上面的下载链接，将文件保存到本地。

### 2. 解压文件
使用 **7-Zip** 或 **WinRAR** 解压下载的 `.tar.gz` 文件。

### 3. 检查文件结构
解压后应该看到以下文件：
```
card-ocr-deployment-package/
├── docker-compose.yml          ✅ 配置文件
├── install.bat                  ✅ 安装脚本
├── start.bat                    ✅ 启动脚本
├── stop.bat                     ✅ 停止脚本
├── status.bat                   ✅ 状态脚本
├── check-deps.bat               ✅ 依赖检查
├── package.bat                  ✅ 打包脚本
├── backend/                     ✅ 后端服务
│   ├── Dockerfile
│   ├── main.py
│   ├── ocr_service.py
│   └── requirements.txt
├── frontend/                    ✅ 前端服务
│   └── Dockerfile
├── src/                         ✅ 前端源码
├── docs/                        ✅ 文档
└── *.md                         ✅ 说明文档
```

### 4. 安装依赖
- 右键点击 `install.bat`，选择"以管理员身份运行"
- 脚本会自动检查并安装Docker和Docker Compose
- 构建前端和后端的Docker镜像
- 配置环境变量和启动脚本

**预期输出**：
```
[1/6] Checking system environment...
[OK] Docker Desktop is installed
[OK] Git is installed

[2/6] Creating directories...
[OK] Directories created

[3/6] Configuring environment variables...
[OK] Environment file created

[4/6] Building Docker images...
[OK] Docker images built successfully

[5/6] Starting services...
[OK] Services started successfully

[6/6] Waiting for services to be ready...
[OK] Backend service (PaddleOCR) is running
[OK] Frontend service is running

Installation Complete!
```

### 5. 启动服务
- 双击运行 `start.bat`
- 等待服务启动完成
- 浏览器会自动打开 http://localhost:5000

### 6. 访问系统
- 打开浏览器访问：http://localhost:5000
- 开始使用购物卡OCR识别功能

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

#### Q1: 提示 "no configuration file provided: not found"
**A**: v1.0.2 已修复此问题。确保：
1. 下载最新的 v1.0.2 版本
2. 从解压后的根目录运行脚本
3. 不要从子目录运行脚本

#### Q2: Docker安装失败
**A**: 
1. 访问 https://www.docker.com/products/docker-desktop
2. 下载并安装 Docker Desktop
3. 安装完成后重启电脑
4. 确保 Docker Desktop 正在运行

#### Q3: 服务启动失败
**A**:
1. 运行 `status.bat` 查看服务状态
2. 检查端口 5000 和 8001 是否被占用
3. 查看日志文件：`docker-compose logs -f`

#### Q4: OCR识别错误
**A**:
1. 检查图片质量和格式（支持 JPG、PNG）
2. 尝试不同的识别模式
3. 确保图片清晰，文字可读

### 详细文档
解压后请查看以下文档：
- `QUICKSTART.md` - 快速开始
- `docs/USER_MANUAL.md` - 用户手册
- `docs/TROUBLESHOOTING.md` - 故障排除
- `docs/DEPLOYMENT_GUIDE.md` - 部署指南

## 📝 更新日志

### v1.0.2 (2025-02-04)
- ✅ 修复脚本目录路径问题
- ✅ 添加 docker-compose.yml 存在性检查
- ✅ 改进错误提示信息
- ✅ 确保脚本在正确目录执行

### v1.0.1 (2025-02-04)
- ✅ 修复批处理文件编码问题
- ✅ 修复语法错误
- ✅ 统一使用UTF-8编码
- ✅ 移除中文字符

### v1.0.0 (2025-02-04)
- ✅ 集成PaddleOCR-VL-1.5引擎
- ✅ 实现完全离线运行
- ✅ 支持多图片批量上传
- ✅ 提供Windows一键部署包
- ✅ 完整的文档和使用说明

## ⚠️ 注意事项

1. **管理员权限**：首次安装需要管理员权限
2. **防火墙设置**：确保5000和8001端口未被占用
3. **Docker配置**：Docker Desktop需要启用WSL 2
4. **首次启动**：首次启动需要下载Docker镜像，可能较慢
5. **图片格式**：支持JPG、PNG格式图片
6. **版本选择**：强烈建议使用最新的 v1.0.2 版本

## 🔄 版本对比

| 版本 | 编码问题 | 目录路径 | 配置检查 | 推荐度 |
|------|---------|---------|---------|--------|
| v1.0.0 | ❌ 有问题 | ❌ 有问题 | ❌ 无检查 | ⭐⭐ |
| v1.0.1 | ✅ 已修复 | ❌ 有问题 | ❌ 无检查 | ⭐⭐⭐ |
| **v1.0.2** | ✅ 已修复 | ✅ 已修复 | ✅ 已添加 | ⭐⭐⭐⭐⭐ |

---

**版本**：1.0.2
**发布日期**：2025-02-04
**技术支持**：见解压后的文档
**推荐版本**：✅ 请使用 v1.0.2（最新稳定版）
