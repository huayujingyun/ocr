# 购物卡/加油卡 OCR 识别系统

基于 Next.js 的智能卡片信息识别系统，支持批量上传、模板识别、条码识别和 OCR 混合模式。

## ✨ 主要功能

- 📸 **批量上传**: 支持一次上传多张卡片图片
- 🎯 **模板识别**: 框选识别区域，快速准确
- 🔍 **混合识别**: 支持 OCR 和条码识别混合模式
- ✏️ **手动编辑**: 识别结果可编辑，失败项支持手动填写
- 📊 **Excel 导出**: 导出包含序号的完整数据
- 🚀 **高性能**: 模板模式下识别速度 0.5-2 秒

## 🚀 快速开始

### 方式一：直接运行（推荐用于开发）

```bash
# 1. 检查环境
chmod +x check-deploy.sh
./check-deploy.sh

# 2. 安装依赖
pnpm install

# 3. 构建项目
pnpm build

# 4. 启动服务
pnpm start

# 或使用快速启动脚本
chmod +x start.sh
./start.sh
```

访问 http://localhost:5000

### 方式二：Docker 部署（推荐用于生产）

```bash
# 1. 构建镜像
docker build -t card-ocr-app .

# 2. 运行容器
docker run -p 5000:5000 card-ocr-app

# 或使用 docker-compose
docker-compose up -d
```

### 方式三：PM2 部署（推荐用于服务器）

```bash
# 1. 安装依赖
pnpm install

# 2. 构建项目
pnpm build

# 3. 使用 PM2 启动
pm2 start "pnpm start" --name card-ocr

# 4. 设置开机自启
pm2 startup
pm2 save
```

## 📖 使用指南

### 1. 设置识别模板（首次使用）

1. 访问 http://localhost:5000/template
2. 上传一张标准的卡片图片
3. 框选卡号区域，选择识别模式（OCR 或条码）
4. 框选密码区域（如有），选择识别模式
5. 保存模板

### 2. 批量识别卡片

1. 访问主页 http://localhost:5000
2. 点击"上传图片"，批量选择卡片图片
3. 点击"开始识别"，系统自动识别
4. 查看识别结果，失败的卡片会标红
5. 点击输入框可编辑识别结果
6. 点击"导出Excel"下载结果文件

### 3. 识别模式选择

- **OCR 模式**: 适用于文字类卡片（如超市卡、充值卡）
- **条码模式**: 适用于有条码/二维码的卡片
- **混合模式**: 为不同区域选择不同识别模式

## 🛠️ 技术栈

- **框架**: Next.js 16 (App Router)
- **语言**: TypeScript 5
- **样式**: Tailwind CSS 4
- **条码识别**: @zxing/library
- **Excel 导出**: xlsx
- **OCR 识别**: 大语言模型集成

## 📁 项目结构

```
.
├── src/
│   ├── app/
│   │   ├── page.tsx              # 主页面
│   │   ├── template/
│   │   │   └── page.tsx          # 模板设置
│   │   ├── api/
│   │   │   ├── ocr/route.ts      # OCR API
│   │   │   └── excel/route.ts    # Excel API
│   │   └── layout.tsx            # 布局
│   └── lib/
│       └── utils.ts              # 工具函数
├── package.json                  # 依赖配置
├── Dockerfile                    # Docker 配置
├── docker-compose.yml            # Docker Compose 配置
├── check-deploy.sh               # 部署检查脚本
├── start.sh                      # 快速启动脚本
├── DEPLOY.md                     # 详细部署指南
└── README.md                     # 本文件
```

## 🔧 配置说明

### 环境变量（可选）

创建 `.env.local` 文件：

```env
PORT=5000              # 服务端口
NODE_ENV=production    # 运行环境
```

### 端口配置

默认端口为 5000，可通过以下方式修改：

1. 环境变量: `PORT=3000 pnpm start`
2. .env.local 文件: `PORT=3000`
3. 修改 package.json 中的 start 脚本

## 📋 系统要求

- **Node.js**: 24.x 或更高版本
- **pnpm**: 包管理器
- **内存**: 至少 512MB
- **磁盘**: 至少 500MB

## 🐛 常见问题

### 1. 识别失败怎么办？

- 检查模板框选是否准确
- 尝试使用不同的识别模式（OCR vs 条码）
- 检查图片清晰度
- 手动编辑识别结果

### 2. 如何调整识别区域？

- 点击首页"清除模板"按钮
- 重新进入模板设置页面
- 重新框选区域

### 3. 端口被占用怎么办？

- 修改 `.env.local` 中的 `PORT` 配置
- 或使用命令：`PORT=3000 pnpm start`

### 4. 如何查看详细日志？

- 打开浏览器控制台（F12）
- 查看识别过程的详细日志
- 检查网络请求和错误信息

## 🌐 生产环境部署

详细的部署说明请参考 [DEPLOY.md](DEPLOY.md)，包括：

- Docker 部署
- PM2 部署
- Nginx 反向代理
- 性能优化建议
- 维护和监控

## 📝 文档

- **部署指南**: [DEPLOY.md](DEPLOY.md)
- **文件清单**: [FILES.txt](FILES.txt)
- **环境检查**: `./check-deploy.sh`

## 🤝 开发

### 代码结构优化

代码已经过全面优化：

- ✅ 提取工具函数库，减少冗余代码
- ✅ 统一日志管理，便于调试
- ✅ 类型安全，通过 TypeScript 检查
- ✅ 代码行数减少约 30%
- ✅ 消除所有类型错误

### 本地开发

```bash
# 安装依赖
pnpm install

# 开发模式（热更新）
pnpm dev

# 类型检查
npx tsc --noEmit

# 构建生产版本
pnpm build
```

## 📄 许可证

本项目为内部使用项目，请遵守相关使用规范。

## 📧 技术支持

如遇问题，请检查：

1. Node.js 版本是否符合要求
2. 依赖是否正确安装
3. 端口是否被占用
4. 浏览器控制台错误信息
5. 网络连接是否正常

---

**版本**: 1.0.0
**更新日期**: 2025-01-15
**状态**: 已优化，可直接部署
