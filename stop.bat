@echo off
chcp 65001 >nul 2>&1
title Card OCR System - Stop Services
color 0C

echo.
echo ==========================================
echo  Card OCR System - Stop Services
echo ==========================================
echo.

echo Stopping services...
echo.

docker-compose down

if %errorLevel% neq 0 (
    echo.
    echo [ERROR] Service stop failed!
    echo.
    pause
    exit /b 1
)

echo.
echo [OK] Services stopped successfully
echo.
echo ==========================================
echo.

pause
