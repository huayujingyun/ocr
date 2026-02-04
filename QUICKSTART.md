# 🚀 快速部署指南

## 方式一：使用启动脚本（最简单）

```bash
# 1. 验证项目完整性
./verify-project.sh

# 2. 检查部署环境
./check-deploy.sh

# 3. 快速启动
./start.sh
```

服务将在 http://localhost:5000 启动

---

## 方式二：手动部署

### 1. 环境检查

```bash
# 检查 Node.js 版本（需要 24.x 或更高）
node --version

# 检查是否安装 pnpm
pnpm --version

# 如果未安装 pnpm
npm install -g pnpm
```

### 2. 安装依赖

```bash
pnpm install
```

### 3. 构建项目

```bash
pnpm build
```

### 4. 启动服务

```bash
# 开发模式（支持热更新）
pnpm dev

# 生产模式
pnpm start
```

访问 http://localhost:5000

---

## 方式三：Docker 部署

### 1. 构建镜像

```bash
docker build -t card-ocr-app .
```

### 2. 运行容器

```bash
docker run -p 5000:5000 card-ocr-app
```

### 3. 使用 Docker Compose（推荐）

```bash
docker-compose up -d
```

---

## 使用流程

### 第一步：设置识别模板（首次使用）

1. 访问 http://localhost:5000/template
2. 上传一张标准卡片图片
3. 框选卡号区域
   - 选择识别模式（OCR 或条码）
   - 调整框选位置
4. 框选密码区域（如有）
   - 选择识别模式
   - 调整框选位置
5. 点击"保存模板"

### 第二步：批量识别卡片

1. 访问 http://localhost:5000
2. 点击"上传图片"，选择多张卡片图片
3. 等待图片上传和裁剪
4. 点击"开始识别"
5. 等待识别完成（模板模式下 0.5-2 秒/张）

### 第三步：编辑和导出

1. 查看识别结果
2. 失败的卡片会标红，点击输入框可手动编辑
3. 点击"导出Excel"下载完整数据文件

---

## 常用命令

```bash
# 开发模式
pnpm dev

# 构建项目
pnpm build

# 生产模式
pnpm start

# 类型检查
npx tsc --noEmit

# 项目验证
./verify-project.sh

# 环境检查
./check-deploy.sh

# 快速启动
./start.sh

# Docker 构建
docker build -t card-ocr-app .

# Docker 运行
docker run -p 5000:5000 card-ocr-app

# Docker Compose
docker-compose up -d
```

---

## 故障排查

### 1. 端口被占用

```bash
# 查看端口占用
lsof -i :5000

# 或使用其他端口
PORT=3000 pnpm start
```

### 2. 依赖安装失败

```bash
# 清理缓存后重新安装
rm -rf node_modules pnpm-lock.yaml
pnpm install
```

### 3. 构建失败

```bash
# 检查 TypeScript 错误
npx tsc --noEmit

# 清理构建文件
rm -rf .next

# 重新构建
pnpm build
```

### 4. Docker 构建失败

```bash
# 清理 Docker 缓存
docker system prune -a

# 重新构建
docker build --no-cache -t card-ocr-app .
```

---

## 文件说明

- `README.md` - 项目说明和完整文档
- `DEPLOY.md` - 详细部署指南
- `QUICKSTART.md` - 本文件，快速部署指南
- `FILES.txt` - 项目文件清单
- `verify-project.sh` - 项目完整性验证
- `check-deploy.sh` - 部署环境检查
- `start.sh` - 快速启动脚本
- `Dockerfile` - Docker 配置
- `docker-compose.yml` - Docker Compose 配置

---

## 技术支持

- 查看完整文档：[README.md](README.md)
- 查看部署指南：[DEPLOY.md](DEPLOY.md)
- 查看文件清单：[FILES.txt](FILES.txt)

---

**祝使用愉快！** 🎉
