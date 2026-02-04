@echo off
chcp 65001 >nul
echo ========================================
echo 购物卡OCR系统 - Win11专用启动脚本
echo ========================================
echo.

echo 正在启动服务...
docker-compose -f docker-compose-win11.yml up -d
if errorlevel 1 (
    echo.
    echo ❌ 服务启动失败！
    pause
    exit /b 1
)
echo.
echo ✓ 服务已启动
echo.
echo 等待服务完全启动（约60秒）...
timeout /t 60 /nobreak

echo.
echo ========================================
echo ✓ 服务启动完成！
echo ========================================
echo.
echo 访问地址：http://localhost:5000
echo.
echo 常用命令：
echo - 查看状态：status-win11.bat
echo - 停止服务：stop-win11.bat
echo - 查看日志：docker-compose -f docker-compose-win11.yml logs -f
echo.
pause
