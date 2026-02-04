#!/bin/bash

# 项目验证脚本

echo "=================================="
echo "  项目完整性验证"
echo "=================================="
echo ""

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 检查结果
PASS=0
FAIL=0

check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1"
        ((PASS++))
        return 0
    else
        echo -e "${RED}✗${NC} $1"
        ((FAIL++))
        return 1
    fi
}

echo "1. 检查源代码文件"
echo "-------------------"

check_file "src/app/page.tsx"
check_file "src/app/template/page.tsx"
check_file "src/app/api/ocr/route.ts"
check_file "src/app/api/excel/route.ts"
check_file "src/app/layout.tsx"
check_file "src/lib/utils.ts"

echo ""
echo "2. 检查配置文件"
echo "-------------------"

check_file "package.json"
check_file "tsconfig.json"
check_file "next.config.ts"
check_file "postcss.config.mjs"
check_file ".coze"

echo ""
echo "3. 检查部署文件"
echo "-------------------"

check_file "Dockerfile"
check_file "docker-compose.yml"
check_file ".dockerignore"
check_file "check-deploy.sh"
check_file "start.sh"

echo ""
echo "4. 检查文档文件"
echo "-------------------"

check_file "README.md"
check_file "DEPLOY.md"
check_file "FILES.txt"

echo ""
echo "=================================="
echo "  验证结果"
echo "=================================="
echo -e "${GREEN}通过: $PASS${NC}"
echo -e "${RED}缺失: $FAIL${NC}"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}✓ 所有文件完整，项目可以部署！${NC}"
    echo ""
    echo "下一步："
    echo "  1. 运行环境检查: ./check-deploy.sh"
    echo "  2. 查看部署指南: cat DEPLOY.md"
    echo "  3. 快速启动: ./start.sh"
    exit 0
else
    echo -e "${RED}✗ 有 $FAIL 个文件缺失${NC}"
    exit 1
fi
