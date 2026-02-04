#!/bin/bash

echo "====================================="
echo "Windows部署包打包脚本"
echo "====================================="

# 部署包目录
DEPLOY_DIR="deploy/windows"
PACKAGE_NAME="ocr-card-recognizer-windows"
VERSION="v2.0.0"

echo ""
echo "[步骤 1/5] 创建部署目录..."

# 创建必要的目录
mkdir -p "$DEPLOY_DIR/logs"
mkdir -p "$DEPLOY_DIR/data/uploads"
mkdir -p "$DEPLOY_DIR/data/exports"

echo ""
echo "[步骤 2/5] 复制前端文件..."

# 复制前端文件
if [ -d "src" ]; then
    cp -r src "$DEPLOY_DIR/frontend"
fi

if [ -f "package.json" ]; then
    cp package.json "$DEPLOY_DIR/frontend/"
fi

if [ -f "pnpm-lock.yaml" ]; then
    cp pnpm-lock.yaml "$DEPLOY_DIR/frontend/"
fi

if [ -f "next.config.js" ]; then
    cp next.config.js "$DEPLOY_DIR/frontend/"
fi

if [ -f "tsconfig.json" ]; then
    cp tsconfig.json "$DEPLOY_DIR/frontend/"
fi

echo ""
echo "[步骤 3/5] 复制后端文件..."

# 复制后端文件
if [ -d "backend" ]; then
    cp backend/*.py "$DEPLOY_DIR/backend/" 2>/dev/null
    cp backend/requirements.txt "$DEPLOY_DIR/backend/" 2>/dev/null
fi

echo ""
echo "[步骤 4/5] 复制配置文件..."

# 复制配置文件
if [ -f ".env.example" ]; then
    cp .env.example "$DEPLOY_DIR/.env"
fi

# 复制文档
if [ -f "README.md" ]; then
    cp README.md "$DEPLOY_DIR/"
fi

if [ -f "PADDLEOCR_DEPLOY.md" ]; then
    cp PADDLEOCR_DEPLOY.md "$DEPLOY_DIR/"
fi

if [ -f "MIGRATION_GUIDE.md" ]; then
    cp MIGRATION_GUIDE.md "$DEPLOY_DIR/"
fi

echo ""
echo "[步骤 5/5] 创建压缩包..."

# 创建压缩包
cd "$DEPLOY_DIR"
zip -r "../${PACKAGE_NAME}-${VERSION}.zip" . -x "*.git*" "*.DS_Store" "*__pycache__*" "*.pyc" "node_modules/*" ".next/*" "logs/*"
cd ../..

echo ""
echo "====================================="
echo "打包完成！"
echo "====================================="
echo ""
echo "部署包位置：${PACKAGE_NAME}-${VERSION}.zip"
echo "文件大小：$(du -h ${PACKAGE_NAME}-${VERSION}.zip | cut -f1)"
echo ""
echo "使用说明："
echo "1. 将压缩包复制到Windows电脑"
echo "2. 解压到任意目录"
echo "3. 双击 install.bat 开始安装"
echo "4. 双击 start.bat 启动服务"
echo ""
