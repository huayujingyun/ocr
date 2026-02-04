# 📦 部署包下载说明

## 部署包位置

部署包已创建在以下目录：

```
/workspace/projects/card-ocr-deployment-package/
```

## 如何下载部署包

### 方法1：通过文件管理器下载（推荐）

1. 找到左侧文件浏览器
2. 导航到：`/workspace/projects/card-ocr-deployment-package/`
3. 右键点击 `card-ocr-deployment-package` 文件夹
4. 选择"下载"
5. 等待下载完成

### 方法2：打包后下载

如果您希望打包成单个文件：

1. 在沙箱终端执行：
```bash
cd /workspace/projects
tar -czf card-ocr-deployment-v1.0.0.tar.gz card-ocr-deployment-package/
```

2. 下载 `card-ocr-deployment-v1.0.0.tar.gz`

3. 在Windows上解压：
   - 使用7-Zip或WinRAR
   - 或使用Windows内置的tar命令

## 部署包内容

```
card-ocr-deployment-package/
├── README_FIRST.txt              # 首次安装必读
├── README.md                     # 项目说明
├── QUICKSTART.md                 # 快速开始指南
├── install.bat                   # 一键安装脚本
├── start.bat                     # 启动服务脚本
├── stop.bat                      # 停止服务脚本
├── status.bat                    # 查看状态脚本
├── check-deps.bat                # 依赖检查脚本
├── docker-compose.yml            # Docker编排配置
├── backend/                      # 后端服务
│   ├── main.py
│   ├── ocr_service.py
│   ├── requirements.txt
│   └── Dockerfile
├── frontend/                     # 前端服务
│   ├── Dockerfile
│   ├── package.json
│   ├── src/
│   └── public/
└── docs/                         # 文档
    ├── DEPLOYMENT_GUIDE.md
    ├── USER_MANUAL.md
    └── TROUBLESHOOTING.md
```

## 在Windows上使用

### 步骤1：下载部署包

使用上述方法之一下载部署包。

### 步骤2：解压文件

将文件解压到任意目录，例如：
```
C:\card-ocr-deployment-package\
```

### 步骤3：运行安装

```cmd
# 1. 双击打开 README_FIRST.txt 阅读说明

# 2. 检查依赖
check-deps.bat

# 3. 安装（右键，管理员）
右键点击 install.bat → 选择"以管理员身份运行"

# 4. 启动服务
start.bat

# 5. 访问应用
浏览器打开：http://localhost:5000
```

## 系统要求

- Windows 10/11
- Docker Desktop 4.15+
- 4GB+ 内存
- 10GB+ 磁盘空间

## 注意事项

- 首次安装需要10-20分钟（下载依赖）
- 必须以管理员身份运行 install.bat
- 确保Docker Desktop已启动
- 首次启动会下载PaddleOCR模型（约200MB）

## 文件大小

- 源代码：~324 KB
- Docker镜像（运行时下载）：~2.5 GB

## 需要帮助？

查看文档：
- QUICKSTART.md - 快速开始
- docs/DEPLOYMENT_GUIDE.md - 详细部署指南
- docs/TROUBLESHOOTING.md - 故障排除

---

**祝您部署成功！** 🚀
