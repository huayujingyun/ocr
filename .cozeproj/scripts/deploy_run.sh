#!/bin/bash
set -Eeuo pipefail

cd "${COZE_WORKSPACE_PATH}"

BACKEND_PORT=8001

# 启动后端服务（后台运行）
echo "Starting Python backend on port ${BACKEND_PORT}..."
cd backend
nohup python3 main.py > /tmp/paddleocr-backend.log 2>&1 &
BACKEND_PID=$!
cd ..
echo "Backend started with PID: ${BACKEND_PID}"

# 等待后端启动
sleep 3

# 启动前端服务
echo "Starting HTTP service on port ${DEPLOY_RUN_PORT} for deploy..."
cd "${COZE_WORKSPACE_PATH}"
pnpm run start --port ${DEPLOY_RUN_PORT}
