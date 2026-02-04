@echo off
chcp 65001 >nul 2>&1
echo ========================================
echo Shopping Card OCR - Win11 Start Script
echo ========================================
echo.

echo Starting services...
docker-compose -f docker-compose-win11.yml up -d
if errorlevel 1 (
    echo.
    echo ERROR: Service start failed!
    pause
    exit /b 1
)
echo.
echo OK: Services started
echo.
echo Waiting for services to fully start (about 60 seconds)...
timeout /t 60 /nobreak

echo.
echo ========================================
echo OK: Services started successfully!
echo ========================================
echo.
echo Visit: http://localhost:5000
echo.
echo Common commands:
echo - Check status: status-win11.bat
echo - Stop services: stop-win11.bat
echo - View logs: docker-compose -f docker-compose-win11.yml logs -f
echo.
pause
