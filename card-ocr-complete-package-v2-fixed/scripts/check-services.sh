#!/bin/bash

echo "==================================="
echo "服务健康检查"
echo "==================================="

# 检查前端服务
echo "检查前端服务 (端口5000)..."
if curl -s -o /dev/null -w "%{http_code}" http://localhost:5000 | grep -q "200\|307"; then
    echo "✓ 前端服务正常"
else
    echo "✗ 前端服务异常"
fi

# 检查后端服务
echo "检查后端服务 (端口8001)..."
BACKEND_STATUS=$(curl -s http://localhost:8001/health 2>/dev/null || echo '{"status":"error"}')
if echo "$BACKEND_STATUS" | grep -q '"status":"healthy"'; then
    echo "✓ 后端服务正常"
    OCR_READY=$(echo "$BACKEND_STATUS" | grep -o '"ocr_ready":[^,]*' | cut -d':' -f2)
    echo "  OCR引擎状态: $OCR_READY"
else
    echo "✗ 后端服务异常"
    echo "  详情: $BACKEND_STATUS"
fi

echo "==================================="
echo "检查完成"
echo "==================================="
