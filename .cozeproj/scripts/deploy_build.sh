#!/bin/bash
set -Eeuo pipefail

cd "${COZE_WORKSPACE_PATH}"

echo "Installing frontend dependencies..."
pnpm install

echo "Installing backend dependencies..."
pip3 install -r backend/requirements.txt

echo "Building the project..."
pnpm run build

echo "Build completed successfully!"
