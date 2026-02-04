# 部署包文件清单

## 根目录文件

| 文件 | 说明 | 必需 |
|------|------|------|
| `README.md` | 项目说明文档 | ✅ |
| `QUICKSTART.md` | 快速开始指南 | ✅ |
| `install.bat` | 一键安装脚本 | ✅ |
| `start.bat` | 启动服务脚本 | ✅ |
| `stop.bat` | 停止服务脚本 | ✅ |
| `status.bat` | 查看状态脚本 | ✅ |
| `check-deps.bat` | 依赖检查脚本 | ✅ |
| `package.bat` | 打包脚本 | ⚠️ 开发用 |
| `docker-compose.yml` | Docker编排配置 | ✅ |

## backend/ 目录

| 文件 | 说明 | 必需 |
|------|------|------|
| `main.py` | FastAPI主应用 | ✅ |
| `ocr_service.py` | PaddleOCR服务封装 | ✅ |
| `requirements.txt` | Python依赖列表 | ✅ |
| `Dockerfile` | 后端Docker镜像 | ✅ |
| `README.md` | 后端说明文档 | ✅ |
| `.env.example` | 环境变量示例 | ✅ |
| `start.sh` | Linux启动脚本 | ⚠️ 开发用 |

## frontend/ 目录

| 文件 | 说明 | 必需 |
|------|------|------|
| `Dockerfile` | 前端Docker镜像 | ✅ |
| `package.json` | Node.js依赖配置 | ✅ |
| `pnpm-lock.yaml` | 依赖锁定文件 | ✅ |
| `next.config.js` | Next.js配置 | ✅ |
| `tsconfig.json` | TypeScript配置 | ✅ |
| `src/` | 源代码目录 | ✅ |
| `public/` | 静态资源目录 | ✅ |
| `.gitignore` | Git忽略文件 | ⚠️ 开发用 |

## config/ 目录

| 文件 | 说明 | 必需 |
|------|------|------|
| `.env.example` | 环境变量示例 | ✅ |
| `.env` | 环境变量配置 | ⚠️ 安装时生成 |

## docs/ 目录

| 文件 | 说明 | 必需 |
|------|------|------|
| `DEPLOYMENT_GUIDE.md` | 详细部署指南 | ✅ |
| `USER_MANUAL.md` | 用户手册 | ✅ |
| `TROUBLESHOOTING.md` | 故障排除指南 | ✅ |

## 其他目录（可选）

| 目录 | 说明 | 必需 |
|------|------|------|
| `logs/` | 日志目录 | ⚠️ 运行时生成 |
| `data/` | 数据目录 | ⚠️ 运行时生成 |
| `backup/` | 备份目录 | ⚠️ 用户自行创建 |

## 文件大小估算

| 项目 | 大小 |
|------|------|
| 源代码 | ~50 MB |
| Docker镜像（后端） | ~2 GB |
| Docker镜像（前端） | ~500 MB |
| PaddleOCR模型 | ~200 MB |
| 总计 | ~2.8 GB |

## 压缩包大小

- **不包含Docker镜像**：~10 MB
- **包含Docker镜像**：~2.5 GB

## 打包建议

### 开发版（不含镜像）
- 适合开发环境
- 下载速度快
- 运行时自动构建镜像

### 完整版（含镜像）
- 适合生产环境
- 开箱即用
- 下载时间长

## 安装前检查清单

在安装前，请确保：

- [ ] Docker Desktop已安装并启动
- [ ] Windows版本为10或11
- [ ] 至少4GB可用内存
- [ ] 至少10GB可用磁盘空间
- [ ] 有管理员权限
- [ ] 网络连接正常（首次安装）

## 安装后目录结构

```
card-ocr-deployment/
├── README.md
├── QUICKSTART.md
├── install.bat
├── start.bat
├── stop.bat
├── status.bat
├── check-deps.bat
├── docker-compose.yml
├── backend/
│   ├── main.py
│   ├── ocr_service.py
│   ├── requirements.txt
│   ├── Dockerfile
│   └── .env.example
├── frontend/
│   ├── Dockerfile
│   ├── package.json
│   ├── pnpm-lock.yaml
│   ├── next.config.js
│   ├── tsconfig.json
│   ├── src/
│   └── public/
├── config/
│   ├── .env.example
│   └── .env (安装时生成)
├── docs/
│   ├── DEPLOYMENT_GUIDE.md
│   ├── USER_MANUAL.md
│   └── TROUBLESHOOTING.md
├── logs/ (运行时生成)
└── data/ (运行时生成)
```

## 版本信息

- **版本号**：1.0.0
- **发布日期**：2024年
- **Python版本**：3.8+
- **Node.js版本**：16+
- **Docker版本**：4.15+

## 下载地址

- **开发版**：[下载链接]
- **完整版**：[下载链接]

## 更新日志

### v1.0.0 (2024)
- ✅ 初始版本发布
- ✅ 支持PaddleOCR-VL-1.5
- ✅ 完全离线运行
- ✅ Windows一键安装
- ✅ Docker化部署

---

**如有疑问，请参考文档或联系技术支持。**
