@echo off
chcp 65001 >nul
title 购物卡OCR系统 - 一键安装脚本
color 0A

echo.
echo ==========================================
echo  购物卡/加油卡OCR识别系统 - 一键安装
echo ==========================================
echo.

REM 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [错误] 请以管理员身份运行此脚本！
    echo.
    echo 操作步骤：
    echo 1. 右键点击 install.bat
    echo 2. 选择"以管理员身份运行"
    echo.
    pause
    exit /b 1
)

echo [1/6] 检查系统环境...
echo.

REM 检查Docker
docker --version >nul 2>&1
if %errorLevel% neq 0 (
    echo [错误] 未检测到Docker Desktop！
    echo.
    echo 请先安装Docker Desktop：
    echo https://www.docker.com/products/docker-desktop
    echo.
    pause
    exit /b 1
)
echo [✓] Docker Desktop 已安装
docker --version

REM 检查Git
git --version >nul 2>&1
if %errorLevel% equ 0 (
    echo [✓] Git 已安装
    git --version
) else (
    echo [!] 未检测到Git（可选）
)

echo.
echo [2/6] 创建必要的目录...
if not exist "config" mkdir config
if not exist "logs" mkdir logs
if not exist "data" mkdir data
echo [✓] 目录创建完成

echo.
echo [3/6] 配置环境变量...
if not exist "config\.env" (
    copy "config\.env.example" "config\.env" >nul 2>&1
    echo [✓] 环境变量文件已创建
) else (
    echo [✓] 环境变量文件已存在
)

echo.
echo [4/6] 构建Docker镜像...
echo 这可能需要10-20分钟，请耐心等待...
echo.

docker-compose build --no-cache

if %errorLevel% neq 0 (
    echo.
    echo [错误] Docker镜像构建失败！
    echo.
    echo 可能的原因：
    echo 1. 网络连接问题
    echo 2. Docker未正确启动
    echo 3. 磁盘空间不足
    echo.
    echo 解决方案：
    echo 1. 检查网络连接
    echo 2. 确保Docker Desktop正在运行
    echo 3. 清理磁盘空间后重试
    echo.
    pause
    exit /b 1
)

echo.
echo [✓] Docker镜像构建完成

echo.
echo [5/6] 启动服务...
docker-compose up -d

if %errorLevel} neq 0 (
    echo.
    echo [错误] 服务启动失败！
    echo.
    pause
    exit /b 1
)

echo.
echo [✓] 服务启动成功

echo.
echo [6/6] 等待服务就绪...
timeout /t 10 /nobreak >nul

echo.
echo 正在检查服务状态...
echo.

REM 检查后端服务
curl -s http://localhost:8001/health >nul 2>&1
if %errorLevel% equ 0 (
    echo [✓] 后端服务 (PaddleOCR) 运行正常
) else (
    echo [!] 后端服务可能还在启动中...
)

REM 检查前端服务
curl -s http://localhost:5000 >nul 2>&1
if %errorLevel% equ 0 (
    echo [✓] 前端服务 运行正常
) else (
    echo [!] 前端服务可能还在启动中...
)

echo.
echo ==========================================
echo  安装完成！
echo ==========================================
echo.
echo 服务地址：
echo   - 前端界面：http://localhost:5000
echo   - 后端API：http://localhost:8001
echo   - API文档：http://localhost:8001/docs
echo.
echo 管理命令：
echo   - 启动服务：双击 start.bat
echo   - 停止服务：双击 stop.bat
echo   - 查看状态：双击 status.bat
echo.
echo 常用操作：
echo   - 查看日志：docker-compose logs -f
echo   - 重启服务：docker-compose restart
echo   - 清理数据：docker-compose down -v
echo.
echo 注意事项：
echo   1. 首次启动需要下载PaddleOCR模型（约200MB）
echo   2. 模型会缓存到Docker卷中，后续启动无需重新下载
echo   3. 如遇到问题，请查看 logs/ 目录下的日志文件
echo.
echo ==========================================
echo.

pause
