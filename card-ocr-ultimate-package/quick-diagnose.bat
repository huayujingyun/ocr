@echo off
title Card OCR System - Quick Diagnostics
color 0B

echo.
echo ==========================================
echo  Card OCR System - Quick Diagnostics
echo ==========================================
echo.

cd /d "%~dp0"

echo [1/8] Checking Python...
python --version 2>&1
if errorlevel 1 (
    echo ERROR: Python not found
) else (
    echo OK: Python is installed
)
echo.

echo [2/8] Checking Node.js...
node --version 2>&1
if errorlevel 1 (
    echo ERROR: Node.js not found
) else (
    echo OK: Node.js is installed
)
echo.

echo [3/8] Checking pnpm...
pnpm --version 2>&1
if errorlevel 1 (
    echo ERROR: pnpm not found
) else (
    echo OK: pnpm is installed
)
echo.

echo [4/8] Checking Docker...
docker --version 2>&1
if errorlevel 1 (
    echo INFO: Docker not found (non-Docker mode)
) else (
    echo OK: Docker is installed
    docker version | findstr "Version"
)
echo.

echo [5/8] Checking port 5000...
netstat -ano | findstr ":5000" >nul 2>&1
if errorlevel 1 (
    echo INFO: Port 5000 is free
) else (
    echo WARNING: Port 5000 is in use
    echo Running processes:
    netstat -ano | findstr ":5000"
)
echo.

echo [6/8] Checking port 8001...
netstat -ano | findstr ":8001" >nul 2>&1
if errorlevel 1 (
    echo INFO: Port 8001 is free
) else (
    echo WARNING: Port 8001 is in use
    echo Running processes:
    netstat -ano | findstr ":8001"
)
echo.

echo [7/8] Checking backend service...
curl -s http://localhost:8001/health >nul 2>&1
if errorlevel 1 (
    echo INFO: Backend service not running
) else (
    echo OK: Backend service is running
    curl -I http://localhost:8001/health
)
echo.

echo [8/8] Checking frontend service...
curl -s http://localhost:5000 >nul 2>&1
if errorlevel 1 (
    echo INFO: Frontend service not running
) else (
    echo OK: Frontend service is running
    curl -I http://localhost:5000
)
echo.

echo ==========================================
echo  Diagnostics Complete
echo ==========================================
echo.

echo Quick Start Options:
echo.
echo Non-Docker (Recommended):
echo   1. Run: quick-start.bat
echo   2. Wait 1-2 minutes
echo   3. Open: http://localhost:5000
echo.
echo Docker:
echo   1. Run: quick-start-docker.bat (standard)
echo   2. Or: quick-start-win11.bat (Win11 fixed)
echo   3. Wait 5-10 minutes
echo   4. Open: http://localhost:5000
echo.

pause
