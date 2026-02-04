@echo off
title Card OCR System - Docker Quick Start
color 0A

echo.
echo ==========================================
echo  Card OCR System - Docker Quick Start
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
docker ps | findstr "paddleocr-service" >nul 2>&1
if not errorlevel 1 (
    echo INFO: Services are already running!
    echo.
    echo Access: http://localhost:5000
    echo.
    echo To stop services, run: stop.bat
    echo.
    pause
    exit /b 0
)

echo ==========================================
echo  Starting Docker Services
echo ==========================================
echo.

echo Building and starting services...
echo This may take 15-25 minutes for the first time.
echo.

docker-compose up -d

if errorlevel 1 (
    echo.
    echo ERROR: Failed to start services!
    echo.
    echo Troubleshooting:
    echo 1. Check Docker is running: docker ps
    echo 2. Check available memory: docker system df
    echo 3. Try non-Docker version: install-no-docker.bat
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
echo   - Check status: docker-compose ps
echo   - View logs: docker-compose logs -f
echo   - Stop services: stop.bat
echo   - Restart: docker-compose restart
echo.
echo Services are starting in the background...
echo Please wait 1-2 minutes before accessing the site.
echo.
pause
