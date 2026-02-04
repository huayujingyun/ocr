@echo off
chcp 65001 >nul 2>&1
title Start Services - Fixed Version
color 0A

echo.
echo ==========================================
echo  Start Services - Fixed Version
echo ==========================================
echo.

REM Change to script directory
cd /d "%~dp0"

echo This script will start both backend and frontend services.
echo.

REM Check Python
python --version >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Python is not installed or not in PATH!
    echo.
    echo Please install Python 3.12 from:
    echo https://www.python.org/downloads/release/python-3127/
    echo IMPORTANT: Check "Add Python to PATH" during installation!
    echo.
    pause
    exit /b 1
)

echo [OK] Python is installed
python --version

REM Check Node.js
node --version >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Node.js is not installed or not in PATH!
    echo.
    echo Please install Node.js from:
    echo https://nodejs.org/
    echo.
    pause
    exit /b 1
)

echo [OK] Node.js is installed
node --version

REM Check pnpm
pnpm --version >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] pnpm is not installed!
    echo Installing pnpm...
    npm install -g pnpm
    if %errorLevel% neq 0 (
        echo [ERROR] Failed to install pnpm!
        pause
        exit /b 1
    )
)

echo [OK] pnpm is installed
pnpm --version

echo.
echo ==========================================
echo  Starting Services
echo ==========================================
echo.

REM Check if backend is already running
curl -s http://localhost:8001/health >nul 2>&1
if %errorLevel% equ 0 (
    echo [INFO] Backend is already running on port 8001
) else (
    echo [1/2] Starting backend service...
    echo Backend will run on port 8001
    echo.

    REM Create log directory if not exists
    if not exist "logs" mkdir logs

    REM Start backend in new window
    start "PaddleOCR Backend - http://localhost:8001" cmd /k "cd /d "%~dp0backend" && python main.py"

    echo [OK] Backend started
    echo Waiting 10 seconds for backend to initialize...
    echo.

    REM Wait for backend to start
    timeout /t 10 /nobreak >nul
)

REM Check if backend is responding after wait
curl -s http://localhost:8001/health >nul 2>&1
if %errorLevel% neq 0 (
    echo [WARNING] Backend may still be starting...
    echo Please check the backend window for any errors.
) else (
    echo [OK] Backend is responding on http://localhost:8001
)

echo.
echo [2/2] Starting frontend service...
echo Frontend will run on port 5000
echo.

REM Check if frontend is already running
curl -s http://localhost:5000 >nul 2>&1
if %errorLevel% equ 0 (
    echo [INFO] Frontend is already running on port 5000
) else (
    REM Start frontend in new window
    start "Frontend - http://localhost:5000" cmd /k "cd /d "%~dp0" && pnpm run start"

    echo [OK] Frontend started
)

echo.
echo Waiting for frontend to be ready...
timeout /t 5 /nobreak >nul

echo.
echo ==========================================
echo  Service Status
echo ==========================================
echo.

echo Backend (PaddleOCR):
curl -s http://localhost:8001/health >nul 2>&1
if %errorLevel% equ 0 (
    echo    Status: [OK] Running
    echo    URL: http://localhost:8001
    echo    API Docs: http://localhost:8001/docs
) else (
    echo    Status: [ERROR] Not responding!
    echo    Please check the backend window for errors.
)

echo.

echo Frontend (Next.js):
curl -s -o nul -w "HTTP Status: %%{http_code}\n" http://localhost:5000 2>nul
if %errorLevel% equ 0 (
    echo    Status: [OK] Running
    echo    URL: http://localhost:5000
) else (
    echo    Status: [ERROR] Not responding!
    echo    Please check the frontend window for errors.
)

echo.
echo ==========================================
echo  Instructions
echo ==========================================
echo.
echo 1. Keep both backend and frontend windows OPEN
echo 2. Do NOT close the windows while using the system
echo 3. Open browser and visit: http://localhost:5000
echo.

echo Opening browser...
timeout /t 2 /nobreak >nul
start http://localhost:5000

echo.
echo ==========================================
echo  Troubleshooting
echo ==========================================
echo.
echo If the page doesn't open:
echo 1. Wait 10-20 seconds for services to fully start
echo 2. Manually open: http://localhost:5000
echo 3. Check the backend and frontend windows for errors
echo 4. Run diagnose-no-docker.bat to diagnose issues
echo.
echo If you see connection errors:
echo 1. Check if backend is running (should see "Uvicorn running")
echo 2. Check if frontend is running (should see "ready started")
echo 3. Try stopping and restarting services
echo.
echo To stop services:
echo 1. Close the backend window (Ctrl+C or X button)
echo 2. Close the frontend window (Ctrl+C or X button)
echo 3. Or run: taskkill /F /IM python.exe /F /IM node.exe
echo.
echo ==========================================
echo.

echo Press any key to view service status...
pause >nul

echo.
echo ==========================================
echo  Current Status
echo ==========================================
echo.

echo Processes:
echo.
echo Backend (Python):
tasklist | findstr python.exe
if %errorLevel% neq 0 (
    echo    [WARNING] No Python processes found
)
echo.

echo Frontend (Node.js):
tasklist | findstr node.exe
if %errorLevel% neq 0 (
    echo    [WARNING] No Node.js processes found
)
echo.

echo Ports:
echo.
netstat -ano | findstr :5000
if %errorLevel% neq 0 (
    echo    [WARNING] Port 5000 not in use
)
echo.

netstat -ano | findstr :8001
if %errorLevel% neq 0 (
    echo    [WARNING] Port 8001 not in use
)
echo.

echo ==========================================
echo.

pause
