#!/bin/bash

# 部署检查脚本
# 用于验证部署环境是否满足要求

echo "=================================="
echo "  购物卡/加油卡 OCR 识别系统"
echo "  部署环境检查脚本"
echo "=================================="
echo ""

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查结果统计
PASS=0
FAIL=0
WARN=0

# 检查函数
check_command() {
    if command -v $1 &> /dev/null; then
        echo -e "${GREEN}✓${NC} $1 已安装: $(command -v $1)"
        ((PASS++))
        return 0
    else
        echo -e "${RED}✗${NC} $1 未安装"
        ((FAIL++))
        return 1
    fi
}

check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} 文件存在: $1"
        ((PASS++))
        return 0
    else
        echo -e "${RED}✗${NC} 文件缺失: $1"
        ((FAIL++))
        return 1
    fi
}

check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} 目录存在: $1"
        ((PASS++))
        return 0
    else
        echo -e "${RED}✗${NC} 目录缺失: $1"
        ((FAIL++))
        return 1
    fi
}

check_version() {
    local cmd=$1
    local min_version=$2
    local current_version=$($cmd --version 2>&1 | grep -oE '[0-9]+\.[0-9]+' | head -1)

    if [ -z "$current_version" ]; then
        echo -e "${YELLOW}⚠${NC} 无法获取 $cmd 版本"
        ((WARN++))
        return 1
    fi

    if [ "$(printf '%s\n' "$min_version" "$current_version" | sort -V | head -1)" = "$min_version" ]; then
        echo -e "${GREEN}✓${NC} $cmd 版本: $current_version (要求: >= $min_version)"
        ((PASS++))
        return 0
    else
        echo -e "${RED}✗${NC} $cmd 版本过低: $current_version (要求: >= $min_version)"
        ((FAIL++))
        return 1
    fi
}

check_port() {
    local port=$1
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo -e "${YELLOW}⚠${NC} 端口 $port 已被占用"
        ((WARN++))
        return 1
    else
        echo -e "${GREEN}✓${NC} 端口 $port 可用"
        ((PASS++))
        return 0
    fi
}

# 开始检查
echo "1. 检查系统环境"
echo "-------------------"

check_command "node"
check_version "node" "24"
check_command "npm"

# 检查 pnpm
if check_command "pnpm"; then
    echo ""
    echo "2. 检查包管理器"
    echo "-------------------"
else
    echo ""
    echo -e "${YELLOW}⚠${NC} pnpm 未安装，正在尝试安装..."
    npm install -g pnpm
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} pnpm 安装成功"
        ((PASS++))
    else
        echo -e "${RED}✗${NC} pnpm 安装失败"
        ((FAIL++))
    fi
fi

echo ""
echo "3. 检查项目文件"
echo "-------------------"

check_file "package.json"
check_file "tsconfig.json"
check_file "next.config.mjs"
check_file "tailwind.config.ts"
check_file ".coze"

check_dir "src"
check_dir "src/app"
check_dir "src/lib"

echo ""
echo "4. 检查核心文件"
echo "-------------------"

check_file "src/app/page.tsx"
check_file "src/app/template/page.tsx"
check_file "src/app/api/ocr/route.ts"
check_file "src/app/api/excel/route.ts"
check_file "src/lib/utils.ts"

echo ""
echo "5. 检查端口"
echo "-------------------"

check_port 5000

echo ""
echo "6. 检查依赖"
echo "-------------------"

if [ -d "node_modules" ]; then
    echo -e "${GREEN}✓${NC} node_modules 已存在"
    ((PASS++))
else
    echo -e "${YELLOW}⚠${NC} node_modules 不存在，需要运行 pnpm install"
    ((WARN++))
fi

echo ""
echo "=================================="
echo "  检查结果汇总"
echo "=================================="
echo -e "${GREEN}通过: $PASS${NC}"
echo -e "${YELLOW}警告: $WARN${NC}"
echo -e "${RED}失败: $FAIL${NC}"
echo ""

if [ $FAIL -eq 0 ]; then
    if [ $WARN -eq 0 ]; then
        echo -e "${GREEN}✓ 所有检查通过，可以开始部署！${NC}"
        echo ""
        echo "部署命令："
        echo "  1. 安装依赖: pnpm install"
        echo "  2. 构建项目: pnpm build"
        echo "  3. 启动服务: pnpm start"
        exit 0
    else
        echo -e "${YELLOW}⚠ 有 $WARN 个警告，请确认后继续部署${NC}"
        exit 0
    fi
else
    echo -e "${RED}✗ 有 $FAIL 项检查失败，请修复后重试${NC}"
    exit 1
fi
