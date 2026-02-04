@echo off
REM ========================================
REM OCR Card Recognizer - Start Service
REM ========================================
REM

title OCR Card Recognizer - Start Service

echo ========================================
echo OCR Card Recognizer - Start Service
echo ========================================
echo.

REM Check port usage
echo [CHECK] Checking port usage...
netstat -ano | findstr ":5000" >nul
if %errorLevel% equ 0 (
    echo [WARNING] Port 5000 is already in use, frontend may already be running
)
netstat -ano | findstr ":8001" >nul
if %errorLevel% equ 0 (
    echo [WARNING] Port 8001 is already in use, backend may already be running
    echo Please run stop.bat first to stop existing service
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)

echo.
echo [START] Starting backend service...

REM Check if python command exists
python --version >nul 2>&1
if %errorLevel% equ 0 (
    set PYTHON_CMD=python
) else (
    py --version >nul 2>&1
    if %errorLevel% equ 0 (
        set PYTHON_CMD=py
    ) else (
        set PYTHON_CMD=python
    )
)
echo Using Python command: %PYTHON_CMD%

REM Check if backend directory exists
if not exist "backend" (
    echo [ERROR] backend directory not found
    echo Please make sure you are running this script in the correct directory
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)

REM Start backend service
start "OCR Backend" /min cmd /c "cd /d "%~dp0backend" && %PYTHON_CMD% main.py > "%~dp0logs\backend.log" 2>&1"

echo [WAIT] Waiting for backend service to start (first startup requires downloading OCR models, ~30-60 seconds)...
timeout /t 5 /nobreak >nul

REM Check if backend started successfully
echo [CHECK] Checking backend service status...
set /a counter=0
:check_backend
curl -s http://localhost:8001/health >nul 2>&1
if %errorLevel% equ 0 (
    echo [SUCCESS] Backend service started successfully
    goto start_frontend
)
set /a counter+=1
if %counter% lss 12 (
    echo [WAIT] Backend service is starting... (%counter%/12)
    timeout /t 5 /nobreak >nul
    goto check_backend
)
echo [ERROR] Backend service startup failed
echo.
echo Please check log: logs\backend.log
echo Common issues:
echo   1. Python is not installed correctly
echo   2. Missing OpenCV dependencies
echo   3. Port is occupied
echo.
echo Press any key to exit...
pause >nul
exit /b 1

:start_frontend
echo.
echo [START] Starting frontend service...
start "OCR Frontend" /min cmd /c "cd /d "%~dp0" && pnpm run dev --port 5000 > "%~dp0logs\frontend.log" 2>&1"

echo [WAIT] Waiting for frontend service to start (~10-30 seconds)...
timeout /t 10 /nobreak >nul

REM Check if frontend started successfully
echo [CHECK] Checking frontend service status...
curl -s http://localhost:5000 >nul 2>&1
if %errorLevel% equ 0 (
    echo [SUCCESS] Frontend service started successfully
) else (
    echo [WARNING] Frontend service may still be starting
    echo If browser cannot access, please wait 30 seconds and try again
)

echo.
echo ========================================
echo Service Started!
echo ========================================
echo.
echo Access URLs:
echo   Frontend: http://localhost:5000
echo   Backend API: http://localhost:8001/docs
echo.
echo Management:
echo   View backend log: type logs\backend.log
echo   View frontend log: type logs\frontend.log
echo   Stop service: Double-click stop.bat
echo   Check status: Double-click check.bat
echo.
echo Press any key to close this window (service will continue running in background)...
pause >nul
