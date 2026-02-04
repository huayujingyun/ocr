#!/bin/bash

# 快速启动脚本

set -e

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=================================="
echo "  购物卡/加油卡 OCR 识别系统"
echo "  快速启动脚本"
echo "==================================${NC}"
echo ""

# 检查 node_modules
if [ ! -d "node_modules" ]; then
    echo -e "${BLUE}安装依赖...${NC}"
    pnpm install
fi

# 检查是否需要构建
if [ ! -d ".next" ]; then
    echo -e "${BLUE}构建项目...${NC}"
    pnpm build
fi

# 启动服务
echo ""
echo -e "${GREEN}启动服务...${NC}"
echo "服务地址: http://localhost:5000"
echo ""

pnpm start
