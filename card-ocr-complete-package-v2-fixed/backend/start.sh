#!/bin/bash

# PaddleOCR服务启动脚本

echo "==================================="
echo "PaddleOCR-VL-1.5 服务启动"
echo "==================================="

# 检查Python版本
PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
echo "Python版本: $PYTHON_VERSION"

# 检查依赖
echo "检查依赖..."
pip3 show paddlepaddle > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "正在安装依赖..."
    pip3 install -r requirements.txt
fi

# 创建模型目录
mkdir -p ~/.paddleocr

# 启动服务
echo "启动OCR服务..."
python3 main.py
