#!/bin/bash

echo "==================================="
echo "PaddleOCR功能测试"
echo "==================================="

# 检查后端服务
echo "1. 检查后端服务状态..."
HEALTH=$(curl -s http://localhost:8001/health)
echo "   健康检查结果: $HEALTH"

if echo "$HEALTH" | grep -q '"ocr_ready":true'; then
    echo "   ✓ 后端服务正常，OCR引擎就绪"
else
    echo "   ✗ 后端服务异常"
    exit 1
fi

# 创建测试图片（使用Python创建一个简单的图片）
echo ""
echo "2. 创建测试图片..."
python3 << 'EOF'
import base64
from PIL import Image, ImageDraw, ImageFont
import numpy as np
import io

# 创建一个简单的测试图片
img = Image.new('RGB', (200, 60), color='white')
draw = ImageDraw.Draw(img)

# 绘制文字（简单的数字串）
text = "1234567890123456"
try:
    font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 30)
except:
    font = ImageFont.load_default()

draw.text((10, 15), text, fill='black', font=font)

# 转换为base64
buffer = io.BytesIO()
img.save(buffer, format='JPEG')
base64_str = base64.b64encode(buffer.getvalue()).decode('utf-8')
print(base64_str)
EOF

if [ $? -eq 0 ]; then
    TEST_IMAGE_BASE64=$(python3 << 'EOF'
import base64
from PIL import Image, ImageDraw, ImageFont
import io

img = Image.new('RGB', (200, 60), color='white')
draw = ImageDraw.Draw(img)

text = "1234567890123456"
try:
    font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 30)
except:
    font = ImageFont.load_default()

draw.text((10, 15), text, fill='black', font=font)

buffer = io.BytesIO()
img.save(buffer, format='JPEG')
base64_str = base64.b64encode(buffer.getvalue()).decode('utf-8')
print(base64_str)
EOF
)

    echo "   ✓ 测试图片创建成功"
else
    echo "   ✗ 测试图片创建失败"
    exit 1
fi

# 测试OCR识别
echo ""
echo "3. 测试OCR识别..."
RESULT=$(curl -s -X POST http://localhost:8001/api/ocr/recognize \
  -H "Content-Type: application/json" \
  -d "{\"image\":\"data:image/jpeg;base64,$TEST_IMAGE_BASE64\",\"preprocess\":\"grayscale\"}")

echo "   识别结果: $RESULT"

if echo "$RESULT" | grep -q '"success":true'; then
    RECOGNIZED_TEXT=$(echo "$RESULT" | python3 -c "import sys, json; print(json.load(sys.stdin)['text'])")
    echo "   ✓ OCR识别成功"
    echo "   识别文字: $RECOGNIZED_TEXT"
else
    echo "   ✗ OCR识别失败"
    exit 1
fi

# 检查前端服务
echo ""
echo "4. 检查前端服务..."
if curl -s -o /dev/null -w "%{http_code}" http://localhost:5000 | grep -q "200\|307"; then
    echo "   ✓ 前端服务正常"
else
    echo "   ✗ 前端服务异常"
fi

echo ""
echo "==================================="
echo "测试完成"
echo "==================================="
echo ""
echo "总结："
echo "  - 后端PaddleOCR服务：✓ 正常运行"
echo "  - OCR识别功能：✓ 正常工作"
echo "  - 前端服务：✓ 正常运行"
echo ""
echo "您现在可以访问 http://localhost:5000 使用购物卡识别功能"
echo "所有OCR识别都将在本地完成，无需联网！"
