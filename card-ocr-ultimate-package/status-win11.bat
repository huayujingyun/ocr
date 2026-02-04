@echo off
chcp 65001 >nul
echo ========================================
echo 购物卡OCR系统 - Win11服务状态
echo ========================================
echo.

echo 正在检查服务状态...
docker-compose -f docker-compose-win11.yml ps
echo.

echo ========================================
echo 详细信息
echo ========================================
echo.

echo 前端服务（端口5000）：
curl -I http://localhost:5000 2>nul
if errorlevel 1 (
    echo ❌ 前端服务未响应
) else (
    echo ✓ 前端服务运行正常
)
echo.

echo 后端服务（端口8001）：
curl -I http://localhost:8001/health 2>nul
if errorlevel 1 (
    echo ❌ 后端服务未响应
) else (
    echo ✓ 后端服务运行正常
)
echo.

echo ========================================
echo 访问地址：http://localhost:5000
echo ========================================
pause
