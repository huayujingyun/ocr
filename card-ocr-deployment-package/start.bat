@echo off
chcp 65001 >nul
title 购物卡OCR系统 - 启动服务
color 0B

echo.
echo ==========================================
echo  购物卡/加油卡OCR识别系统 - 启动服务
echo ==========================================
echo.

echo 正在启动服务...
echo.

REM 启动Docker Compose服务
docker-compose up -d

if %errorLevel% neq 0 (
    echo.
    echo [错误] 服务启动失败！
    echo.
    echo 可能的原因：
    echo 1. Docker Desktop未启动
    echo 2. 端口被占用（5000或8001）
    echo 3. 配置文件错误
    echo.
    echo 解决方案：
    echo 1. 确保Docker Desktop正在运行
    echo 2. 检查端口是否被占用：netstat -ano | findstr "5000 8001"
    echo 3. 查看 docker-compose.yml 配置
    echo.
    pause
    exit /b 1
)

echo.
echo [✓] 服务启动成功
echo.
echo 等待服务就绪...
timeout /t 5 /nobreak >nul

echo.
echo 正在检查服务状态...
echo.

REM 检查后端服务
echo 检查后端服务 (PaddleOCR)...
curl -s http://localhost:8001/health >nul 2>&1
if %errorLevel% equ 0 (
    echo [✓] 后端服务运行正常
    set BACKEND_STATUS=正常
) else (
    echo [!] 后端服务可能还在启动中...
    set BACKEND_STATUS=启动中
)

REM 检查前端服务
echo 检查前端服务 (Next.js)...
curl -s http://localhost:5000 >nul 2>&1
if %errorLevel% equ 0 (
    echo [✓] 前端服务运行正常
    set FRONTEND_STATUS=正常
) else (
    echo [!] 前端服务可能还在启动中...
    set FRONTEND_STATUS=启动中
)

echo.
echo ==========================================
echo  服务状态
echo ==========================================
echo.
echo 后端服务 (PaddleOCR)：http://localhost:8001  [%BACKEND_STATUS%]
echo 前端服务 (Next.js)：  http://localhost:5000  [%FRONTEND_STATUS%]
echo API文档地址：       http://localhost:8001/docs
echo.
echo ==========================================
echo.

if "%BACKEND_STATUS%"=="正常" (
    if "%FRONTEND_STATUS%"=="正常" (
        echo [✓] 所有服务已就绪，可以开始使用了！
        echo.
        echo 点击这里打开应用：http://localhost:5000
        echo.
        start http://localhost:5000
    ) else (
        echo [!] 前端服务还在启动中，请稍等片刻...
        echo.
        echo 如果长时间无法访问，请运行以下命令查看日志：
        echo   docker-compose logs frontend
    )
) else (
    echo [!] 服务可能还在启动中，请稍等片刻...
    echo.
    echo 如果长时间无法访问，请运行以下命令查看日志：
    echo   docker-compose logs
)

echo.
echo 其他命令：
echo   - 停止服务：双击 stop.bat
echo   - 查看状态：双击 status.bat
echo   - 查看日志：docker-compose logs -f
echo.

pause
