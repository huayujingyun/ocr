# 构建阶段
FROM node:20-alpine AS builder

# 设置工作目录
WORKDIR /app

# 复制package文件
COPY package.json pnpm-lock.yaml* ./

# 安装pnpm
RUN npm install -g pnpm@latest

# 安装依赖
RUN pnpm install --frozen-lockfile

# 复制源代码
COPY . .

# 设置构建参数
ARG PADDLEOCR_API_URL=http://localhost:8001
ENV NEXT_PUBLIC_PADDLEOCR_API_URL=${PADDLEOCR_API_URL}

# 构建应用
RUN pnpm run build

# 运行阶段
FROM node:20-alpine

# 设置工作目录
WORKDIR /app

# 安装pnpm
RUN npm install -g pnpm@latest

# 复制package文件
COPY package.json pnpm-lock.yaml* ./

# 安装生产依赖
RUN pnpm install --prod --frozen-lockfile

# 从构建阶段复制构建结果
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.js ./

# 暴露端口
EXPOSE 5000

# 启动应用
CMD ["pnpm", "start"]
