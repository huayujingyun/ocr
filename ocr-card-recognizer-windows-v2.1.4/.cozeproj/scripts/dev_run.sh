#!/bin/bash
set -Eeuo pipefail

cd "${COZE_WORKSPACE_PATH}"

# 配置端口
FRONTEND_PORT=5000
BACKEND_PORT=8001

echo "==================================="
echo "Starting services"
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
    echo "${pids}" | xargs -I {} kill -9 {}
    sleep 1
    pids=$(ss -H -lntp 2>/dev/null | awk -v port="${port}" '$4 ~ ":"port"$"' | grep -o 'pid=[0-9]*' | cut -d= -f2 | paste -sd' ' - || true)
    if [[ -n "${pids}" ]]; then
      echo "Warning: port ${port} still busy after SIGKILL, PIDs: ${pids}"
    else
      echo "Port ${port} cleared."
    fi
}

# 安装OpenCV系统依赖
install_opencv_deps() {
    echo "Checking OpenCV system dependencies..."
    if ! ldconfig -p 2>/dev/null | grep -q libGL.so.1; then
        echo "Installing OpenCV dependencies..."
        apt-get update -qq
        apt-get install -y -qq libgl1 libglib2.0-0 libsm6 libxext6 libxrender1 libgthread-2.0-0
        echo "✓ OpenCV dependencies installed"
    else
        echo "✓ OpenCV dependencies already installed"
    fi
}

# 启动Python后端服务
start_backend() {
    echo "==================================="
    echo "Starting Python backend on port ${BACKEND_PORT}..."
    echo "==================================="

    # 检查Python是否可用
    if ! command -v python3 &> /dev/null; then
        echo "Error: python3 not found. Please install Python 3.8+"
        exit 1
    fi

    # 安装OpenCV系统依赖
    install_opencv_deps

    # 检查依赖
    if ! python3 -c "import paddleocr" 2>/dev/null; then
        echo "Warning: PaddleOCR not installed. Running: pip3 install -r backend/requirements.txt"
        pip3 install -r backend/requirements.txt
    fi

    # 启动后端服务（后台运行）
    cd backend
    nohup python3 main.py > /tmp/paddleocr-backend.log 2>&1 &
    BACKEND_PID=$!
    cd ..

    echo "Backend started with PID: ${BACKEND_PID}"
    echo "Backend logs: /tmp/paddleocr-backend.log"

    # 等待后端启动
    echo "Waiting for backend to start..."
    sleep 5

    # 检查后端是否成功启动
    if curl -s http://localhost:${BACKEND_PORT}/health > /dev/null 2>&1; then
        echo "✓ Backend is healthy and ready"
    else
        echo "⚠ Backend may not be ready yet. Check logs: tail -f /tmp/paddleocr-backend.log"
    fi
}

# 启动Next.js前端服务
start_frontend() {
    echo "==================================="
    echo "Starting Next.js frontend on port ${FRONTEND_PORT}..."
    echo "==================================="

    cd "${COZE_WORKSPACE_PATH}"
    pnpm run dev --port ${FRONTEND_PORT}
}

# 主流程
echo "Cleaning up ports..."
kill_port_if_listening ${FRONTEND_PORT}
kill_port_if_listening ${BACKEND_PORT}

echo ""
start_backend

echo ""
start_frontend
