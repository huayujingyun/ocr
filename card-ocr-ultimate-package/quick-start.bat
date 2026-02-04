@echo off
title Card OCR System - Quick Start
color 0A

echo.
echo ==========================================
echo  Card OCR System - Quick Start
echo ==========================================
echo.

cd /d "%~dp0"

echo Checking Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python 3.12 is required!
    echo Please install Python from: https://www.python.org/downloads/
    echo IMPORTANT: Check "Add Python to PATH" during installation!
    echo.
    pause
    exit /b 1
)
python --version
echo.

echo Checking Node.js...
node --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Node.js is required!
    echo Please install Node.js from: https://nodejs.org/
    echo.
    pause
    exit /b 1
)
node --version
echo.

echo Checking pnpm...
pnpm --version >nul 2>&1
if errorlevel 1 (
    echo Installing pnpm...
    npm install -g pnpm
    if errorlevel 1 (
        echo ERROR: Failed to install pnpm!
        pause
        exit /b 1
    )
)
pnpm --version
echo.

echo ==========================================
echo  Starting Services
echo ==========================================
echo.

echo [1/2] Starting backend service (port 8001)...
start "Card OCR Backend" cmd /k "cd /d "%~dp0backend" && python main.py"
timeout /t 5 /nobreak

echo [2/2] Starting frontend service (port 5000)...
start "Card OCR Frontend" cmd /k "cd /d "%~dp0" && pnpm run start"
timeout /t 3 /nobreak

echo.
echo ==========================================
echo  Services Started!
echo ==========================================
echo.
echo Access: http://localhost:5000
echo.
echo Two windows should open:
echo  - Backend service (black window)
echo  - Frontend service (black window)
echo.
echo Do NOT close these windows!
echo.
echo To stop services:
echo  - Close the two windows
echo  - Or press Ctrl+C in each window
echo.
pause
