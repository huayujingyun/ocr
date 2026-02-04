@echo off
chcp 65001 >nul
echo ========================================
echo 购物卡OCR系统 - Win11专用安装脚本
echo ========================================
echo.

echo 正在检查Docker是否运行...
docker version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker未运行，请先启动Docker Desktop
    pause
    exit /b 1
)
echo ✓ Docker运行正常
echo.

echo 正在构建后端服务（使用清华镜像源）...
docker-compose -f docker-compose-win11.yml build paddleocr-service
if errorlevel 1 (
    echo.
    echo ❌ 后端服务构建失败！
    echo.
    echo 可能的原因：
    echo 1. 网络连接问题
    echo 2. 清华镜像源暂时不可用
    echo 3. Docker资源不足
    echo.
    echo 建议：
    echo 1. 运行 test-docker-network.bat 检查网络
    echo 2. 或使用非Docker版本（推荐，100%%成功）
    pause
    exit /b 1
)
echo ✓ 后端服务构建成功
echo.

echo 正在构建前端服务...
docker-compose -f docker-compose-win11.yml build frontend
if errorlevel 1 (
    echo.
    echo ❌ 前端服务构建失败！
    pause
    exit /b 1
)
echo ✓ 前端服务构建成功
echo.

echo ========================================
echo ✓ 所有服务构建完成！
echo ========================================
echo.
echo 下一步：
echo 1. 运行 start-win11.bat 启动服务
echo 2. 访问 http://localhost:5000
echo.
pause
