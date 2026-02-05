@echo off
chcp 65001 > nul
echo ==================================
echo OCR Card Recognizer - Quick Start
echo ==================================
echo.
echo For better performance, please use:
echo   start-silent.bat  (Recommended - No lag)
echo.
echo ==================================
echo Starting in verbose mode...
echo (This may cause lag with many logs)
echo ==================================
echo.
pause

REM Get script directory
set SCRIPT_DIR=%~dp0
cd /d "%SCRIPT_DIR%"

echo [1/3] Starting Backend Service...
echo.
start "OCR Backend" cmd /k "cd /d "%SCRIPT_DIR%backend" && start-backend-fixed.bat"

echo Waiting for backend to initialize...
timeout /t 5 /nobreak >nul

echo [2/3] Verifying Backend Status...
echo Backend should be running on http://localhost:8000
echo.
timeout /t 2 /nobreak >nul

echo [3/3] Starting Frontend Service...
echo.
start "OCR Frontend" cmd /k "cd /d "%SCRIPT_DIR%" && pnpm run start"

echo.
echo ==================================
echo Services Started Successfully!
echo ==================================
echo.
echo Services:
echo   Backend:  http://localhost:8000
echo   Frontend: http://localhost:5000
echo.
echo Opening browser...
start http://localhost:5000
echo.
echo NOTE: This mode may cause lag with many logs.
echo For better performance, close this and use start-silent.bat
echo.
echo Press any key to close this window...
echo (Services will continue running in their own windows)
pause >nul
