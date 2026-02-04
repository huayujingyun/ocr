@echo off
title Card OCR System - Win11 Docker Quick Start
color 0A

echo.
echo ==========================================
echo  Card OCR System - Win11 Docker Start
echo ==========================================
echo.

cd /d "%~dp0"

echo Checking Docker...
docker version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker is not running!
    echo Please start Docker Desktop first.
    echo.
    pause
    exit /b 1
)
echo OK: Docker is running
echo.

echo Checking if services are already running...
docker ps | findstr "paddleocr-service-win11" >nul 2>&1
if not errorlevel 1 (
    echo INFO: Services are already running!
    echo.
    echo Access: http://localhost:5000
    echo.
    echo To stop services, run: stop-win11.bat
    echo.
    pause
    exit /b 0
)

echo ==========================================
echo  Starting Win11 Docker Services
echo ==========================================
echo.

echo Building and starting services...
echo This may take 15-25 minutes for the first time.
echo.

docker-compose -f docker-compose-win11.yml up -d

if errorlevel 1 (
    echo.
    echo ERROR: Failed to start services!
    echo.
    echo Troubleshooting:
    echo 1. Check Docker is running: docker ps
    echo 2. Check network: test-docker-network.bat
    echo 3. Try non-Docker version: quick-start.bat (recommended)
    echo.
    pause
    exit /b 1
)

echo.
echo ==========================================
echo  Services Started Successfully!
echo ==========================================
echo.
echo Access: http://localhost:5000
echo.
echo Commands:
echo   - Check status: status-win11.bat
echo   - View logs: docker-compose -f docker-compose-win11.yml logs -f
echo   - Stop services: stop-win11.bat
echo   - Restart: docker-compose -f docker-compose-win11.yml restart
echo.
echo Services are starting in the background...
echo Please wait 1-2 minutes before accessing the site.
echo.
pause
