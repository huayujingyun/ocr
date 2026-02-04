# Windows部署详细指南

## 目录

1. [系统要求](#系统要求)
2. [安装准备](#安装准备)
3. [一键安装](#一键安装)
4. [手动安装](#手动安装)
5. [配置说明](#配置说明)
6. [启动和停止](#启动和停止)
7. [常见问题](#常见问题)
8. [性能优化](#性能优化)
9. [备份和恢复](#备份和恢复)
10. [卸载](#卸载)

---

## 系统要求

### 必需条件

- **操作系统**: Windows 10（版本1903+）或 Windows 11
- **处理器**: 64位处理器，支持虚拟化（VT-x/AMD-V）
- **内存**: 最小4GB，推荐8GB+
- **磁盘空间**: 最小10GB可用空间（推荐20GB+）
- **网络**: 首次安装需要互联网连接（下载依赖和模型）

### 软件要求

- **Docker Desktop**: 4.15+（必须）
- **Windows Subsystem for Linux 2 (WSL2)**: Docker Desktop自动安装
- **Git**: 2.25+（可选，用于代码管理）

---

## 安装准备

### 1. 启用虚拟化

1. 打开任务管理器（Ctrl+Shift+Esc）
2. 切换到"性能"选项卡
3. 点击"CPU"
4. 查看右下角"虚拟化"状态
5. 如果显示"已禁用"，需要在BIOS中启用

### 2. 安装Docker Desktop

#### 下载和安装

1. 访问 [Docker官网](https://www.docker.com/products/docker-desktop)
2. 下载Windows版本的Docker Desktop
3. 运行安装程序，按照向导完成安装
4. 安装完成后重启计算机

#### 配置Docker

1. 启动Docker Desktop
2. 点击右上角设置图标
3. 配置以下选项：

**Resources → Advanced**:
- Memory: 4GB+（推荐8GB）
- Swap: 2GB
- Disk image size: 60GB+
- CPUs: 2+

**Resources → File Sharing**:
- 启用项目所在盘符（如C:、D:）

**General**:
- 勾选"Use WSL 2 based engine"
- 勾选"Start Docker Desktop when you log in"

### 3. 下载部署包

1. 下载项目部署包压缩文件
2. 解压到任意目录，例如：`C:\card-ocr-deployment`
3. 确保解压后的文件结构正确

---

## 一键安装

### 步骤1：检查依赖

双击运行 `check-deps.bat`，检查所有依赖是否满足要求。

**预期输出**：
```
[✓] Windows版本：Windows 10/11
[✓] Docker Desktop已安装
[✓] Docker服务运行正常
[✓] 端口5000可用
[✓] 端口8001可用
[✓] docker-compose.yml 存在
```

如果所有检查都通过，可以继续下一步。如有错误，请先解决。

### 步骤2：运行安装脚本

1. 右键点击 `install.bat`
2. 选择"以管理员身份运行"
3. 等待安装完成（首次需要10-20分钟）

**安装过程**：
```
[1/6] 检查系统环境...
[✓] Docker Desktop 已安装

[2/6] 创建必要的目录...
[✓] 目录创建完成

[3/6] 配置环境变量...
[✓] 环境变量文件已创建

[4/6] 构建Docker镜像...
（这里需要较长时间，请耐心等待）

[5/6] 启动服务...
[✓] 服务启动成功

[6/6] 等待服务就绪...
```

### 步骤3：验证安装

1. 打开浏览器
2. 访问：http://localhost:5000
3. 应该看到购物卡识别界面

---

## 手动安装

如果一键安装遇到问题，可以尝试手动安装。

### 步骤1：克隆项目

```cmd
git clone <repository-url>
cd card-ocr-deployment
```

### 步骤2：创建配置文件

```cmd
cd config
copy .env.example .env
cd ..
```

### 步骤3：构建镜像

```cmd
# 构建后端镜像
cd backend
docker build -t paddleocr-service:latest .
cd ..

# 构建前端镜像
cd frontend
docker build -t card-ocr-frontend:latest .
cd ..
```

### 步骤4：启动服务

```cmd
docker-compose up -d
```

### 步骤5：验证安装

```cmd
# 检查容器状态
docker-compose ps

# 检查后端服务
curl http://localhost:8001/health

# 检查前端服务
curl http://localhost:5000
```

---

## 配置说明

### 环境变量配置

编辑 `config/.env` 文件：

```env
# PaddleOCR服务地址
PADDLEOCR_API_URL=http://paddleocr-service:8001

# 运行模式
OFFLINE_MODE=true
DEBUG=false

# 日志级别
LOG_LEVEL=INFO

# OCR参数
USE_GPU=false
LANG=ch
```

### 修改端口

如果默认端口被占用，可以修改 `docker-compose.yml`：

```yaml
services:
  paddleocr-service:
    ports:
      - "8100:8001"  # 修改外部端口

  frontend:
    ports:
      - "5100:5000"   # 修改外部端口
```

### 启用GPU加速（如果可用）

**前提条件**：
- NVIDIA显卡
- 安装NVIDIA驱动
- 安装NVIDIA Container Toolkit

**步骤**：

1. 修改 `backend/Dockerfile`，使用GPU版本：
```dockerfile
RUN pip install paddlepaddle-gpu==3.2.2
```

2. 修改 `docker-compose.yml`：
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

---

## 启动和停止

### 启动服务

**方式1：使用脚本**
```cmd
start.bat
```

**方式2：使用命令**
```cmd
docker-compose up -d
```

**方式3：查看日志启动**
```cmd
docker-compose up
```

### 停止服务

**方式1：使用脚本**
```cmd
stop.bat
```

**方式2：使用命令**
```cmd
docker-compose down
```

### 查看状态

**方式1：使用脚本**
```cmd
status.bat
```

**方式2：使用命令**
```cmd
docker-compose ps
```

### 查看日志

```cmd
# 查看所有日志
docker-compose logs -f

# 查看后端日志
docker-compose logs -f paddleocr-service

# 查看前端日志
docker-compose logs -f frontend

# 查看最近100行日志
docker-compose logs --tail=100
```

### 重启服务

```cmd
# 重启所有服务
docker-compose restart

# 重启单个服务
docker-compose restart paddleocr-service
docker-compose restart frontend
```

---

## 常见问题

### 问题1：Docker Desktop未启动

**错误信息**：
```
Cannot connect to the Docker daemon
```

**解决方案**：
1. 打开Docker Desktop
2. 等待Docker服务启动完成
3. 重新运行安装脚本

### 问题2：端口被占用

**错误信息**：
```
bind: address already in use
```

**解决方案**：
```cmd
# 查看端口占用
netstat -ano | findstr :5000
netstat -ano | findstr :8001

# 结束占用进程
taskkill /PID <进程ID> /F

# 或修改docker-compose.yml中的端口映射
```

### 问题3：构建失败

**错误信息**：
```
ERROR: failed to solve
```

**解决方案**：
1. 检查网络连接
2. 清理Docker缓存：
```cmd
docker system prune -a
```
3. 重新构建：
```cmd
docker-compose build --no-cache
```

### 问题4：内存不足

**错误信息**：
```
OOMKilled
```

**解决方案**：
1. 在Docker Desktop中增加内存分配
2. 或减小批处理数量（修改 `backend/ocr_service.py`）

### 问题5：PaddleOCR模型下载失败

**错误信息**：
```
Connection refused
```

**解决方案**：
1. 检查网络连接
2. 重启服务：
```cmd
docker-compose restart paddleocr-service
```
3. 查看详细日志：
```cmd
docker-compose logs paddleocr-service
```

---

## 性能优化

### 1. 增加批处理数量

编辑 `backend/ocr_service.py`：
```python
self._ocr_engine = PaddleOCR(
    rec_batch_num=10,  # 增加批处理大小
)
```

### 2. 调整图片尺寸

编辑 `backend/ocr_service.py`：
```python
self._ocr_engine = PaddleOCR(
    max_side_len=1280,  # 增加最大边长
)
```

### 3. 使用SSD存储

确保Docker数据和卷存储在SSD上，可以显著提高IO性能。

### 4. 调整Docker资源分配

在Docker Desktop中：
- Memory: 8GB+
- CPUs: 4+
- Disk image size: 60GB+

---

## 备份和恢复

### 备份数据

```cmd
# 备份Docker卷
docker run --rm -v paddleocr-cache:/data -v %CD%:\backup:/backup alpine tar czf /backup/paddleocr-cache-backup.tar.gz /data

# 备份配置文件
xcopy config\ backup\config\ /E /I /Y
```

### 恢复数据

```cmd
# 恢复Docker卷
docker run --rm -v paddleocr-cache:/data -v %CD%:\backup:/backup alpine tar xzf /backup/paddleocr-cache-backup.tar.gz -C /

# 恢复配置文件
xcopy backup\config\ config\ /E /I /Y

# 重启服务
docker-compose restart
```

---

## 卸载

### 完全卸载

```cmd
# 停止并删除所有容器
docker-compose down -v

# 删除Docker镜像
docker rmi paddleocr-service:latest
docker rmi card-ocr-frontend:latest

# 删除项目文件（谨慎操作）
# rmdir /s /q C:\card-ocr-deployment
```

### 清理Docker缓存

```cmd
# 清理未使用的镜像
docker image prune -a

# 清理未使用的卷
docker volume prune

# 清理所有未使用的数据
docker system prune -a
```

---

## 技术支持

如果遇到其他问题：

1. 查看日志文件：`logs/` 目录
2. 查看故障排除文档：`docs/TROUBLESHOOTING.md`
3. 访问在线文档：https://github.com/your-repo/docs
4. 提交Issue：https://github.com/your-repo/issues

---

**祝您使用愉快！**
