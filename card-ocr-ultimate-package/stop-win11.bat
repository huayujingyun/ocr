@echo off
chcp 65001 >nul 2>&1
echo ========================================
echo Shopping Card OCR - Win11 Stop Script
echo ========================================
echo.

echo Stopping services...
docker-compose -f docker-compose-win11.yml down
if errorlevel 1 (
    echo.
    echo ERROR: Error occurred while stopping services
    pause
    exit /b 1
)
echo.
echo OK: Services stopped
echo.
pause
