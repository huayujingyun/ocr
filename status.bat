@echo off
chcp 65001 >nul
title 购物卡OCR系统 - 服务状态
color 0E

echo.
echo ==========================================
echo  购物卡/加油卡OCR识别系统 - 服务状态
echo ==========================================
echo.

echo [1/4] 检查Docker状态...
docker --version >nul 2>&1
if %errorLevel% neq 0 (
    echo [错误] Docker未安装或未启动
    echo.
    pause
    exit /b 1
)
echo [✓] Docker运行正常

echo.
echo [2/4] 检查容器状态...
echo.
docker-compose ps

echo.
echo [3/4] 检查服务健康状态...
echo.

REM 检查后端服务
echo 检查后端服务 (PaddleOCR)...
curl -s http://localhost:8001/health >nul 2>&1
if %errorLevel% equ 0 (
    set /a BACKEND_CODE=1
    set BACKEND_MSG=运行正常
) else (
    set /a BACKEND_CODE=0
    set BACKEND_MSG=未运行或异常
)
if %BACKEND_CODE% equ 1 (
    echo [✓] 后端服务：http://localhost:8001  [正常运行]
) else (
    echo [✗] 后端服务：http://localhost:8001  [%BACKEND_MSG%]
)

REM 检查前端服务
echo 检查前端服务 (Next.js)...
curl -s http://localhost:5000 >nul 2>&1
if %errorLevel% equ 0 (
    set /a FRONTEND_CODE=1
    set FRONTEND_MSG=运行正常
) else (
    set /a FRONTEND_CODE=0
    set FRONTEND_MSG=未运行或异常
)
if %FRONTEND_CODE% equ 1 (
    echo [✓] 前端服务：http://localhost:5000  [正常运行]
) else (
    echo [✗] 前端服务：http://localhost:5000  [%FRONTEND_MSG%]
)

echo.
echo [4/4] 服务汇总...
echo.
echo ==========================================
echo  服务状态汇总
echo ==========================================
echo.
echo 后端服务 (PaddleOCR)：%BACKEND_MSG%
echo 前端服务 (Next.js)：  %FRONTEND_MSG%
echo.
if %BACKEND_CODE% equ 1 (
    if %FRONTEND_CODE% equ 1 (
        echo [✓] 所有服务运行正常
        echo.
        echo 访问地址：
        echo   - 前端界面：http://localhost:5000
        echo   - 后端API：http://localhost:8001
        echo   - API文档：http://localhost:8001/docs
    ) else (
        echo [!] 部分服务未运行
        echo.
        echo 请运行 start.bat 启动服务
    )
) else (
    echo [!] 服务未运行
    echo.
    echo 请运行 start.bat 启动服务
)

echo.
echo ==========================================
echo.

REM 询问是否查看详细日志
set /p LOGS_CHOICE=是否查看详细日志？(Y/N):
if /i "%LOGS_CHOICE%"=="Y" (
    echo.
    echo ==========================================
    echo  详细日志（按Ctrl+C退出）
    echo ==========================================
    echo.
    docker-compose logs -f
)

pause
