@echo off
chcp 65001 >nul
title Docker部署 - 购物卡/加油卡OCR识别系统

echo =====================================
echo Docker部署 - 购物卡/加油卡OCR识别系统
echo =====================================
echo.

REM 检查Docker是否安装
echo [检查] 检查Docker安装...
docker --version >nul 2>&1
if %errorLevel% neq 0 (
    echo [错误] Docker未安装
    echo 请先安装Docker Desktop: https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

docker --version
docker-compose --version

echo.
echo [检查] 检查Docker服务状态...
docker ps >nul 2>&1
if %errorLevel% neq 0 (
    echo [错误] Docker未运行
    echo 请启动Docker Desktop
    pause
    exit /b 1
)

echo.
echo [选项] 选择操作：
echo   1. 启动服务（首次启动会自动构建镜像）
echo   2. 停止服务
echo   3. 重启服务
echo   4. 查看日志
echo   5. 查看服务状态
echo   0. 退出
echo.
set /p choice="请输入选项 (0-5): "

if "%choice%"=="1" goto start
if "%choice%"=="2" goto stop
if "%choice%"=="3" goto restart
if "%choice%"=="4" goto logs
if "%choice%"=="5" goto status
if "%choice%"=="0" goto end
echo [错误] 无效选项
pause
exit /b 1

:start
echo.
echo [启动] 正在启动服务...
docker-compose up -d
echo.
echo [完成] 服务已启动
echo 访问地址: http://localhost:5000
pause
exit /b 0

:stop
echo.
echo [停止] 正在停止服务...
docker-compose down
echo.
echo [完成] 服务已停止
pause
exit /b 0

:restart
echo.
echo [重启] 正在重启服务...
docker-compose restart
echo.
echo [完成] 服务已重启
pause
exit /b 0

:logs
echo.
echo [日志] 查看服务日志（Ctrl+C退出）...
docker-compose logs -f
pause
exit /b 0

:status
echo.
echo [状态] 服务状态：
docker-compose ps
echo.
pause
exit /b 0

:end
exit /b 0
