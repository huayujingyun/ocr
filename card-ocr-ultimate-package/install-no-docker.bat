@echo off
chcp 65001 >nul 2>&1
title Card OCR System - Non-Docker Installation
color 0A

echo.
echo ==========================================
echo  Card OCR System - Non-Docker Installation
echo ==========================================
echo.

echo This version does NOT require Docker!
echo.

REM Check administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Please run this script as Administrator!
    echo.
    pause
    exit /b 1
)

cd /d "%~dp0"

echo [1/7] Checking system environment...
echo.

REM Check Python
python --version >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Python 3.12 is required!
    echo.
    echo Please install Python 3.12 from:
    echo https://www.python.org/downloads/release/python-3127/
    echo.
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
    echo [ERROR] Node.js is required!
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
    echo [INFO] pnpm not found, installing...
    call npm install -g pnpm
    if %errorLevel% neq 0 (
        echo [ERROR] Failed to install pnpm!
        pause
        exit /b 1
    )
)
echo [OK] pnpm is installed
pnpm --version

echo.
echo [2/7] Creating directories...
if not exist "logs" mkdir logs
if not exist "data" mkdir data
if not exist "backend\models" mkdir backend\models
echo [OK] Directories created

echo.
echo [3/7] Configuring environment...
if not exist ".env" (
    copy ".env.example" ".env" >nul 2>&1
    echo [OK] Environment file created
) else (
    echo [OK] Environment file exists
)

echo.
echo [4/7] Installing Python dependencies...
cd backend
pip install -r requirements.txt
if %errorLevel% neq 0 (
    echo.
    echo [ERROR] Failed to install Python dependencies!
    echo.
    echo Please check:
    echo 1. Internet connection
    echo 2. Python version (must be 3.12)
    echo 3. pip is working: pip --version
    echo.
    pause
    exit /b 1
)
echo [OK] Python dependencies installed
cd ..

echo.
echo [5/7] Installing frontend dependencies...
pnpm install
if %errorLevel% neq 0 (
    echo.
    echo [ERROR] Failed to install frontend dependencies!
    echo.
    pause
    exit /b 1
)
echo [OK] Frontend dependencies installed

echo.
echo [6/7] Building frontend...
pnpm run build
if %errorLevel% neq 0 (
    echo.
    echo [ERROR] Frontend build failed!
    echo.
    pause
    exit /b 1
)
echo [OK] Frontend built successfully

echo.
echo [7/7] Creating startup scripts...
if not exist "start-backend.bat" (
    echo @echo off > start-backend.bat
    echo cd /d "%%~dp0backend" >> start-backend.bat
    echo python main.py >> start-backend.bat
)
echo [OK] Backend startup script created

if not exist "start-frontend.bat" (
    echo @echo off > start-frontend.bat
    echo cd /d "%%~dp0" >> start-frontend.bat
    echo pnpm run start >> start-frontend.bat
)
echo [OK] Frontend startup script created

echo.
echo ==========================================
echo  Installation Complete!
echo ==========================================
echo.
echo This version runs without Docker!
echo.
echo How to use:
echo   1. Start backend: Double-click start-backend.bat
echo   2. Start frontend: Double-click start-frontend.bat
echo   3. Open browser: http://localhost:5000
echo.
echo Or use the all-in-one script:
echo   start-all.bat - Starts both services
echo.
echo Notes:
echo   1. First run may take 5-10 minutes (downloading models)
echo   2. Models will be cached in backend/models/
echo   3. Requires 8GB+ RAM
echo   4. Backend runs on port 8001
echo   5. Frontend runs on port 5000
echo.
echo ==========================================
echo.

pause
