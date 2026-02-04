@echo off
chcp 65001 >nul 2>&1
title Card OCR System - Install (China Mirror)
color 0A

echo.
echo ==========================================
echo  Card OCR System - China Mirror Install
echo ==========================================
echo.

echo This version uses domestic mirror sources for
echo faster download speeds and better connectivity.
echo.

REM Check administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Please run this script as Administrator!
    echo.
    echo Steps:
    echo 1. Right-click on install-cn.bat
    echo 2. Select "Run as administrator"
    echo.
    pause
    exit /b 1
)

cd /d "%~dp0"

echo [1/6] Checking system environment...
echo.

REM Check Docker
docker --version >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Docker Desktop not detected!
    echo.
    echo Please install Docker Desktop first:
    echo https://www.docker.com/products/docker-desktop
    echo.
    pause
    exit /b 1
)
echo [OK] Docker Desktop is installed
docker --version

echo.
echo [2/6] Creating directories...
if not exist "config" mkdir config
if not exist "logs" mkdir logs
if not exist "data" mkdir data
echo [OK] Directories created

echo.
echo [3/6] Configuring Docker mirror...
if not exist "%USERPROFILE%\.docker" mkdir "%USERPROFILE%\.docker"

REM Create daemon.json with China mirrors
(
echo {
echo   "registry-mirrors": [
echo     "https://docker.m.daocloud.io",
echo     "https://docker.mirrors.ustc.edu.cn",
echo     "https://dockerhub.azk8s.cn",
echo     "https://dockerproxy.com",
echo     "https://docker.nju.edu.cn"
echo   ],
echo   "dns": ["8.8.8.8", "114.114.114.114"]
echo }
) > "%USERPROFILE%\.docker\daemon.json"

echo [OK] Docker mirror configured
echo.

echo [4/6] Switching to optimized Dockerfiles...
REM Backup original Dockerfiles
if exist "backend\Dockerfile" (
    copy "backend\Dockerfile" "backend\Dockerfile.original" >nul 2>&1
)
if exist "frontend\Dockerfile" (
    copy "frontend\Dockerfile" "frontend\Dockerfile.original" >nul 2>&1
)

REM Use China-optimized Dockerfiles
if exist "backend\Dockerfile.cn" (
    copy "backend\Dockerfile.cn" "backend\Dockerfile" >nul 2>&1
    echo [OK] Using China-optimized backend Dockerfile
)

if exist "frontend\Dockerfile.cn" (
    copy "frontend\Dockerfile.cn" "frontend\Dockerfile" >nul 2>&1
    echo [OK] Using China-optimized frontend Dockerfile
)

echo.
echo [5/6] Building Docker images with mirrors...
echo This may take 10-20 minutes, please wait...
echo.

docker-compose build --no-cache

if %errorLevel% neq 0 (
    echo.
    echo [ERROR] Docker image build failed!
    echo.
    echo Possible reasons:
    echo 1. Network connection issues
    echo 2. Docker mirror not working
    echo 3. Insufficient disk space
    echo.
    echo Troubleshooting:
    echo 1. Run test-docker-network.bat to diagnose
    echo 2. Run setup-docker-mirror.bat to reconfigure
    echo 3. Try using non-Docker version
    echo.
    pause
    exit /b 1
)

echo.
echo [OK] Docker images built successfully

echo.
echo [6/6] Starting services...
docker-compose up -d

if %errorLevel% neq 0 (
    echo.
    echo [ERROR] Service startup failed!
    echo.
    pause
    exit /b 1
)

echo.
echo [OK] Services started successfully

echo.
echo [7/7] Waiting for services to be ready...
timeout /t 10 /nobreak >nul

echo.
echo Checking service status...
echo.

REM Check backend service
curl -s http://localhost:8001/health >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] Backend service (PaddleOCR) is running
) else (
    echo [INFO] Backend service may still be starting...
)

REM Check frontend service
curl -s http://localhost:5000 >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] Frontend service is running
) else (
    echo [INFO] Frontend service may still be starting...
)

echo.
echo ==========================================
echo  Installation Complete!
echo ==========================================
echo.
echo Service URLs:
echo   - Frontend: http://localhost:5000
echo   - Backend API: http://localhost:8001
echo   - API Docs: http://localhost:8001/docs
echo.
echo Management Commands:
echo   - Start services: start.bat
echo   - Stop services: stop.bat
echo   - Check status: status.bat
echo.
echo Notes:
echo   1. This installation uses China mirror sources
echo   2. First startup will download PaddleOCR models (~200MB)
echo   3. Models will be cached in Docker volumes
echo   4. Original Dockerfiles backed up as *.original
echo.
echo ==========================================
echo.

pause
