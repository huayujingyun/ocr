@echo off
chcp 65001 >nul 2>&1
title Service Status Diagnostic
color 0B

echo.
echo ==========================================
echo  Service Status Diagnostic Tool
echo ==========================================
echo.

echo [1/6] Checking Python processes...
tasklist | findstr python
if %errorLevel% equ 0 (
    echo [OK] Python processes are running
) else (
    echo [ERROR] No Python processes found!
    echo Backend service may not be running.
)
echo.

echo [2/6] Checking Node.js processes...
tasklist | findstr node
if %errorLevel% equ 0 (
    echo [OK] Node.js processes are running
) else (
    echo [ERROR] No Node.js processes found!
    echo Frontend service may not be running.
)
echo.

echo [3/6] Checking port 5000 (Frontend)...
netstat -ano | findstr :5000
if %errorLevel% equ 0 (
    echo [OK] Port 5000 is in use
) else (
    echo [ERROR] Port 5000 is NOT in use!
    echo Frontend service is NOT running.
)
echo.

echo [4/6] Checking port 8001 (Backend)...
netstat -ano | findstr :8001
if %errorLevel% equ 0 (
    echo [OK] Port 8001 is in use
) else (
    echo [ERROR] Port 8001 is NOT in use!
    echo Backend service is NOT running.
)
echo.

echo [5/6] Testing Backend API...
curl -s http://localhost:8001/health
if %errorLevel% equ 0 (
    echo [OK] Backend API is responding
) else (
    echo [ERROR] Backend API is NOT responding!
)
echo.

echo [6/6] Testing Frontend...
curl -s -o nul -w "HTTP Status: %%{http_code}" http://localhost:5000
if %errorLevel% equ 0 (
    echo.
) else (
    echo [ERROR] Frontend is NOT responding!
)
echo.

echo ==========================================
echo  Log Files
echo ==========================================
echo.

echo Backend log (last 20 lines):
if exist "logs\backend.log" (
    powershell "Get-Content logs\backend.log -Tail 20"
) else (
    echo [ERROR] Backend log file not found!
)
echo.

echo ==========================================
echo  Detailed Process Information
echo ==========================================
echo.

echo Python processes:
wmic process where "name='python.exe'" get ProcessId,CommandLine,WorkingSetSize /format:table 2>nul
echo.

echo Node.js processes:
wmic process where "name='node.exe'" get ProcessId,CommandLine,WorkingSetSize /format:table 2>nul
echo.

echo ==========================================
echo  Recommendations
echo ==========================================
echo.

if not exist "logs\backend.log" (
    echo [INFO] Backend log not found. Starting backend...
    cd backend
    start "PaddleOCR Backend" python main.py
    cd ..
    timeout /t 3 /nobreak >nul
)

netstat -ano | findstr :5000 >nul 2>&1
if %errorLevel% neq 0 (
    echo [INFO] Frontend not running. Starting frontend...
    start "Frontend" cmd /c "pnpm run start"
    timeout /t 3 /nobreak >nul
)

echo.
echo Please check the output above for any errors.
echo If services are running, try opening: http://localhost:5000
echo.

pause
