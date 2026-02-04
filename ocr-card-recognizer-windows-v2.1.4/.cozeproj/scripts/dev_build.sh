#!/bin/bash
set -Eeuo pipefail

cd "${COZE_WORKSPACE_PATH}"

echo "==================================="
echo "Installing Node.js dependencies..."
echo "==================================="

pnpm install

echo ""
echo "==================================="
echo "Installing Python dependencies..."
echo "==================================="

# 检查Python是否可用
if ! command -v python3 &> /dev/null; then
    echo "Warning: python3 not found. Python backend will not be available."
else
    # 安装Python依赖
    if [ -f "backend/requirements.txt" ]; then
        pip3 install -r backend/requirements.txt || echo "Warning: Failed to install Python dependencies"
    fi
fi

echo ""
echo "==================================="
echo "Build completed successfully!"
echo "==================================="
