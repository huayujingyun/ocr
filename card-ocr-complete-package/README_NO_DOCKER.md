# 购物卡OCR识别系统 - 非Docker部署方案

## 🎯 适用场景

**此版本适用于以下情况**：
- ✅ Docker Desktop 无法安装或启动
- ✅ 系统资源有限（不支持虚拟化）
- ✅ Windows 7/8 等旧版本系统
- ✅ 不想使用 Docker 的用户

## 🔧 系统要求

### 必需软件
- **操作系统**：Windows 7/8/10/11（64位）
- **Python**：3.12 或更高版本
- **Node.js**：18.0 或更高版本
- **内存**：至少 8GB RAM
- **磁盘空间**：至少 10GB 可用空间

### 可选软件
- Git（用于版本控制）

## 📥 快速开始

### 步骤 1：下载部署包

下载非 Docker 版本的部署包（即将上传）

### 步骤 2：解压文件

使用 7-Zip 或 WinRAR 解压 `.zip` 文件

### 步骤 3：安装 Python

1. 访问 https://www.python.org/downloads/release/python-3127/
2. 下载 Windows installer (64-bit)
3. **重要**：安装时勾选 "Add Python to PATH"
4. 安装完成后，打开命令提示符验证：

```cmd
python --version
pip --version
```

### 步骤 4：安装 Node.js

1. 访问 https://nodejs.org/
2. 下载 LTS 版本
3. 运行安装程序
4. 安装完成后验证：

```cmd
node --version
npm --version
```

### 步骤 5：运行安装脚本

1. 右键点击 `install-no-docker.bat`
2. 选择"以管理员身份运行"
3. 等待安装完成（可能需要 10-20 分钟）

**安装过程包括**：
- 检查系统环境
- 安装 Python 依赖（PaddleOCR、FastAPI 等）
- 安装 Node.js 依赖
- 构建前端应用
- 创建启动脚本

### 步骤 6：启动服务

**方式 1：一键启动（推荐）**
```
双击 start-all-no-docker.bat
```

**方式 2：分别启动**
```
1. 双击 start-backend.bat（启动后端）
2. 双击 start-frontend.bat（启动前端）
```

### 步骤 7：访问系统

打开浏览器访问：http://localhost:5000

## 📂 文件结构

```
card-ocr-no-docker/
├── install-no-docker.bat       ✅ 一键安装脚本
├── start-all-no-docker.bat     ✅ 一键启动脚本
├── start-backend.bat           ✅ 后端启动脚本
├── start-frontend.bat          ✅ 前端启动脚本
├── backend/                    ✅ 后端服务
│   ├── main.py                ✅ FastAPI 主程序
│   ├── ocr_service.py         ✅ PaddleOCR 服务
│   ├── requirements.txt       ✅ Python 依赖
│   └── models/                ✅ 模型缓存目录
├── src/                        ✅ 前端源码
├── package.json               ✅ Node.js 依赖配置
├── pnpm-lock.yaml             ✅ 锁定文件
├── tsconfig.json              ✅ TypeScript 配置
└── .env                       ✅ 环境变量
```

## 🔧 手动安装（如果脚本失败）

### 1. 安装 Python 依赖

打开命令提示符，进入 backend 目录：

```cmd
cd backend
pip install -r requirements.txt
```

**如果安装失败**：
```cmd
# 使用国内镜像
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 或使用阿里云镜像
pip install -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/
```

### 2. 安装前端依赖

```cmd
cd ..
pnpm install
```

### 3. 构建前端

```cmd
pnpm run build
```

### 4. 启动服务

**启动后端**：
```cmd
cd backend
python main.py
```

**启动前端**（新窗口）：
```cmd
cd ..
pnpm run start
```

## ✨ 功能特性

### OCR 识别
- ✅ 支持多图片批量上传
- ✅ 自动提取卡号和密码
- ✅ 模板框选识别模式
- ✅ 传统 OCR 识别模式
- ✅ 条码识别模式
- ✅ 完全离线运行

### 数据管理
- ✅ 识别结果编辑和校验
- ✅ Excel 导出（包含密码图片）
- ✅ 卡号和密码一一对应
- ✅ 图片尺寸适中（150x60 像素）

## 🚀 使用说明

### 第一次运行

首次启动时，PaddleOCR 会自动下载模型文件（约 200MB）：
- 模型会缓存到 `backend/models/` 目录
- 下载速度取决于网络连接
- 后续启动无需重新下载

### 日常使用

1. 启动服务：双击 `start-all-no-docker.bat`
2. 访问系统：http://localhost:5000
3. 上传图片：选择要识别的购物卡图片
4. 查看结果：系统自动提取卡号和密码
5. 导出数据：点击导出按钮生成 Excel 文件

### 停止服务

在启动脚本窗口按 `Ctrl+C` 或关闭窗口

## 🔍 故障排除

### 问题 1：Python 安装失败

**症状**：
```
ERROR: Could not find a version that satisfies the requirement
```

**解决方案**：
```cmd
# 更新 pip
python -m pip install --upgrade pip

# 使用国内镜像
pip install -r backend/requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
```

### 问题 2：后端启动失败

**症状**：
```
ModuleNotFoundError: No module named 'paddleocr'
```

**解决方案**：
```cmd
cd backend
pip install paddleocr paddlepaddle -i https://pypi.tuna.tsinghua.edu.cn/simple
```

### 问题 3：前端启动失败

**症状**：
```
Error: Cannot find module
```

**解决方案**：
```cmd
pnpm install
```

### 问题 4：端口被占用

**症状**：
```
Error: Port 5000 is already in use
```

**解决方案**：
```cmd
# 查找占用端口的进程
netstat -ano | findstr :5000

# 结束进程
taskkill /PID <进程ID> /F
```

### 问题 5：模型下载失败

**症状**：
```
Model download timeout
```

**解决方案**：
1. 检查网络连接
2. 手动下载模型文件
3. 配置国内镜像源

```cmd
# 设置环境变量使用国内镜像
set HF_ENDPOINT=https://hf-mirror.com
```

## 📊 性能优化

### 提升识别速度

1. **使用 GPU**（如果有）：
   ```python
   # backend/main.py
   ocr = PaddleOCR(use_angle_cls=True, lang="ch", use_gpu=True)
   ```

2. **调整批量大小**：
   ```python
   # 批量处理图片
   results = ocr.ocr(images, cls=True)
   ```

3. **优化图片大小**：
   - 上传前压缩图片
   - 使用适当的分辨率（建议 800-1200 像素）

### 减少内存占用

1. **限制并发数**：
   ```python
   # 限制同时处理的图片数量
   max_concurrent = 5
   ```

2. **清理缓存**：
   ```cmd
   # 删除模型缓存
   rmdir /s /q backend\models
   ```

## 🔄 更新升级

### 更新依赖

```cmd
# 更新 Python 依赖
cd backend
pip install --upgrade -r requirements.txt

# 更新前端依赖
cd ..
pnpm update
```

### 更新代码

```cmd
# 如果使用 Git
git pull origin main

# 重新安装依赖
pnpm install
cd backend
pip install -r requirements.txt
```

## 📚 参考文档

- [PaddleOCR 官方文档](https://github.com/PaddlePaddle/PaddleOCR)
- [FastAPI 官方文档](https://fastapi.tiangolo.com/)
- [Next.js 官方文档](https://nextjs.org/docs)

## 🆚 与 Docker 版本对比

| 特性 | Docker 版本 | 非 Docker 版本 |
|------|------------|---------------|
| 安装难度 | 中等 | 简单 |
| 资源占用 | 较高 | 较低 |
| 启动速度 | 慢（首次） | 快 |
| 依赖管理 | 自动 | 手动 |
| 端口隔离 | 是 | 否 |
| 推荐场景 | 生产环境 | 开发/测试 |

## ⚠️ 注意事项

1. **端口冲突**：确保 5000 和 8001 端口未被占用
2. **权限问题**：某些操作可能需要管理员权限
3. **防火墙**：确保防火墙允许端口 5000 和 8001
4. **网络连接**：首次运行需要联网下载模型
5. **系统资源**：建议至少 8GB 内存

## 📞 技术支持

### 常见问题

查看 `DOCKER_DESKTOP_TROUBLESHOOT.md` 了解 Docker 相关问题的解决方案

### 获取帮助

1. 查看日志文件：
   - 后端日志：`logs/backend.log`
   - 前端日志：浏览器控制台

2. 检查服务状态：
   ```cmd
   tasklist | findstr python
   tasklist | findstr node
   ```

3. 重启服务：
   - 关闭所有命令提示符窗口
   - 重新运行 `start-all-no-docker.bat`

---

**版本**：1.0.0
**发布日期**：2025-02-04
**适用系统**：Windows 7/8/10/11
**无需 Docker**：✅ 是
