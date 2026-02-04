@echo off
chcp 65001 >nul 2>&1
echo ========================================
echo Shopping Card OCR - Win11 Installation
echo ========================================
echo.

echo Checking Docker status...
docker version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker is not running, please start Docker Desktop first
    pause
    exit /b 1
)
echo OK: Docker is running
echo.

echo Building backend service (using Tsinghua mirror)...
docker-compose -f docker-compose-win11.yml build paddleocr-service
if errorlevel 1 (
    echo.
    echo ERROR: Backend service build failed!
    echo.
    echo Possible reasons:
    echo 1. Network connection issues
    echo 2. Mirror server temporarily unavailable
    echo 3. Docker resource insufficient
    echo.
    echo Suggestions:
    echo 1. Run test-docker-network.bat to check network
    echo 2. Or use non-Docker version (recommended, 100%% success)
    pause
    exit /b 1
)
echo OK: Backend service built successfully
echo.

echo Building frontend service...
docker-compose -f docker-compose-win11.yml build frontend
if errorlevel 1 (
    echo.
    echo ERROR: Frontend service build failed!
    pause
    exit /b 1
)
echo OK: Frontend service built successfully
echo.

echo ========================================
echo OK: All services built successfully!
echo ========================================
echo.
echo Next steps:
echo 1. Run start-win11.bat to start services
echo 2. Visit http://localhost:5000
echo.
pause
