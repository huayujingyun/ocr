@echo off
chcp 65001 >nul 2>&1
title Card OCR System - Installation
color 0A

echo.
echo ==========================================
echo  Card OCR System - One-Click Install
echo ==========================================
echo.

REM Check administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Please run this script as Administrator!
    echo.
    echo Steps:
    echo 1. Right-click on install.bat
    echo 2. Select "Run as administrator"
    echo.
    pause
    exit /b 1
)

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

REM Check Git
git --version >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] Git is installed
    git --version
) else (
    echo [INFO] Git not detected (optional)
)

echo.
echo [2/6] Creating directories...
if not exist "config" mkdir config
if not exist "logs" mkdir logs
if not exist "data" mkdir data
echo [OK] Directories created

echo.
echo [3/6] Configuring environment variables...
if not exist "config\.env" (
    copy "config\.env.example" "config\.env" >nul 2>&1
    echo [OK] Environment file created
) else (
    echo [OK] Environment file exists
)

echo.
echo [4/6] Building Docker images...
echo This may take 10-20 minutes, please wait...
echo.

REM Change to script directory
cd /d "%~dp0"

REM Check if docker-compose.yml exists
if not exist "docker-compose.yml" (
    echo [ERROR] docker-compose.yml not found!
    echo.
    echo Current directory: %CD%
    echo.
    echo Please ensure you are running this script from the correct directory.
    pause
    exit /b 1
)

echo [OK] Found docker-compose.yml in: %CD%
echo.

docker-compose build --no-cache

if %errorLevel% neq 0 (
    echo.
    echo [ERROR] Docker image build failed!
    echo.
    echo Possible reasons:
    echo 1. Network connection issues
    echo 2. Docker not running properly
    echo 3. Insufficient disk space
    echo.
    echo Solutions:
    echo 1. Check network connection
    echo 2. Make sure Docker Desktop is running
    echo 3. Free disk space and retry
    echo.
    pause
    exit /b 1
)

echo.
echo [OK] Docker images built successfully

echo.
echo [5/6] Starting services...
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
echo [6/6] Waiting for services to be ready...
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
echo   - Start services: Double-click start.bat
echo   - Stop services: Double-click stop.bat
echo   - Check status: Double-click status.bat
echo.
echo Common Operations:
echo   - View logs: docker-compose logs -f
echo   - Restart services: docker-compose restart
echo   - Clean data: docker-compose down -v
echo.
echo Notes:
echo   1. First startup will download PaddleOCR models (~200MB)
echo   2. Models will be cached in Docker volumes
echo   3. Check logs in logs/ directory if issues occur
echo.
echo ==========================================
echo.

pause
