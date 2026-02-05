@echo off
chcp 65001 > nul
echo ==================================
echo Starting PaddleOCR Backend (Silent Mode)
echo ==================================
echo.
echo Backend will run in background.
echo Logs will be saved to: backend.log
echo.
echo Press any key to start...
pause >nul

REM Change to backend directory
cd /d "%~dp0"

REM Disable oneDNN features
set PADDLE_NO_QUANTIZE_KERNEL=1
set PADDLE_DISABLE_MKLDNN=1
set PADDLE_NO_BUILTIN_KERNEL=1
set FLAGS_use_mkldnn=0

REM Start backend in background with output redirected to log file
echo Starting backend service...
start /B py -m uvicorn main:app --host 0.0.0.0 --port 8000 > backend.log 2>&1

echo.
echo ==================================
echo Backend Started Successfully!
echo ==================================
echo.
echo Status: Running in background
echo Port: 8000
echo Log file: %cd%\backend.log
echo.
echo To view logs, open backend.log file.
echo To stop backend, run: stop-backend.bat
echo.
echo Testing backend health...
timeout /t 3 /nobreak >nul
curl http://localhost:8000/health
echo.
echo.
echo Press any key to close this window...
pause >nul
