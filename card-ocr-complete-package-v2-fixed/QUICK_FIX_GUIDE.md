# 快速修复指南 - Docker Compose 配置文件问题

## 问题描述

如果您遇到以下错误：
```
[4/6] Building Docker images...
no configuration file provided: not found
[ERROR] Docker image build failed!
```

## ✅ 解决方案

### 方案 1：使用最新版本 v1.0.2（推荐）

**v1.0.2 已完全修复此问题！**

**下载链接**：
```
https://coze-coding-project.tos.coze.site/coze_storage_7602859016070627343/card-ocr-deployment-v1.0.2.tar_0f472397.gz?sign=1772777318-80e6642fbd-0-aba20f17a4d4fd9290951670949b7713e4aaf2b169a6f483162587614227fd31
```

**快速修复步骤**：
1. 下载 v1.0.2 版本的部署包
2. 使用7-Zip解压
3. 右键运行 `install.bat`（管理员）
4. 完成！

---

### 方案 2：手动修复旧版本

如果您使用的是旧版本（v1.0.0 或 v1.0.1），可以手动修复：

#### 步骤 1：检查文件结构

解压后，确保看到以下文件：
```
card-ocr-deployment-package/
├── docker-compose.yml          ← 必须存在
├── install.bat
├── start.bat
├── backend/
├── frontend/
└── ...
```

#### 步骤 2：确认 docker-compose.yml 存在

打开文件资源管理器，导航到解压后的文件夹，查看是否有 `docker-compose.yml` 文件。

#### 步骤 3：从正确的目录运行脚本

**正确的方式**：
```
✅ 在 card-ocr-deployment-package 文件夹内双击 install.bat
```

**错误的方式**：
```
❌ 在父文件夹或其他位置运行 install.bat
❌ 从命令行跳转到其他目录后运行脚本
```

#### 步骤 4：验证当前目录

打开命令提示符（CMD），执行：
```cmd
cd <解压后的文件夹路径>
dir
```

应该能看到 `docker-compose.yml` 文件。

---

### 方案 3：手动创建缺失文件（紧急情况）

如果 `docker-compose.yml` 文件确实缺失，可以手动创建：

1. 在解压后的文件夹中，新建一个文本文件
2. 重命名为 `docker-compose.yml`
3. 粘贴以下内容：

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
      - ./logs:/app/logs
    environment:
      - USE_GPU=false
      - LANG=ch
      - OCR_PORT=8001
      - LOG_LEVEL=INFO
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8001/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s
    networks:
      - card-ocr-network

  # Next.js前端服务
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
      args:
        - PADDLEOCR_API_URL=http://paddleocr-service:8001
    container_name: card-ocr-frontend
    ports:
      - "5000:5000"
    environment:
      - PADDLEOCR_API_URL=http://paddleocr-service:8001
      - NODE_ENV=production
    depends_on:
      paddleocr-service:
        condition: service_healthy
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:5000"]
      interval: 30s
      timeout: 10s
      retries: 3
    networks:
      - card-ocr-network

volumes:
  paddleocr-cache:
    driver: local

networks:
  card-ocr-network:
    driver: bridge
```

4. 保存文件
5. 重新运行 `install.bat`

---

## 🔍 诊断步骤

### 步骤 1：确认版本

查看下载的文件名：
- `card-ocr-deployment-v1.0.0.tar.gz` - ❌ 旧版本（有问题）
- `card-ocr-deployment-v1.0.1-fixed.tar.gz` - ❌ 旧版本（部分修复）
- `card-ocr-deployment-v1.0.2.tar.gz` - ✅ 最新版本（完全修复）

### 步骤 2：检查文件完整性

解压后，确保以下文件存在：
```
✅ docker-compose.yml
✅ install.bat
✅ start.bat
✅ stop.bat
✅ status.bat
✅ backend/Dockerfile
✅ backend/main.py
✅ frontend/Dockerfile
```

### 步骤 3：测试Docker

打开命令提示符，执行：
```cmd
docker --version
docker-compose --version
```

如果都显示版本信息，说明Docker已正确安装。

### 步骤 4：检查端口占用

```cmd
netstat -ano | findstr :5000
netstat -ano | findstr :8001
```

如果有输出，说明端口被占用，需要停止占用端口的程序。

---

## 📞 获取帮助

如果以上方法都无法解决问题，请：

1. **查看详细日志**：
   ```cmd
   docker-compose logs
   ```

2. **检查Docker状态**：
   ```cmd
   docker info
   docker ps -a
   ```

3. **重新下载**：
   - 删除旧的解压文件夹
   - 重新下载 v1.0.2 版本
   - 重新解压

4. **查看文档**：
   - 解压后查看 `docs/TROUBLESHOOTING.md`
   - 查看 `QUICKSTART.md`

---

## ✅ 推荐方案

**最简单、最可靠的解决方案**：

1. ✅ 下载 v1.0.2 版本（包含所有修复）
2. ✅ 使用7-Zip解压
3. ✅ 右键运行 `install.bat`（管理员）
4. ✅ 完成！

**v1.0.2 已修复**：
- ✅ 批处理文件编码问题
- ✅ 脚本目录路径问题
- ✅ 配置文件检查
- ✅ 错误提示改进

---

**最后更新**：2025-02-04
**推荐版本**：v1.0.2
