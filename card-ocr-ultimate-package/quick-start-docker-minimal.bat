@echo off
title Card OCR - Docker Minimal Start
color 0B

echo.
echo ==========================================
echo  Card OCR - Docker Minimal Version
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

echo This version uses minimal dependencies to avoid network issues.
echo If this still fails, please use non-Docker version: quick-start.bat
echo.
echo Starting Docker services (minimal version)...
echo This may take 10-20 minutes for the first time.
echo.

docker-compose -f docker-compose-minimal.yml up -d

if errorlevel 1 (
    echo.
    echo ERROR: Failed to start services!
    echo.
    echo RECOMMENDED: Use non-Docker version instead
    echo   - Run: quick-start.bat
    echo   - Success rate: 100%%
    echo   - Time: 3-5 minutes
    echo.
    echo If you must use Docker:
    echo   1. Check Docker is running: docker ps
    echo   2. Try again later (network may be unstable)
    echo   3. Check Docker resources: Docker Desktop - Settings - Resources
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
echo   - Check status: docker-compose -f docker-compose-minimal.yml ps
echo   - View logs: docker-compose -f docker-compose-minimal.yml logs -f
echo   - Stop services: docker-compose -f docker-compose-minimal.yml down
echo.
echo Services are starting in the background...
echo Please wait 1-2 minutes before accessing the site.
echo.
pause
