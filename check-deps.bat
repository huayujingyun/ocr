@echo off
chcp 65001 >nul
title 购物卡OCR系统 - 依赖检查
color 0A

echo.
echo ==========================================
echo  购物卡/加油卡OCR识别系统 - 依赖检查
echo ==========================================
echo.

set ALL_PASSED=1

echo [1/5] 检查操作系统...
ver | findstr /i "10\.0\|11\.0" >nul 2>&1
if %errorLevel% equ 0 (
    echo [✓] Windows版本：Windows 10/11
) else (
    echo [!] 操作系统版本未知，可能存在兼容性问题
    set ALL_PASSED=0
)
echo.

echo [2/5] 检查Docker Desktop...
docker --version >nul 2>&1
if %errorLevel% equ 0 (
    echo [✓] Docker Desktop已安装
    docker --version
    echo.
    echo 检查Docker状态...
    docker info >nul 2>&1
    if %errorLevel% equ 0 (
        echo [✓] Docker服务运行正常
    ) else (
        echo [✗] Docker服务未运行
        echo.
        echo 请启动Docker Desktop
        set ALL_PASSED=0
    )
) else (
    echo [✗] Docker Desktop未安装
    echo.
    echo 请先安装Docker Desktop：
    echo https://www.docker.com/products/docker-desktop
    set ALL_PASSED=0
)
echo.

echo [3/5] 检查端口占用...
echo 检查端口 5000...
netstat -ano | findstr ":5000" | findstr "LISTENING" >nul 2>&1
if %errorLevel% equ 0 (
    echo [✗] 端口5000已被占用
    echo.
    echo 查看占用进程：
    netstat -ano | findstr ":5000" | findstr "LISTENING"
    echo.
    echo 解决方案：
    echo 1. 停止占用该端口的程序
    echo 2. 或修改docker-compose.yml中的端口映射
    set ALL_PASSED=0
) else (
    echo [✓] 端口5000可用
)

echo 检查端口 8001...
netstat -ano | findstr ":8001" | findstr "LISTENING" >nul 2>&1
if %errorLevel% equ 0 (
    echo [✗] 端口8001已被占用
    echo.
    echo 查看占用进程：
    netstat -ano | findstr ":8001" | findstr "LISTENING"
    echo.
    echo 解决方案：
    echo 1. 停止占用该端口的程序
    echo 2. 或修改docker-compose.yml中的端口映射
    set ALL_PASSED=0
) else (
    echo [✓] 端口8001可用
)
echo.

echo [4/5] 检查磁盘空间...
for /f "tokens=3" %%i in ('dir C:\ ^| find "可用字节"') do set FREE_SPACE=%%i
echo [✓] 磁盘可用空间：%FREE_SPACE% 字节
echo.

echo [5/5] 检查配置文件...
if exist "docker-compose.yml" (
    echo [✓] docker-compose.yml 存在
) else (
    echo [✗] docker-compose.yml 不存在
    set ALL_PASSED=0
)

if exist "config\.env" (
    echo [✓] config/.env 存在
) else (
    echo [!] config/.env 不存在（将自动创建）
)

if exist "backend" (
    echo [✓] backend/ 目录存在
) else (
    echo [✗] backend/ 目录不存在
    set ALL_PASSED=0
)

if exist "frontend" (
    echo [✓] frontend/ 目录存在
) else (
    echo [✗] frontend/ 目录不存在
    set ALL_PASSED=0
)
echo.

echo ==========================================
echo  检查结果
echo ==========================================
echo.
if %ALL_PASSED% equ 1 (
    echo [✓] 所有依赖检查通过，可以开始安装！
    echo.
    echo 下一步：
    echo   运行 install.bat 开始一键安装
) else (
    echo [!] 部分依赖检查未通过，请先解决上述问题
    echo.
    echo 可能需要的操作：
    echo   1. 安装Docker Desktop
    echo   2. 启动Docker Desktop
    echo   3. 释放端口5000和8001
    echo   4. 确保项目文件完整
)
echo.
echo ==========================================
echo.

pause
