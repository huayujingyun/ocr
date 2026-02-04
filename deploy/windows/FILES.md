# Windows本地部署包 - 文件清单

## 📦 已创建的部署文件

### 📁 目录结构
```
deploy/windows/
├── README.md                          # 完整部署指南
├── QUICKSTART.md                      # 快速开始指南（3分钟部署）
├── DOWNLOAD.md                        # 下载说明和校验信息
├── PORTABLE_PYTHON.md                 # 便携式Python部署指南
├── package.json                       # 版本信息
│
├── install.bat                        # 一键安装脚本
├── start.bat                          # 一键启动脚本
├── stop.bat                           # 一键停止脚本
├── check.bat                          # 服务状态检查
├── docker-manager.bat                 # Docker管理脚本
│
├── docker-compose.yml                 # Docker Compose配置
├── Dockerfile.frontend                # 前端Docker镜像
├── Dockerfile.backend                 # 后端Docker镜像
│
└── [待添加的目录]
    ├── frontend/                      # 前端源码
    └── backend/                       # 后端源码
```

---

## 📄 文件说明

### 📘 文档文件

#### 1. README.md
**用途**：完整的Windows部署指南
**内容**：
- 三种部署方案详解
- 安装步骤说明
- 常见问题解答
- 性能优化建议
- 技术支持信息

**适合人群**：所有用户

#### 2. QUICKSTART.md
**用途**：快速开始指南
**内容**：
- 3分钟快速部署
- 简化的使用流程
- 常见问题速查
- 管理命令速查

**适合人群**：急需上手的用户

#### 3. DOWNLOAD.md
**用途**：下载说明和校验
**内容**：
- 三种下载选项
- 文件大小和特点
- MD5/SHA256校验方法
- 更新日志

**适合人群**：所有用户

#### 4. PORTABLE_PYTHON.md
**用途**：便携式Python部署指南
**内容**：
- 嵌入式Python下载
- 环境配置步骤
- 依赖安装方法
- 注意事项

**适合人群**：不想安装Python的用户

#### 5. package.json
**用途**：版本信息和元数据
**内容**：
- 版本号和发布日期
- 系统要求
- 功能特性
- 服务配置

**适合人群**：开发者

---

### 🛠️ 脚本文件

#### 1. install.bat
**用途**：一键安装脚本
**功能**：
- 检查系统要求
- 检查Python和Node.js
- 自动安装Python（如需要）
- 自动安装Node.js（如需要）
- 安装所有依赖
- 创建必要目录

**使用方法**：
```batch
右键点击 → 以管理员身份运行
```

**执行时间**：约5-10分钟

#### 2. start.bat
**用途**：一键启动脚本
**功能**：
- 检查端口占用
- 启动后端服务（端口8001）
- 启动前端服务（端口5000）
- 检查服务状态
- 显示访问地址

**使用方法**：
```batch
双击运行
```

**执行时间**：约10-30秒（首次启动1-5分钟）

#### 3. stop.bat
**用途**：一键停止脚本
**功能**：
- 停止前端服务
- 停止后端服务
- 清理进程残留

**使用方法**：
```batch
双击运行
```

**执行时间**：约3秒

#### 4. check.bat
**用途**：服务状态检查
**功能**：
- 检查后端服务状态
- 检查前端服务状态
- 显示进程信息
- 显示访问地址

**使用方法**：
```batch
双击运行
```

#### 5. docker-manager.bat
**用途**：Docker管理脚本
**功能**：
- 启动Docker服务
- 停止Docker服务
- 重启Docker服务
- 查看Docker日志
- 查看服务状态

**使用方法**：
```batch
双击运行，选择选项
```

---

### 🐳 Docker文件

#### 1. docker-compose.yml
**用途**：Docker Compose配置
**功能**：
- 定义前端服务
- 定义后端服务
- 配置网络和卷
- 健康检查

**使用方法**：
```batch
docker-compose up -d
```

#### 2. Dockerfile.frontend
**用途**：前端Docker镜像构建文件
**功能**：
- 基于Node.js 20
- 构建Next.js应用
- 优化生产环境

#### 3. Dockerfile.backend
**用途**：后端Docker镜像构建文件
**功能**：
- 基于Python 3.12
- 安装PaddleOCR
- 预下载模型文件

---

## 📋 部署包打包清单

### 在线安装包（ocr-card-recognizer-windows.zip）

**大小**：约50MB

**包含内容**：
```
✅ README.md
✅ QUICKSTART.md
✅ DOWNLOAD.md
✅ PORTABLE_PYTHON.md
✅ package.json
✅ install.bat
✅ start.bat
✅ stop.bat
✅ check.bat
✅ docker-manager.bat
✅ docker-compose.yml
✅ Dockerfile.frontend
✅ Dockerfile.backend
✅ frontend/（源码）
✅ backend/（源码）
```

**不包含**：
❌ Node.js依赖（自动下载）
❌ Python依赖（自动下载）
❌ OCR模型（首次启动自动下载）

---

### 离线完整包（ocr-card-recognizer-windows-full.zip）

**大小**：约1.5GB

**包含内容**：
```
✅ 在线安装包的所有内容
✅ frontend/node_modules/（约500MB）
✅ backend/python/（约500MB）
✅ models/（约200MB）
```

**不包含**：
❌ 无，完全离线

---

## 🚀 使用流程

### 标准部署流程

```batch
1. 下载 ocr-card-recognizer-windows.zip
2. 解压到 C:\ocr-card-recognizer\
3. 右键点击 install.bat → 以管理员身份运行
4. 等待安装完成（5-10分钟）
5. 双击 start.bat
6. 等待服务启动（10-30秒）
7. 浏览器访问 http://localhost:5000
```

### Docker部署流程

```batch
1. 安装Docker Desktop
2. 下载 ocr-card-recognizer-windows.zip
3. 解压到任意目录
4. 双击 docker-manager.bat
5. 选择"启动服务"
6. 等待构建完成（首次5-10分钟）
7. 浏览器访问 http://localhost:5000
```

---

## 📊 文件大小参考

| 文件/目录 | 大小 | 说明 |
|----------|------|------|
| README.md | ~30KB | 文档 |
| QUICKSTART.md | ~15KB | 文档 |
| install.bat | ~5KB | 脚本 |
| start.bat | ~3KB | 脚本 |
| docker-compose.yml | ~2KB | 配置 |
| frontend/（源码） | ~1MB | 源码 |
| backend/（源码） | ~50KB | 源码 |
| node_modules/ | ~500MB | 依赖（完整包） |
| python/ | ~500MB | Python环境（完整包） |
| models/ | ~200MB | OCR模型（完整包） |

---

## ⚠️ 使用前准备

### 检查系统
```batch
# 检查Windows版本
ver

# 检查内存
systeminfo | findstr "Physical"

# 检查磁盘空间
dir
```

### 检查环境（标准部署）
```batch
# 检查Python
python --version

# 检查Node.js
node --version

# 检查pnpm
pnpm --version
```

### 检查Docker（Docker部署）
```batch
# 检查Docker版本
docker --version

# 检查Docker运行状态
docker ps
```

---

## 🎯 快速参考

### 管理命令速查

| 操作 | 命令 |
|------|------|
| 安装 | 双击 install.bat |
| 启动 | 双击 start.bat |
| 停止 | 双击 stop.bat |
| 检查状态 | 双击 check.bat |
| 查看后端日志 | type logs\backend.log |
| 查看前端日志 | type logs\frontend.log |

### 访问地址速查

| 服务 | 地址 | 说明 |
|------|------|------|
| 前端界面 | http://localhost:5000 | 用户界面 |
| 后端API | http://localhost:8001/docs | API文档 |
| 健康检查 | http://localhost:8001/health | 服务状态 |

---

## 📞 获取帮助

### 文档
- 完整指南：`README.md`
- 快速开始：`QUICKSTART.md`
- 下载说明：`DOWNLOAD.md`

### 日志
- 后端日志：`logs\backend.log`
- 前端日志：`logs\frontend.log`

### 常见问题
查看 `README.md` 的"常见问题"章节

---

## ✅ 检查清单

部署前检查：
- [ ] Windows 10/11 64位
- [ ] 4GB+ 内存
- [ ] 2GB+ 可用空间
- [ ] 管理员权限（标准部署）
- [ ] Docker Desktop（Docker部署）

部署后检查：
- [ ] 后端服务启动成功
- [ ] 前端服务启动成功
- [ ] 可以访问 http://localhost:5000
- [ ] OCR识别功能正常
- [ ] Excel导出功能正常

---

**现在您可以开始部署了！** 🚀
