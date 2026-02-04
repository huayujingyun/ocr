@echo off
chcp 65001 >nul 2>&1
title Stop Services
color 0C

echo.
echo ==========================================
echo  Stop Services
echo ==========================================
echo.

echo Stopping all services...
echo.

REM Stop Python processes (backend)
echo [1/3] Stopping backend (Python)...
taskkill /F /IM python.exe >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] Backend stopped
) else (
    echo [INFO] No Python processes to stop
)

REM Stop Node.js processes (frontend)
echo.
echo [2/3] Stopping frontend (Node.js)...
taskkill /F /IM node.exe >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] Frontend stopped
) else (
    echo [INFO] No Node.js processes to stop
)

REM Wait a moment
echo.
echo [3/3] Cleaning up...
timeout /t 2 /nobreak >nul

echo.
echo ==========================================
echo  Verification
echo ==========================================
echo.

echo Checking remaining processes...
echo.

tasklist | findstr python.exe >nul 2>&1
if %errorLevel% equ 0 (
    echo [WARNING] Some Python processes are still running
) else (
    echo [OK] All Python processes stopped
)

echo.

tasklist | findstr node.exe >nul 2>&1
if %errorLevel% equ 0 (
    echo [WARNING] Some Node.js processes are still running
) else (
    echo [OK] All Node.js processes stopped
)

echo.
echo ==========================================
echo  Port Status
echo ==========================================
echo.

netstat -ano | findstr :5000 >nul 2>&1
if %errorLevel% neq 0 (
    echo [OK] Port 5000 is now free
) else (
    echo [WARNING] Port 5000 is still in use
)

netstat -ano | findstr :8001 >nul 2>&1
if %errorLevel% neq 0 (
    echo [OK] Port 8001 is now free
) else (
    echo [WARNING] Port 8001 is still in use
)

echo.
echo ==========================================
echo  All services stopped!
echo ==========================================
echo.

echo You can now restart services with:
echo   start-services-fixed.bat
echo.

pause
