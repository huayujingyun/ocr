@echo off
REM ========================================
REM OCR Card Recognizer - Stop Service
REM ========================================
REM

title OCR Card Recognizer - Stop Service

echo ========================================
echo Stop OCR Card Recognizer Service
echo ========================================
echo.

echo [STOP] Stopping frontend service (port 5000)...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":5000" ^| findstr "LISTENING"') do (
    taskkill /F /PID %%a 2>nul
    echo Terminated PID %%a
)

echo.
echo [STOP] Stopping backend service (port 8001)...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8001" ^| findstr "LISTENING"') do (
    taskkill /F /PID %%a 2>nul
    echo Terminated PID %%a
)

echo.
echo [CLEAN] Cleaning up process remnants...
taskkill /F /IM python.exe 2>nul
taskkill /F /IM node.exe 2>nul

echo.
echo ========================================
echo Service Stopped
echo ========================================
echo.
echo Press any key to exit...
pause >nul
