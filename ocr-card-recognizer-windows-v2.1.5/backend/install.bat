@echo off
chcp 65001 > nul
echo ==================================
echo Installing PaddleOCR Backend
echo ==================================
echo.

REM Change to backend directory
cd /d "%~dp0"

echo [1/4] Checking Python version...
py --version
if %errorlevel% neq 0 (
    echo ERROR: Python not found. Please install Python 3.12.
    pause
    exit /b 1
)
echo.

echo [2/4] Installing dependencies from requirements.txt...
py -m pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo ERROR: Failed to install dependencies.
    pause
    exit /b 1
)
echo.

echo [3/4] Verifying installation...
py -m pip list | findstr /I "paddlepaddle paddleocr fastapi uvicorn"
echo.

echo [4/4] Installation completed successfully!
echo.
echo To start the backend server, run:
echo   start-backend-fixed.bat
echo.
pause
