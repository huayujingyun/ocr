# 购物卡/加油卡 OCR 识别系统 - 部署指南

## 📋 项目概述

这是一个基于 Next.js 的购物卡/加油卡 OCR 识别系统，支持：
- 批量上传卡片图片
- 模板框选识别（快速、准确）
- 条码识别和 OCR 混合模式
- 识别结果手动编辑和校验
- 导出 Excel 文件

## 🚀 快速部署

### 前置要求

- **Node.js**: 24.x 或更高版本
- **pnpm**: 包管理器
- **系统要求**: Linux/Mac/Windows

### 一、安装依赖

```bash
# 安装 pnpm（如果尚未安装）
npm install -g pnpm

# 安装项目依赖
pnpm install
```

### 二、环境配置

创建 `.env.local` 文件（可选）：

```env
# 应用端口（默认 5000）
PORT=5000

# 日志级别
NODE_ENV=production

# 如果使用数据库或对象存储，配置相应环境变量
# DATABASE_URL=your_database_url
# AWS_ACCESS_KEY_ID=your_access_key
# AWS_SECRET_ACCESS_KEY=your_secret_key
# AWS_REGION=your_region
# AWS_S3_BUCKET=your_bucket_name
```

### 三、构建项目

```bash
# 开发环境构建
pnpm build

# 或使用完整路径
npx next build
```

### 四、启动服务

#### 开发环境
```bash
pnpm dev
```

#### 生产环境
```bash
pnpm start
```

服务将在 `http://localhost:5000` 启动

## 📁 项目结构

```
.
├── src/
│   ├── app/
│   │   ├── page.tsx              # 主页面 - 图片上传和识别
│   │   ├── template/
│   │   │   └── page.tsx          # 模板设置页面
│   │   ├── api/
│   │   │   ├── ocr/
│   │   │   │   └── route.ts      # OCR 识别 API
│   │   │   └── excel/
│   │   │       └── route.ts      # Excel 导出 API
│   │   └── layout.tsx            # 根布局
│   ├── lib/
│   │   └── utils.ts              # 工具函数
│   └── components/                # （可选）可复用组件
├── .coze                          # 部署配置文件
├── .cozeproj/                     # 部署脚本目录
├── package.json                   # 项目依赖
├── tsconfig.json                  # TypeScript 配置
├── tailwind.config.ts             # Tailwind CSS 配置
├── next.config.mjs               # Next.js 配置
└── DEPLOY.md                     # 本文件
```

## 🔧 核心功能说明

### 1. 图片上传和识别 (`src/app/page.tsx`)
- 批量上传卡片图片
- 基于模板框选自动裁剪
- 支持 OCR 和条码识别
- 识别结果实时显示和编辑

### 2. 模板设置 (`src/app/template/page.tsx`)
- 上传标准卡片图片
- 框选卡号和密码区域
- 为每个区域选择识别模式（OCR/条码）
- 保存模板到 sessionStorage

### 3. OCR 识别 API (`src/app/api/ocr/route.ts`)
- 处理裁剪后的图片
- 调用大语言模型进行 OCR 识别
- 支持批量识别
- 超时控制和错误处理

### 4. Excel 导出 API (`src/app/api/excel/route.ts`)
- 导出识别结果到 Excel
- 包含序号、卡号、密码
- 自动生成文件名

### 5. 工具函数 (`src/lib/utils.ts`)
- 统一的日志管理
- 图片预览模态框
- 文件下载
- 超时控制

## 📦 主要依赖

```json
{
  "next": "16.0.10",
  "react": "19.2.1",
  "typescript": "^5",
  "tailwindcss": "^4",
  "@zxing/library": "^0.21.3",
  "xlsx": "^0.18.5",
  "coze-coding-dev-sdk": "0.5.0"
}
```

## 🎯 使用流程

1. **设置模板**（首次使用）
   - 访问 `/template`
   - 上传标准卡片图片
   - 框选卡号和密码区域
   - 选择识别模式（OCR 或条码）
   - 保存模板

2. **上传图片**
   - 访问首页
   - 批量上传卡片图片
   - 系统自动裁剪识别区域

3. **开始识别**
   - 点击"开始识别"按钮
   - 系统逐张识别
   - 实时显示识别结果

4. **校验和编辑**
   - 查看识别结果
   - 点击编辑修正错误
   - 失败的卡片用红色标记

5. **导出数据**
   - 点击"导出Excel"
   - 下载包含所有结果的Excel文件

## 🛠️ 常见问题

### 1. 识别失败怎么办？
- 检查模板框选是否准确
- 尝试使用不同的识别模式（OCR vs 条码）
- 检查图片清晰度
- 手动编辑识别结果

### 2. 如何调整识别区域？
- 删除当前模板
- 重新进入模板设置页面
- 重新框选区域

### 3. 端口冲突怎么办？
- 修改 `.env.local` 中的 `PORT` 配置
- 或使用命令：`PORT=3000 pnpm dev`

### 4. 如何查看详细日志？
- 打开浏览器控制台（F12）
- 查看识别过程的详细日志
- 检查网络请求和错误信息

## 🌐 生产环境部署

### Docker 部署（推荐）

```dockerfile
FROM node:24-alpine

WORKDIR /app

# 复制依赖文件
COPY package.json pnpm-lock.yaml ./

# 安装 pnpm
RUN npm install -g pnpm

# 安装依赖
RUN pnpm install --frozen-lockfile

# 复制项目文件
COPY . .

# 构建项目
RUN pnpm build

# 暴露端口
EXPOSE 5000

# 启动服务
CMD ["pnpm", "start"]
```

构建和运行：
```bash
docker build -t card-ocr-app .
docker run -p 5000:5000 card-ocr-app
```

### PM2 部署

```bash
# 安装 PM2
npm install -g pm2

# 启动应用
pm2 start "pnpm start" --name card-ocr

# 设置开机自启
pm2 startup
pm2 save
```

### Nginx 反向代理

```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

## 🔍 性能优化建议

1. **启用缓存**: 配置 Next.js 静态资源缓存
2. **CDN 加速**: 使用 CDN 分发静态资源
3. **图片优化**: 使用 WebP 格式，压缩图片大小
4. **并发控制**: 限制同时识别的图片数量
5. **负载均衡**: 使用多实例部署

## 📝 维护和监控

### 日志查看
```bash
# PM2 日志
pm2 logs card-ocr

# Docker 日志
docker logs -f container-id
```

### 性能监控
- 使用 Next.js 内置的 Analytics
- 集成 Sentry 错误追踪
- 配置 Uptime 监控

### 备份
- 定期备份模板配置
- 备份识别结果数据
- 备份环境变量配置

## 🤝 技术支持

如遇问题，请检查：
1. Node.js 版本是否符合要求
2. 依赖是否正确安装
3. 端口是否被占用
4. 浏览器控制台错误信息
5. 网络连接是否正常

## 📄 许可证

本项目为内部使用项目，请遵守相关使用规范。

---

**版本**: 1.0.0
**更新日期**: 2025-01-15
