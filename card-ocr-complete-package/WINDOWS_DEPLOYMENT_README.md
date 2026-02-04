# 购物卡/加油卡OCR识别系统 - Windows一键部署包

## 📦 部署包结构

```
card-ocr-deployment/
├── README.md                          # 本文件
├── install.bat                        # Windows一键安装脚本
├── start.bat                          # 启动服务脚本
├── stop.bat                           # 停止服务脚本
├── status.bat                         # 查看服务状态脚本
├── check-deps.bat                     # 依赖检查脚本
├── docker-compose.yml                 # Docker Compose配置
├── backend/                           # 后端服务目录
│   ├── main.py
│   ├── ocr_service.py
│   ├── requirements.txt
│   ├── Dockerfile
│   └── README.md
├── frontend/                          # 前端服务目录（从当前项目复制）
│   ├── src/
│   ├── package.json
│   ├── next.config.js
│   └── tsconfig.json
├── config/                            # 配置文件目录
│   ├── .env.example
│   └── .env
└── docs/                              # 文档目录
    ├── DEPLOYMENT_GUIDE.md
    ├── USER_MANUAL.md
    └── TROUBLESHOOTING.md
```

## 🚀 快速开始（推荐）

### 前置要求

- **Windows 10/11**（推荐）
- **Docker Desktop**（必须）- [下载链接](https://www.docker.com/products/docker-desktop)
- **Git**（可选，用于代码克隆）
- **4GB+ 可用内存**
- **10GB+ 可用磁盘空间**

### 一键安装

1. **下载部署包**
   - 将整个项目文件夹复制到本地，例如：`C:\card-ocr-deployment`

2. **运行安装脚本**
   - 右键点击 `install.bat`
   - 选择"以管理员身份运行"
   - 等待安装完成（首次需要下载依赖，约10-20分钟）

3. **启动服务**
   - 双击运行 `start.bat`
   - 或右键选择"以管理员身份运行"

4. **访问应用**
   - 浏览器打开：http://localhost:5000

### 快速命令

```cmd
# 检查依赖
check-deps.bat

# 启动服务
start.bat

# 查看状态
status.bat

# 停止服务
stop.bat
```

## 📋 详细部署步骤

### 方式1：Docker部署（推荐）

#### 优点
- ✅ 环境隔离，不污染系统
- ✅ 一键安装，自动配置
- ✅ 跨平台兼容
- ✅ 易于维护和更新

#### 步骤

1. **安装Docker Desktop**
   - 下载并安装 [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop)
   - 安装完成后重启电脑
   - 启动Docker Desktop，确保Docker正在运行

2. **解压部署包**
   - 将部署包解压到任意目录，例如：`C:\card-ocr-deployment`

3. **运行一键安装**
   ```cmd
   cd C:\card-ocr-deployment
   install.bat
   ```

4. **启动服务**
   ```cmd
   start.bat
   ```

5. **验证安装**
   - 打开浏览器访问：http://localhost:5000
   - 应该看到购物卡识别界面

### 方式2：本地Python+Node.js部署

#### 前置要求
- Python 3.8+
- Node.js 16+
- Git

#### 步骤

1. **安装Python**
   - 下载并安装 [Python 3.9+](https://www.python.org/downloads/)
   - 安装时勾选"Add Python to PATH"

2. **安装Node.js**
   - 下载并安装 [Node.js 16+](https://nodejs.org/)

3. **克隆项目**
   ```cmd
   git clone <repository-url>
   cd card-ocr-deployment
   ```

4. **安装后端依赖**
   ```cmd
   cd backend
   pip install -r requirements.txt
   cd ..
   ```

5. **安装前端依赖**
   ```cmd
   cd frontend
   npm install
   cd ..
   ```

6. **启动后端服务**
   ```cmd
   cd backend
   python main.py
   ```

7. **启动前端服务**（新开一个终端）
   ```cmd
   cd frontend
   npm run dev
   ```

## 🔧 配置说明

### 环境变量配置

创建 `config/.env` 文件：

```env
# PaddleOCR服务地址（Docker部署时使用内部地址）
PADDLEOCR_API_URL=http://paddleocr-service:8001

# 本地部署时使用
# PADDLEOCR_API_URL=http://localhost:8001

# 其他配置
OFFLINE_MODE=true
DEBUG=false
```

### Docker Compose配置

`docker-compose.yml` 文件内容：

```yaml
version: '3.8'

services:
  # PaddleOCR后端服务
  paddleocr-service:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: paddleocr-service
    ports:
      - "8001:8001"
    volumes:
      - paddleocr-cache:/root/.paddleocr
    environment:
      - USE_GPU=false
      - LANG=ch
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8001/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s

  # Next.js前端服务
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    container_name: card-ocr-frontend
    ports:
      - "5000:5000"
    environment:
      - PADDLEOCR_API_URL=http://paddleocr-service:8001
      - NODE_ENV=production
    depends_on:
      - paddleocr-service
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:5000"]
      interval: 30s
      timeout: 10s
      retries: 3

volumes:
  paddleocr-cache:
    driver: local

networks:
  default:
    name: card-ocr-network
```

## 📝 使用说明

### 1. 访问应用

浏览器打开：http://localhost:5000

### 2. 设置识别模板（推荐首次使用）

1. 点击"设置识别模板"按钮
2. 上传一张清晰的卡片图片
3. 在图片上框选卡号区域
4. 框选密码区域
5. 保存模板

### 3. 批量识别

1. 点击"上传图片"
2. 选择多张卡片图片
3. 点击"开始识别"
4. 等待识别完成
5. 查看和编辑结果
6. 导出Excel

## 🛠️ 常见问题

### 问题1：Docker Desktop未启动

**错误信息**：`Cannot connect to the Docker daemon`

**解决方案**：
1. 打开Docker Desktop
2. 等待Docker服务启动完成
3. 重新运行 `start.bat`

### 问题2：端口被占用

**错误信息**：`bind: address already in use`

**解决方案**：
1. 检查端口占用：
   ```cmd
   netstat -ano | findstr :5000
   netstat -ano | findstr :8001
   ```
2. 结束占用进程或修改端口配置

### 问题3：PaddleOCR模型下载失败

**解决方案**：
1. 检查网络连接
2. 重启服务：
   ```cmd
   stop.bat
   start.bat
   ```
3. 手动下载模型（参考 `docs/TROUBLESHOOTING.md`）

### 问题4：内存不足

**解决方案**：
1. 关闭其他占用内存的程序
2. 在Docker设置中增加内存分配（建议4GB+）
3. 减小批处理数量

## 📊 性能优化

### 1. 启用GPU加速（如果可用）

修改 `backend/Dockerfile`：

```dockerfile
# 安装GPU版本的PaddlePaddle
RUN pip install paddlepaddle-gpu==3.2.2
```

修改 `docker-compose.yml`：

```yaml
paddleocr-service:
  environment:
    - USE_GPU=true
  deploy:
    resources:
      reservations:
        devices:
          - driver: nvidia
            count: 1
            capabilities: [gpu]
```

### 2. 调整识别参数

编辑 `backend/ocr_service.py`：

```python
self._ocr_engine = PaddleOCR(
    use_angle_cls=True,
    lang='ch',
    use_gpu=False,
    det_db_thresh=0.3,    # 调整检测阈值
    rec_batch_num=10,     # 增加批处理大小
    max_side_len=960,     # 调整最大边长
)
```

## 🔐 安全建议

1. **修改默认端口**
   - 修改 `docker-compose.yml` 中的端口映射
   - 避免使用常见端口

2. **启用HTTPS**
   - 配置反向代理（Nginx）
   - 申请SSL证书

3. **限制访问**
   - 使用防火墙规则
   - 添加用户认证

4. **定期更新**
   - 定期更新Docker镜像
   - 及时安装安全补丁

## 📞 技术支持

- **部署文档**：`docs/DEPLOYMENT_GUIDE.md`
- **使用手册**：`docs/USER_MANUAL.md`
- **故障排除**：`docs/TROUBLESHOOTING.md`
- **在线文档**：https://github.com/your-repo/docs

## 📄 许可证

本项目采用 MIT 许可证。

---

**注意**：首次启动需要下载PaddleOCR模型文件（约200MB），请确保网络连接正常。模型下载完成后会缓存到本地，后续启动无需重复下载。
