@echo off
chcp 65001 >nul
title 购物卡OCR系统 - 停止服务
color 0C

echo.
echo ==========================================
echo  购物卡/加油卡OCR识别系统 - 停止服务
echo ==========================================
echo.

echo 正在停止服务...
echo.

REM 停止Docker Compose服务
docker-compose down

if %errorLevel% neq 0 (
    echo.
    echo [错误] 服务停止失败！
    echo.
    pause
    exit /b 1
)

echo.
echo [✓] 服务已停止
echo.

echo 已停止的服务：
echo   - 前端服务 (Next.js)
echo   - 后端服务 (PaddleOCR)
echo.
echo 注意：
echo   - Docker卷（模型缓存）会被保留
echo   - 重新启动时会使用缓存的模型，无需重新下载
echo.

pause
