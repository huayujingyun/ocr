@echo off
chcp 65001 >nul 2>&1
title Card OCR System - Start All Services
color 0A

echo.
echo ==========================================
echo  Card OCR System - Start All Services
echo ==========================================
echo.

echo Starting backend service...
start "PaddleOCR Backend" /min cmd /c "cd /d "%~dp0backend" && python main.py > ..\logs\backend.log 2>&1"

echo Waiting for backend to initialize...
timeout /t 5 /nobreak >nul

echo Starting frontend service...
start "Frontend" cmd /c "cd /d "%~dp0" && pnpm run start"

echo.
echo [OK] Services started!
echo.
echo Service URLs:
echo   - Frontend: http://localhost:5000
echo   - Backend: http://localhost:8001
echo   - API Docs: http://localhost:8001/docs
echo.
echo Opening browser...
timeout /t 3 /nobreak >nul

start http://localhost:5000

echo.
echo ==========================================
echo.

echo Press any key to stop all services...
pause >nul

echo.
echo Stopping services...

taskkill /F /FI "WINDOWTITLE eq PaddleOCR Backend*" >nul 2>&1
taskkill /F /FI "WINDOWTITLE eq Frontend*" >nul 2>&1

echo [OK] All services stopped.
echo.

pause
