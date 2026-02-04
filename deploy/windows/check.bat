@echo off
REM ========================================
REM OCR Card Recognizer - Check Status
REM ========================================
REM

title OCR Card Recognizer - Check Status

echo ========================================
echo Service Status Check
echo ========================================
echo.

echo [CHECK] Backend service (port 8001)...
netstat -ano | findstr ":8001" | findstr "LISTENING" >nul
if %errorLevel% equ 0 (
    echo [RUNNING] Backend service
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8001" ^| findstr "LISTENING"') do (
        echo         Process ID: %%a
        tasklist /FI "PID eq %%a" /FO TABLE /NH
    )
    echo.
    curl -s http://localhost:8001/health
    echo.
) else (
    echo [STOPPED] Backend service
)

echo.
echo [CHECK] Frontend service (port 5000)...
netstat -ano | findstr ":5000" | findstr "LISTENING" >nul
if %errorLevel% equ 0 (
    echo [RUNNING] Frontend service
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":5000" ^| findstr "LISTENING"') do (
        echo         Process ID: %%a
        tasklist /FI "PID eq %%a" /FO TABLE /NH
    )
    echo         Access URL: http://localhost:5000
) else (
    echo [STOPPED] Frontend service
)

echo.
echo ========================================
echo Press any key to exit...
pause >nul
