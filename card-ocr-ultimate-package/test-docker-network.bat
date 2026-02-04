@echo off
chcp 65001 >nul 2>&1
title Test Docker Network
color 0B

echo.
echo ==========================================
echo  Docker Network Diagnostic Tool
echo ==========================================
echo.

echo This tool will test your Docker network connection
echo and help identify the cause of pull failures.
echo.

echo Press any key to start diagnostic...
pause >nul

echo.
echo ==========================================
echo  [1/6] System Information
echo ==========================================
echo.

echo Docker Version:
docker --version 2>nul
if %errorLevel% neq 0 (
    echo [ERROR] Docker is not installed or not running!
)
echo.

echo Docker Compose Version:
docker-compose --version 2>nul
if %errorLevel% neq 0 (
    echo [ERROR] Docker Compose is not installed!
)
echo.

echo ==========================================
echo  [2/6] DNS Resolution
echo ==========================================
echo.

echo Testing DNS resolution for docker.io...
nslookup docker.io 2>nul
if %errorLevel% equ 0 (
    echo [OK] DNS resolution for docker.io is working
) else (
    echo [ERROR] Cannot resolve docker.io
    echo Recommendation: Check your DNS settings
)
echo.

echo ==========================================
echo  [3/6] Docker Hub Connectivity
echo ==========================================
echo.

echo Testing connection to Docker Hub (registry-1.docker.io)...
curl -I -s -m 10 https://registry-1.docker.io 2>nul
if %errorLevel% equ 0 (
    echo [OK] Can connect to Docker Hub directly
) else (
    echo [ERROR] Cannot connect to Docker Hub
    echo Recommendation: Configure Docker mirror or use proxy
)
echo.

echo ==========================================
echo  [4/6] Mirror Sources Test
echo ==========================================
echo.

echo Testing connection to DaoCloud mirror...
curl -I -s -m 10 https://docker.m.daocloud.io 2>nul
if %errorLevel% equ 0 (
    echo [OK] DaoCloud mirror is accessible: https://docker.m.daocloud.io
) else (
    echo [ERROR] DaoCloud mirror is not accessible
)
echo.

echo Testing connection to USTC mirror...
curl -I -s -m 10 https://docker.mirrors.ustc.edu.cn 2>nul
if %errorLevel% equ 0 (
    echo [OK] USTC mirror is accessible: https://docker.mirrors.ustc.edu.cn
) else (
    echo [ERROR] USTC mirror is not accessible
)
echo.

echo Testing connection to Azure mirror...
curl -I -s -m 10 https://dockerhub.azk8s.cn 2>nul
if %errorLevel% equ 0 (
    echo [OK] Azure mirror is accessible: https://dockerhub.azk8s.cn
) else (
    echo [ERROR] Azure mirror is not accessible
)
echo.

echo ==========================================
echo  [5/6] Docker Daemon Status
echo ==========================================
echo.

echo Docker daemon status:
docker info >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] Docker daemon is running
    docker info | findstr /C:"Server Version" /C:"Storage Driver"
) else (
    echo [ERROR] Docker daemon is not running
)
echo.

echo ==========================================
echo  [6/6] Image Pull Test
echo ==========================================
echo.

echo Attempting to pull a small test image (hello-world)...
echo This may take a minute...
echo.

docker pull hello-world 2>nul
if %errorLevel% equ 0 (
    echo.
    echo [OK] Successfully pulled hello-world image
    echo Docker image pull is working!
) else (
    echo.
    echo [ERROR] Failed to pull hello-world image
    echo.
    echo Possible causes:
    echo 1. Network connection issue
    echo 2. Docker Hub access restricted
    echo 3. Firewall blocking Docker
    echo 4. DNS resolution issue
    echo.
    echo Recommendations:
    echo 1. Run setup-docker-mirror.bat to configure mirror
    echo 2. Check your network connection
    echo 3. Check firewall settings
    echo 4. Consider using non-Docker version
)
echo.

echo ==========================================
echo  Diagnostic Summary
echo ==========================================
echo.

REM Check mirror configuration
if exist "%USERPROFILE%\.docker\daemon.json" (
    echo [INFO] Docker daemon.json exists
    echo Configuration:
    type "%USERPROFILE%\.docker\daemon.json" 2>nul
) else (
    echo [WARNING] Docker daemon.json not configured
    echo Run setup-docker-mirror.bat to configure mirrors
)

echo.
echo ==========================================
echo.

pause
