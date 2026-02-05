@echo off
chcp 65001 > nul
echo ==================================
echo Stopping PaddleOCR Backend
echo ==================================
echo.

REM Find and kill uvicorn process
echo Finding uvicorn processes...
tasklist | findstr /I "uvicorn" >nul
if %errorlevel% equ 0 (
    echo Stopping uvicorn process...
    taskkill /F /IM python.exe /FI "WINDOWTITLE eq uvicorn*" >nul 2>&1
    taskkill /F /IM uvicorn.exe >nul 2>&1
    echo Backend stopped successfully.
) else (
    echo No backend process found.
)

REM Also try to kill by port
echo Checking port 8000...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8000" ^| findstr "LISTENING"') do (
    echo Stopping process %%a on port 8000...
    taskkill /F /PID %%a >nul 2>&1
)

echo.
echo ==================================
echo Stop Complete
echo ==================================
echo.
echo Press any key to close this window...
pause >nul
