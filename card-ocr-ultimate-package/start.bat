@echo off
chcp 65001 >nul 2>&1
title Card OCR System - Start Services
color 0A

echo.
echo ==========================================
echo  Card OCR System - Start Services
echo ==========================================
echo.

echo Starting services...
echo.

REM Change to script directory
cd /d "%~dp0"

REM Check if docker-compose.yml exists
if not exist "docker-compose.yml" (
    echo [ERROR] docker-compose.yml not found!
    echo.
    echo Current directory: %CD%
    echo.
    pause
    exit /b 1
)

docker-compose up -d

if %errorLevel% neq 0 (
    echo.
    echo [ERROR] Service startup failed!
    echo.
    echo Please check:
    echo 1. Docker Desktop is running
    echo 2. Ports 5000 and 8001 are not in use
    echo 3. Run status.bat to check service status
    echo.
    pause
    exit /b 1
)

echo.
echo [OK] Services started successfully
echo.
echo Waiting for services to be ready...
timeout /t 5 /nobreak >nul

echo.
echo ==========================================
echo  Services Status
echo ==========================================
echo.

REM Check services
docker-compose ps

echo.
echo Service URLs:
echo   - Frontend: http://localhost:5000
echo   - Backend API: http://localhost:8001
echo   - API Docs: http://localhost:8001/docs
echo.
echo ==========================================
echo.

timeout /t 3 /nobreak >nul

start http://localhost:5000

echo Opening browser...
echo.
