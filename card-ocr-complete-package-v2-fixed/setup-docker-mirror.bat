@echo off
chcp 65001 >nul 2>&1
title Configure Docker Mirror - Quick Fix
color 0A

echo.
echo ==========================================
echo  Configure Docker Mirror - Quick Fix
echo ==========================================
echo.

echo This script will configure Docker to use
echo domestic mirror sources to solve network issues.
echo.

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Docker is not installed or not running!
    echo.
    echo Please install Docker Desktop first:
    echo https://www.docker.com/products/docker-desktop
    echo.
    pause
    exit /b 1
)

echo [OK] Docker is detected
docker --version
echo.

REM Create .docker directory if not exists
if not exist "%USERPROFILE%\.docker" (
    echo Creating .docker directory...
    mkdir "%USERPROFILE%\.docker"
)

REM Backup existing configuration
if exist "%USERPROFILE%\.docker\daemon.json" (
    echo Backing up existing configuration...
    copy "%USERPROFILE%\.docker\daemon.json" "%USERPROFILE%\.docker\daemon.json.backup" >nul 2>&1
    echo [OK] Backup created: daemon.json.backup
)

REM Create daemon.json
echo Creating daemon.json configuration...
(
echo {
echo   "registry-mirrors": [
echo     "https://docker.m.daocloud.io",
echo     "https://docker.mirrors.ustc.edu.cn",
echo     "https://dockerhub.azk8s.cn",
echo     "https://dockerproxy.com",
echo     "https://docker.nju.edu.cn"
echo   ],
echo   "dns": ["8.8.8.8", "114.114.114.114"]
echo }
) > "%USERPROFILE%\.docker\daemon.json"

if %errorLevel% equ 0 (
    echo [OK] Configuration file created successfully
) else (
    echo [ERROR] Failed to create configuration file!
    pause
    exit /b 1
)

echo.
echo Configuration saved to:
echo %USERPROFILE%\.docker\daemon.json
echo.
echo Configuration content:
type "%USERPROFILE%\.docker\daemon.json"
echo.

echo ==========================================
echo  Next Steps
echo ==========================================
echo.
echo 1. Restart Docker Desktop
echo 2. Wait for Docker to fully start (1-2 minutes)
echo 3. Run install.bat again
echo.

set /p restart="Do you want to restart Docker Desktop now? (Y/N): "
if /i "%restart%"=="Y" (
    echo.
    echo Restarting Docker Desktop...
    taskkill /F /IM "Docker Desktop.exe" >nul 2>&1
    taskkill /F /IM "com.docker.backend.exe" >nul 2>&1

    if %errorLevel% equ 0 (
        echo [OK] Docker Desktop stopped
    ) else (
        echo [INFO] Docker Desktop was not running
    )

    echo Starting Docker Desktop...
    start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"

    echo.
    echo [OK] Docker Desktop restart initiated
    echo.
    echo Please wait 1-2 minutes for Docker to fully start.
    echo You will see a Docker icon in the system tray when it's ready.
    echo.
)

echo ==========================================
echo  Test Connection
echo ==========================================
echo.
echo After Docker restarts, you can test the configuration:
echo.
echo   docker pull hello-world
echo.
echo If successful, the configuration is working!
echo.

pause
