@echo off
chcp 65001 >nul 2>&1
title Card OCR System - Check Dependencies
color 0E

echo.
echo ==========================================
echo  Card OCR System - Check Dependencies
echo ==========================================
echo.

echo [1/5] Checking Docker...
docker --version >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] Docker is installed
    docker --version
) else (
    echo [ERROR] Docker is not installed
    echo Please install Docker Desktop: https://www.docker.com/products/docker-desktop
)
echo.

echo [2/5] Checking Docker Compose...
docker-compose --version >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] Docker Compose is installed
    docker-compose --version
) else (
    echo [ERROR] Docker Compose is not installed
)
echo.

echo [3/5] Checking Docker status...
docker info >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] Docker daemon is running
) else (
    echo [ERROR] Docker daemon is not running
    echo Please start Docker Desktop
)
echo.

echo [4/5] Checking port availability...
netstat -ano | findstr ":5000" >nul 2>&1
if %errorLevel% equ 0 (
    echo [WARNING] Port 5000 is in use
) else (
    echo [OK] Port 5000 is available
)

netstat -ano | findstr ":8001" >nul 2>&1
if %errorLevel% equ 0 (
    echo [WARNING] Port 8001 is in use
) else (
    echo [OK] Port 8001 is available
)
echo.

echo [5/5] Checking disk space...
wmic logicaldisk get size,freespace,caption >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] Disk information retrieved
    for /f "skip=1 tokens=2,3" %%a in ('wmic logicaldisk get size^,freespace') do (
        set /a freeGB=%%a/1024/1024/1024
        set /a totalGB=%%b/1024/1024/1024
        echo     Available: !freeGB! GB / Total: !totalGB! GB
    )
) else (
    echo [WARNING] Could not retrieve disk information
)

echo.
echo ==========================================
echo.

pause
