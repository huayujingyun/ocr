#!/bin/bash
set -Eeuo pipefail

cd "${COZE_WORKSPACE_PATH}"

echo "Installing frontend dependencies..."
pnpm install

echo "Installing backend dependencies..."
# 先安装基础依赖（排除 paddleocr）
pip3 install paddlepaddle==2.6.2
pip3 install Pillow numpy shapely scikit-image imgaug pyclipper lmdb tqdm visualdl rapidfuzz cython lxml premailer openpyxl attrdict pyyaml python-docx beautifulsoup4 fonttools fire langchain pydantic pydantic-settings python-dotenv

# 安装 OpenCV（使用固定版本）
pip3 install opencv-python==4.6.0.66 opencv-python-headless==4.6.0.66

# 安装 paddleocr（使用 --no-deps 避免安装 PyMuPDF 和 pdf2docx）
pip3 install paddleocr==2.7.0.3 --no-deps

echo "Building the project..."
pnpm run build

echo "Build completed successfully!"
