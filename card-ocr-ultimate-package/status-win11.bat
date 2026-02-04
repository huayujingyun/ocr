@echo off
chcp 65001 >nul 2>&1
echo ========================================
echo Shopping Card OCR - Win11 Service Status
echo ========================================
echo.

echo Checking service status...
docker-compose -f docker-compose-win11.yml ps
echo.

echo ========================================
echo Detailed Information
echo ========================================
echo.

echo Frontend service (port 5000):
curl -I http://localhost:5000 2>nul
if errorlevel 1 (
    echo ERROR: Frontend service not responding
) else (
    echo OK: Frontend service is running
)
echo.

echo Backend service (port 8001):
curl -I http://localhost:8001/health 2>nul
if errorlevel 1 (
    echo ERROR: Backend service not responding
) else (
    echo OK: Backend service is running
)
echo.

echo ========================================
echo Visit: http://localhost:5000
echo ========================================
pause
