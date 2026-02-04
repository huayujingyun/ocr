@echo off
chcp 65001 >nul
title 购物卡/加油卡OCR识别系统 - 启动服务

echo =====================================
echo 购物卡/加油卡OCR识别系统 - 启动服务
echo =====================================
echo.

REM 检查端口占用
echo [检查] 检查端口占用...
netstat -ano | findstr ":5000" >nul
if %errorLevel% equ 0 (
    echo [警告] 端口5000已被占用，前端可能已运行
)
netstat -ano | findstr ":8001" >nul
if %errorLevel% equ 0 (
    echo [警告] 端口8001已被占用，后端可能已运行
    echo 请先运行 stop.bat 停止现有服务
    echo.
    echo 按任意键退出...
    pause >nul
    exit /b 1
)

echo.
echo [启动] 正在启动后端服务...
start "OCR Backend" /min cmd /c "cd backend && python main.py > ..\logs\backend.log 2>&1"

echo [等待] 等待后端服务启动（首次启动需要下载OCR模型，约30-60秒）...
timeout /t 5 /nobreak >nul

REM 检查后端是否启动成功
echo [检查] 检查后端服务状态...
set /a counter=0
:check_backend
curl -s http://localhost:8001/health >nul 2>&1
if %errorLevel% equ 0 (
    echo [成功] 后端服务启动成功
    goto start_frontend
)
set /a counter+=1
if %counter% lss 12 (
    echo [等待] 后端服务正在启动... (%counter%/12)
    timeout /t 5 /nobreak >nul
    goto check_backend
)
echo [错误] 后端服务启动失败
echo.
echo 请检查日志: logs\backend.log
echo 常见问题：
echo   1. Python未正确安装
echo   2. 缺少OpenCV依赖
echo   3. 端口被占用
echo.
echo 按任意键退出...
pause >nul
exit /b 1

:start_frontend
echo.
echo [启动] 正在启动前端服务...
start "OCR Frontend" /min cmd /c "pnpm run dev --port 5000 > logs\frontend.log 2>&1"

echo [等待] 等待前端服务启动（约10-30秒）...
timeout /t 10 /nobreak >nul

REM 检查前端是否启动成功
echo [检查] 检查前端服务状态...
curl -s http://localhost:5000 >nul 2>&1
if %errorLevel% equ 0 (
    echo [成功] 前端服务启动成功
) else (
    echo [警告] 前端服务可能还在启动中
    echo 如果浏览器无法访问，请等待30秒后重试
)

echo.
echo =====================================
echo 服务启动完成！
echo =====================================
echo.
echo 访问地址：
echo   前端界面: http://localhost:5000
echo   后端API:  http://localhost:8001/docs
echo.
echo 管理命令：
echo   查看后端日志: type logs\backend.log
echo   查看前端日志: type logs\frontend.log
echo   停止服务: 双击 stop.bat
echo   检查状态: 双击 check.bat
echo.
echo 按任意键关闭此窗口（服务将继续在后台运行）...
pause >nul
