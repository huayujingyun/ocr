@echo off
chcp 65001 >nul
echo ========================================
echo 购物卡OCR系统 - Win11专用停止脚本
echo ========================================
echo.

echo 正在停止服务...
docker-compose -f docker-compose-win11.yml down
if errorlevel 1 (
    echo.
    echo ❌ 停止服务时出现错误
    pause
    exit /b 1
)
echo.
echo ✓ 服务已停止
echo.
pause
