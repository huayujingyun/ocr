# 购物卡/加油卡OCR识别系统 - Windows完整部署指南

## 📦 下载说明

由于文件大小限制（OCR模型约200MB + Python环境约500MB），我们提供两种部署方式：

### 方式1：在线安装（推荐，文件小）
- 下载基础包（约50MB）
- 运行安装脚本自动下载依赖

### 方式2：离线完整包（适合无网络环境）
- 下载完整包（约1.5GB）
- 解压即可运行，无需下载

---

## 🚀 快速开始（3步完成）

### 方案A：标准部署（需要安装Python）

#### 前置要求
- Windows 10/11 64位
- 内存：4GB+
- 磁盘空间：2GB+
- **Python 3.12**（或让安装脚本自动下载）
- **Node.js 20+**（或让安装脚本自动下载）

#### 安装步骤

1. **下载部署包**
   ```
   下载：ocr-card-recognizer-windows.zip
   解压到任意目录（建议：C:\ocr-card-recognizer\）
   ```

2. **运行安装脚本**
   ```
   右键点击 install.bat
   选择"以管理员身份运行"
   等待安装完成（约5-10分钟）
   ```

3. **启动服务**
   ```
   双击 start.bat
   等待服务启动（约10-30秒）
   浏览器访问：http://localhost:5000
   ```

#### 管理命令
- **启动服务**：双击 `start.bat`
- **停止服务**：双击 `stop.bat`
- **检查状态**：双击 `check.bat`

---

### 方案B：便携式部署（无需安装Python）

#### 前置要求
- Windows 10/11 64位
- 内存：4GB+
- 磁盘空间：3GB+
- **Node.js 20+**（必须）

#### 安装步骤

1. **下载Python嵌入式版本**
   ```
   访问：https://www.python.org/downloads/windows/
   下载：Windows embeddable package (64-bit)
   文件名：python-3.12.x-embed-amd64.zip
   ```

2. **解压Python**
   ```
   将 python-3.12.x-embed-amd64.zip 解压到：
   backend\python\python.exe
   ```

3. **配置Python环境**
   在 `backend\python\` 目录下创建 `python312._pth` 文件：
   ```
   python312.zip
   .
   lib/site-packages
   ```

4. **安装依赖**
   ```batch
   cd backend\python
   python.exe -m ensurepip
   python.exe -m pip install -r ..\requirements.txt
   cd ..\..
   ```

5. **安装前端依赖**
   ```batch
   cd frontend
   pnpm install
   cd ..
   ```

6. **启动服务**
   ```
   双击 start.bat
   浏览器访问：http://localhost:5000
   ```

---

### 方案C：Docker部署（最简单）

#### 前置要求
- Windows 10/11 64位
- 内存：8GB+
- 磁盘空间：5GB+
- **Docker Desktop for Windows**

#### 安装步骤

1. **安装Docker Desktop**
   ```
   访问：https://www.docker.com/products/docker-desktop
   下载并安装Docker Desktop
   启动Docker Desktop
   ```

2. **下载部署包**
   ```
   下载：ocr-card-recognizer-windows.zip
   解压到任意目录
   ```

3. **启动服务**
   ```
   双击 docker-manager.bat
   选择"1. 启动服务"
   等待Docker构建镜像（首次约5-10分钟）
   浏览器访问：http://localhost:5000
   ```

#### Docker管理命令
- **启动服务**：`docker-compose up -d`
- **停止服务**：`docker-compose down`
- **查看日志**：`docker-compose logs -f`
- **查看状态**：`docker-compose ps`

---

## 📁 部署包结构

```
ocr-card-recognizer/
├── README.md                          # 本文档
├── install.bat                        # 标准安装脚本
├── start.bat                          # 启动服务
├── stop.bat                           # 停止服务
├── check.bat                          # 检查状态
├── docker-manager.bat                 # Docker管理
├── PORTABLE_PYTHON.md                 # 便携式Python指南
│
├── frontend/                          # 前端应用
│   ├── package.json
│   ├── pnpm-lock.yaml
│   ├── next.config.js
│   ├── src/
│   │   ├── app/
│   │   │   ├── page.tsx              # 主页面
│   │   │   ├── api/
│   │   │   │   └── ocr/route.ts      # OCR API
│   │   │   └── ...
│   │   └── ...
│   └── node_modules/                  # 依赖（安装后生成）
│
├── backend/                           # 后端应用
│   ├── main.py                        # FastAPI主应用
│   ├── ocr_service.py                 # PaddleOCR服务
│   ├── requirements.txt               # Python依赖
│   └── python/                        # 便携式Python（可选）
│       └── python.exe
│
├── docker/                            # Docker文件
│   ├── docker-compose.yml             # Docker Compose配置
│   ├── Dockerfile.frontend            # 前端镜像
│   └── Dockerfile.backend             # 后端镜像
│
├── logs/                              # 日志目录
│   ├── backend.log
│   └── frontend.log
│
└── data/                              # 数据目录
    ├── uploads/                       # 上传的图片
    └── exports/                       # 导出的文件
```

---

## 🔧 常见问题

### Q1: 安装脚本提示"Python未安装"

**A**: 安装脚本会自动提示下载Python
- 访问：https://www.python.org/downloads/release/python-3128/
- 下载：Windows installer (64-bit)
- 安装时**务必勾选** "Add Python to PATH"
- 安装完成后重新运行 `install.bat`

### Q2: 后端启动失败，提示"ImportError: libGL.so.1"

**A**: Windows上通常不会出现此问题，如果出现：
- 确保安装了Visual C++ Redistributable
- 下载地址：https://aka.ms/vs/17/release/vc_redist.x64.exe

### Q3: 首次启动很慢

**A**: 这是正常的，首次启动需要下载PaddleOCR模型文件
- 模型大小：约200MB
- 下载时间：约1-5分钟（取决于网络速度）
- 后续启动：约10-30秒

### Q4: Docker构建失败

**A**: 检查Docker状态
```batch
# 查看Docker版本
docker --version

# 测试Docker是否运行
docker run hello-world

# 如果失败，重启Docker Desktop
```

### Q5: 端口被占用

**A**: 修改端口配置
- 前端端口：修改 `frontend/next.config.js`
- 后端端口：修改 `backend/main.py`

或使用 `stop.bat` 停止现有服务

### Q6: 识别结果不准确

**A**: 优化识别效果
1. 使用模板框选模式（推荐）
2. 提高图片清晰度
3. 确保图片光线充足
4. 尝试不同的预处理方式

---

## 🔒 安全建议

1. **不要在公共网络运行**
   - 建议在本地或内网环境使用

2. **定期更新**
   - 定期检查更新版本
   - 更新Python依赖：`pip install --upgrade -r backend/requirements.txt`

3. **备份数据**
   - 定期备份 `data/uploads/` 目录
   - 备份导出的文件

---

## 📊 性能优化

### 提升识别速度
1. 使用模板框选模式（比整图识别快5倍）
2. 减小图片尺寸（建议宽度800-1200px）
3. 启用GPU加速（需要NVIDIA显卡）

### 启用GPU加速
修改 `backend/ocr_service.py`：
```python
self._ocr_engine = PaddleOCR(
    use_gpu=True,  # 改为True
    # ...
)
```

---

## 📞 技术支持

### 日志位置
- 后端日志：`logs/backend.log`
- 前端日志：`logs/frontend.log`

### 常用命令
```batch
# 查看后端日志
type logs\backend.log

# 查看前端日志
type logs\frontend.log

# 检查服务状态
curl http://localhost:8001/health
curl http://localhost:5000

# 重启服务
stop.bat
start.bat
```

### 获取帮助
- 查看详细文档：`PADDLEOCR_DEPLOY.md`
- PaddleOCR官方文档：https://github.com/PaddlePaddle/PaddleOCR
- FastAPI文档：http://localhost:8001/docs

---

## 📝 更新日志

### v2.0.0 (2024)
- ✅ 使用本地PaddleOCR替代云端服务
- ✅ 实现完全离线运行
- ✅ 支持Windows本地部署
- ✅ 提供便携式Python方案
- ✅ 支持Docker部署

### v1.0.0
- 初始版本，使用云端OCR服务

---

## 🎯 总结

### 推荐部署方案

| 用户类型 | 推荐方案 | 难度 | 稳定性 |
|---------|---------|------|--------|
| 技术用户 | Docker部署 | ⭐⭐ | ⭐⭐⭐⭐⭐ |
| 普通用户 | 标准部署 | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| 无Python环境 | 便携式部署 | ⭐⭐⭐⭐ | ⭐⭐⭐ |

### 最简部署流程（3步）

```
1. 下载部署包
   ↓
2. 双击 install.bat（或 docker-manager.bat）
   ↓
3. 双击 start.bat
   ↓
完成！访问 http://localhost:5000
```

---

**祝您使用愉快！** 🎉
