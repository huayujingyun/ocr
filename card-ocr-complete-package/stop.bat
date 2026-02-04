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
