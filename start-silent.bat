@echo off
chcp 65001 > nul
echo ==================================
echo OCR Card Recognizer - Silent Start
echo ==================================
echo.
echo Select startup mode:
echo.
echo [1] Silent Mode (Recommended)
echo     - Backend runs in background
echo     - Logs saved to file
echo     - Less CPU usage
echo     - Good for long-term use
echo.
echo [2] Verbose Mode
echo     - Show all logs in console
echo     - Easier to debug
echo     - May be slow with many logs
echo.
set /p choice="Please select (1 or 2): "

if "%choice%"=="1" goto SILENT
if "%choice%"=="2" goto VERBOSE
goto INVALID

:SILENT
echo.
echo [1/3] Starting Backend in Silent Mode...
echo.
start "" cmd /c "cd /d "%~dp0backend" && start-backend-silent.bat"

echo Waiting for backend to initialize...
timeout /t 5 /nobreak >nul

echo [2/3] Starting Frontend...
echo.
start "" cmd /k "cd /d "%~dp0" && pnpm run start"

echo [3/3] Opening Browser...
echo.
timeout /t 3 /nobreak >nul
start http://localhost:5000

echo.
echo ==================================
echo Services Started (Silent Mode)
echo ==================================
echo.
echo Backend:  Running in background (http://localhost:8000)
echo Frontend: Running in console (http://localhost:5000)
echo.
echo Backend logs: backend\backend.log
echo.
echo To stop backend, run: backend\stop-backend.bat
echo.
pause
goto END

:VERBOSE
echo.
echo [1/3] Starting Backend in Verbose Mode...
echo.
start "OCR Backend" cmd /k "cd /d "%~dp0backend" && start-backend-fixed.bat"

echo Waiting for backend to initialize...
timeout /t 5 /nobreak >nul

echo [2/3] Starting Frontend...
echo.
start "OCR Frontend" cmd /k "cd /d "%~dp0" && pnpm run start"

echo [3/3] Opening Browser...
echo.
timeout /t 3 /nobreak >nul
start http://localhost:5000

echo.
echo ==================================
echo Services Started (Verbose Mode)
echo ==================================
echo.
echo Backend:  Running in console (http://localhost:8000)
echo Frontend: Running in console (http://localhost:5000)
echo.
echo Close the console windows to stop services.
echo.
pause
goto END

:INVALID
echo.
echo Invalid choice. Please select 1 or 2.
pause
goto END

:END
