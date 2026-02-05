#!/bin/bash
set -Eeuo pipefail

cd "${COZE_WORKSPACE_PATH}"

# 配置端口
FRONTEND_PORT=${DEPLOY_RUN_PORT:-5000}
BACKEND_PORT=8001

echo "==================================="
echo "Starting Deployment Services"
echo "==================================="

# 清理端口函数
kill_port_if_listening() {
    local port=$1
    local pids
    pids=$(ss -H -lntp 2>/dev/null | awk -v port="${port}" '$4 ~ ":"port"$"' | grep -o 'pid=[0-9]*' | cut -d= -f2 | paste -sd' ' - || true)
    if [[ -z "${pids}" ]]; then
      echo "Port ${port} is free."
      return
    fi
    echo "Port ${port} in use by PIDs: ${pids} (SIGKILL)"
    echo "${pids}" | xargs -I {} kill -9 {} 2>/dev/null || true
    sleep 1
}

# 启动Python后端服务
start_backend() {
    echo "==================================="
    echo "Starting Python backend on port ${BACKEND_PORT}..."
    echo "==================================="

    # 检查Python是否可用
    if ! command -v python3 &> /dev/null; then
        echo "❌ Error: python3 not found"
        exit 1
    fi

    # 设置环境变量
    export PADDLE_PDX_DISABLE_MODEL_SOURCE_CHECK=True

    # 启动后端服务（后台运行）
    cd backend
    nohup python3 main.py > /app/work/logs/bypass/paddleocr-backend.log 2>&1 &
    BACKEND_PID=$!
    cd ..

    echo "✓ Backend started with PID: ${BACKEND_PID}"
    echo "✓ Backend logs: /app/work/logs/bypass/paddleocr-backend.log"

    # 等待后端启动
    echo "Waiting for backend to start..."
    for i in {1..10}; do
        if curl -s http://localhost:${BACKEND_PORT}/health > /dev/null 2>&1; then
            echo "✓ Backend is healthy and ready"
            break
        fi
        if [ $i -eq 10 ]; then
            echo "⚠ Backend may not be ready. Check logs."
        fi
        sleep 2
    done
}

# 启动Next.js前端服务
start_frontend() {
    echo "==================================="
    echo "Starting Next.js frontend on port ${FRONTEND_PORT}..."
    echo "==================================="

    cd "${COZE_WORKSPACE_PATH}"
    pnpm run start --port ${FRONTEND_PORT}
}

# 主流程
echo "Cleaning up ports..."
kill_port_if_listening ${FRONTEND_PORT}
kill_port_if_listening ${BACKEND_PORT}

echo ""
start_backend

echo ""
start_frontend
