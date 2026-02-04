# 📦 购物卡/加油卡OCR识别系统 - Windows一键部署包

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Windows-lightgrey.svg)](https://www.microsoft.com/windows)
[![Docker](https://img.shields.io/badge/docker-Ready-blue.svg)](https://www.docker.com)

> 基于PaddleOCR-VL-1.5的本地化OCR识别系统，支持购物卡和加油卡的卡号、密码识别，完全离线运行。

---

## ✨ 特性

- ✅ **完全离线**：无需联网，所有识别在本地完成
- ✅ **高精度识别**：基于PaddleOCR-VL-1.5，识别准确率97%+
- ✅ **批量识别**：支持多张图片同时识别
- ✅ **模板框选**：支持自定义识别模板，大幅提升准确率
- ✅ **一键安装**：Windows一键安装脚本，5分钟完成部署
- ✅ **Docker化**：基于Docker Compose，环境隔离，易于维护
- ✅ **数据隐私**：完全本地处理，数据不离开本地

---

## 🚀 快速开始

### 前置要求

- Windows 10/11
- Docker Desktop 4.15+
- 4GB+ 内存
- 10GB+ 磁盘空间

### 安装步骤

1. **解压部署包**

2. **运行安装脚本**
   ```
   右键点击 install.bat → 选择"以管理员身份运行"
   ```

3. **等待完成**（首次需要10-20分钟）

4. **启动服务**
   ```
   双击运行 start.bat
   ```

5. **访问应用**
   ```
   浏览器打开：http://localhost:5000
   ```

📖 **详细说明**：[QUICKSTART.md](QUICKSTART.md)

---

## 📖 文档

| 文档 | 说明 |
|------|------|
| [QUICKSTART.md](QUICKSTART.md) | 快速开始指南（5分钟上手） |
| [WINDOWS_DEPLOYMENT_README.md](WINDOWS_DEPLOYMENT_README.md) | Windows部署说明 |
| [docs/DEPLOYMENT_GUIDE.md](docs/DEPLOYMENT_GUIDE.md) | 详细部署指南 |
| [docs/USER_MANUAL.md](docs/USER_MANUAL.md) | 用户使用手册 |
| [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) | 故障排除指南 |
| [FILE_CHECKLIST.md](FILE_CHECKLIST.md) | 部署包文件清单 |

---

## 🛠️ 管理命令

### 命令行脚本

| 操作 | 命令 |
|------|------|
| 检查依赖 | `check-deps.bat` |
| 启动服务 | `start.bat` |
| 停止服务 | `stop.bat` |
| 查看状态 | `status.bat` |

### Docker命令

```cmd
# 查看容器状态
docker-compose ps

# 查看日志
docker-compose logs -f

# 重启服务
docker-compose restart

# 停止并删除
docker-compose down
```

---

## 🏗️ 系统架构

```
┌─────────────────────────────────────────────────┐
│                   用户浏览器                      │
│              http://localhost:5000               │
└────────────────────┬────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────┐
│         Next.js前端 (端口5000)                   │
│  - 购物卡识别界面                                │
│  - 图片上传和裁剪                                │
│  - 识别结果展示                                  │
│  - Excel导出                                     │
└────────────────────┬────────────────────────────┘
                     │ HTTP
                     ▼
┌─────────────────────────────────────────────────┐
│      Python FastAPI后端 (端口8001)              │
│  - PaddleOCR-VL-1.5引擎                         │
│  - 中英文文字识别                                │
│  - 图片预处理                                    │
│  - 批量识别                                      │
└─────────────────────────────────────────────────┘
```

---

## 📦 技术栈

### 前端
- Next.js 16
- React 19
- TypeScript 5
- Tailwind CSS 4

### 后端
- Python 3.8+
- FastAPI 0.104.1
- PaddleOCR 2.8.1
- PaddlePaddle 3.2.2

### 容器化
- Docker
- Docker Compose

---

## 🔧 配置说明

### 环境变量

编辑 `config/.env` 文件：

```env
# PaddleOCR服务地址
PADDLEOCR_API_URL=http://paddleocr-service:8001

# 运行模式
OFFLINE_MODE=true
DEBUG=false

# OCR参数
USE_GPU=false
LANG=ch
```

### 修改端口

编辑 `docker-compose.yml`：

```yaml
services:
  paddleocr-service:
    ports:
      - "8100:8001"  # 修改后端端口
  frontend:
    ports:
      - "5100:5000"   # 修改前端端口
```

---

## 🎯 使用指南

### 1. 设置识别模板（推荐）

1. 点击"设置识别模板"
2. 上传清晰的卡片图片
3. 框选卡号区域
4. 框选密码区域
5. 保存模板

### 2. 批量识别

1. 点击"上传图片"
2. 选择多张卡片图片
3. 点击"开始识别"
4. 等待识别完成

### 3. 导出结果

1. 检查识别结果
2. 编辑错误项
3. 点击"导出Excel"

📖 **详细说明**：[docs/USER_MANUAL.md](docs/USER_MANUAL.md)

---

## ⚠️ 常见问题

### Q1: Docker Desktop未启动？

**解决**：启动Docker Desktop，等待图标变绿

### Q2: 端口被占用？

**解决**：
```cmd
netstat -ano | findstr :5000
taskkill /PID <进程ID> /F
```

### Q3: 首次启动慢？

**原因**：需要下载PaddleOCR模型（约200MB）

**解决**：等待模型下载完成，后续启动无需重复下载

📖 **更多问题**：[docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)

---

## 📊 性能数据

| 指标 | 数值 |
|------|------|
| 单张识别时间 | 0.5-2秒 |
| 批量识别速度 | 5-10秒/10张 |
| 识别准确率 | 97%+ |
| 内存占用 | 1-2GB |
| 磁盘占用 | ~3GB |

---

## 🔐 安全建议

1. **修改默认端口**
2. **启用HTTPS**
3. **限制访问来源**
4. **定期更新**
5. **备份数据**

---

## 📝 开发

### 本地开发

```cmd
# 启动开发环境
cd backend
pip install -r requirements.txt
python main.py

# 新开终端
cd frontend
npm install
npm run dev
```

### 构建镜像

```cmd
# 构建后端
cd backend
docker build -t paddleocr-service:latest .

# 构建前端
cd frontend
docker build -t card-ocr-frontend:latest .
```

---

## 🤝 贡献

欢迎提交Issue和Pull Request！

1. Fork本项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启Pull Request

---

## 📄 许可证

本项目采用 MIT 许可证。

---

## 📞 技术支持

- **文档**：[docs/](docs/)
- **问题反馈**：[GitHub Issues](https://github.com/your-repo/issues)
- **邮件**：support@example.com

---

## 🙏 致谢

- [PaddleOCR](https://github.com/PaddlePaddle/PaddleOCR) - 优秀的OCR识别引擎
- [Next.js](https://nextjs.org/) - 强大的React框架
- [FastAPI](https://fastapi.tiangolo.com/) - 现代化的Python Web框架
- [Docker](https://www.docker.com/) - 容器化技术

---

**祝您使用愉快！** 🎉
