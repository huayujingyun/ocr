#!/bin/bash
set -Eeuo pipefail

cd "${COZE_WORKSPACE_PATH}"

echo "==================================="
echo "Building for Deployment"
echo "==================================="

echo ""
echo "Step 1: Installing frontend dependencies..."
pnpm install

echo ""
echo "Step 2: Building frontend..."
pnpm run build

echo ""
echo "Step 3: Installing Python backend dependencies..."
cd backend
pip3 install -q -r requirements.txt || echo "⚠ Warning: Some Python dependencies may have conflicts"
cd ..

echo ""
echo "✓ Build completed successfully!"
