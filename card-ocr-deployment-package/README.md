# 📦 购物卡/加油卡OCR识别系统 - Windows一键部署包

> 基于PaddleOCR-VL-1.5的本地化OCR识别系统，完全离线运行

## 🚀 快速开始

### 1. 系统要求
- Windows 10/11
- Docker Desktop 4.15+
- 4GB+ 内存
- 10GB+ 磁盘空间

### 2. 安装步骤

```cmd
# 1. 检查依赖
check-deps.bat

# 2. 运行安装（右键，管理员）
install.bat

# 3. 启动服务
start.bat

# 4. 访问应用
浏览器打开：http://localhost:5000
```

## 📖 文档

- **快速开始**: QUICKSTART.md
- **详细部署**: docs/DEPLOYMENT_GUIDE.md
- **用户手册**: docs/USER_MANUAL.md
- **故障排除**: docs/TROUBLESHOOTING.md

## 🛠️ 管理命令

| 操作 | 命令 |
|------|------|
| 启动服务 | start.bat |
| 停止服务 | stop.bat |
| 查看状态 | status.bat |
| 检查依赖 | check-deps.bat |

## ⚠️ 注意事项

- 首次安装需要10-20分钟（下载依赖）
- 必须以管理员身份运行install.bat
- 确保Docker Desktop已启动
- 首次启动会下载PaddleOCR模型（约200MB）

## 📞 技术支持

查看完整文档：docs/ 文件夹

---

**祝您使用愉快！** 🎉
