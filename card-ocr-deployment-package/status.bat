@echo off
chcp 65001 >nul 2>&1
title Card OCR System - Service Status
color 0B

echo.
echo ==========================================
echo  Card OCR System - Service Status
echo ==========================================
echo.

echo Checking Docker containers...
echo.

docker-compose ps

echo.
echo ==========================================
echo  Service Health Check
echo ==========================================
echo.

REM Check frontend
curl -s -o nul -w "Frontend HTTP Status: %%{http_code}\n" http://localhost:5000 2>nul
if %errorLevel% equ 0 (
    echo [OK] Frontend service is accessible
) else (
    echo [ERROR] Frontend service is not accessible
)

echo.

REM Check backend
curl -s -o nul -w "Backend HTTP Status: %%{http_code}\n" http://localhost:8001/health 2>nul
if %errorLevel% equ 0 (
    echo [OK] Backend service is accessible
) else (
    echo [ERROR] Backend service is not accessible
)

echo.
echo ==========================================
echo  Recent Logs
echo ==========================================
echo.

docker-compose logs --tail=20

echo.
echo ==========================================
echo.

pause
