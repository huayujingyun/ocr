@echo off
REM ========================================
REM OCR Card Recognizer - Auto Install Dependencies
REM Version: v1.0
REM ========================================
REM

title OCR Card Recognizer - Auto Install Dependencies

echo ========================================
echo OCR Card Recognizer - Auto Install Dependencies
echo ========================================
echo.
echo This script will help you install required dependencies:
echo   - Python 3.12
echo   - Node.js 20 LTS
echo.
echo ========================================
echo.

REM Check administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Please run this script as Administrator
    echo Right-click on setup.bat and select "Run as administrator"
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)

echo [Step 1/4] Checking Python installation...
python --version >nul 2>&1
if %errorLevel% equ 0 (
    for /f "tokens=*" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
    echo [OK] Python is installed: %PYTHON_VERSION%
    set PYTHON_INSTALLED=1
) else (
    py --version >nul 2>&1
    if %errorLevel% equ 0 (
        for /f "tokens=*" %%i in ('py --version 2^>^&1') do set PYTHON_VERSION=%%i
        echo [OK] Python is installed: %PYTHON_VERSION% (via py launcher)
        set PYTHON_INSTALLED=1
    ) else (
        echo [NOT INSTALLED] Python is not installed
        set PYTHON_INSTALLED=0
    )
)

echo.
echo [Step 2/4] Checking Node.js installation...
node --version >nul 2>&1
if %errorLevel% equ 0 (
    for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
    echo [OK] Node.js is installed: %NODE_VERSION%
    set NODE_INSTALLED=1
) else (
    echo [NOT INSTALLED] Node.js is not installed
    set NODE_INSTALLED=0
)

echo.
echo ========================================
echo Installation Summary:
echo ========================================
echo.
if %PYTHON_INSTALLED% equ 1 (
    echo [X] Python 3.12
) else (
    echo [ ] Python 3.12
)
if %NODE_INSTALLED% equ 1 (
    echo [X] Node.js 20 LTS
) else (
    echo [ ] Node.js 20 LTS
)
echo.

if %PYTHON_INSTALLED% equ 1 if %NODE_INSTALLED% equ 1 (
    echo [SUCCESS] All dependencies are installed!
    echo.
    echo Next step: Run install.bat to install project dependencies
    echo.
    echo Press any key to run install.bat...
    pause >nul
    call install.bat
    exit /b 0
)

echo [Step 3/4] Downloading missing dependencies...
echo.

REM Create downloads directory
if not exist "downloads" mkdir downloads

if %PYTHON_INSTALLED% equ 0 (
    echo [DOWNLOAD] Python 3.12.8 installer...
    echo Download URL: https://www.python.org/ftp/python/3.12.8/python-3.12.8-amd64.exe
    echo.
    echo Please wait while downloading...
    powershell -Command "& {Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.12.8/python-3.12.8-amd64.exe' -OutFile 'downloads\python-installer.exe'}"
    if %errorLevel% equ 0 (
        echo [OK] Python installer downloaded to downloads\python-installer.exe
    ) else (
        echo [ERROR] Failed to download Python installer
        echo.
        echo Please download manually:
        echo https://www.python.org/downloads/release/python-3128/
        echo.
        echo Press any key to exit...
        pause >nul
        exit /b 1
    )
    echo.
)

if %NODE_INSTALLED% equ 0 (
    echo [DOWNLOAD] Node.js 20 LTS installer...
    echo Download URL: https://nodejs.org/dist/v20.11.1/node-v20.11.1-x64.msi
    echo.
    echo Please wait while downloading...
    powershell -Command "& {Invoke-WebRequest -Uri 'https://nodejs.org/dist/v20.11.1/node-v20.11.1-x64.msi' -OutFile 'downloads\nodejs-installer.msi'}"
    if %errorLevel% equ 0 (
        echo [OK] Node.js installer downloaded to downloads\nodejs-installer.msi
    ) else (
        echo [ERROR] Failed to download Node.js installer
        echo.
        echo Please download manually:
        echo https://nodejs.org/
        echo.
        echo Press any key to exit...
        pause >nul
        exit /b 1
    )
    echo.
)

echo [Step 4/4] Installing dependencies...
echo.

if %PYTHON_INSTALLED% equ 0 (
    echo [INSTALL] Python 3.12.8...
    echo IMPORTANT: The installer will open in a new window
    echo.
    echo Please follow these steps:
    echo   1. The installer will open automatically
    echo   2. IMPORTANT: Check the box "Add Python to PATH"
    echo   3. Click "Install Now"
    echo   4. Wait for installation to complete
    echo   5. Click "Close" when done
    echo   6. Return to this window and press any key to continue
    echo.
    echo Starting installer in 3 seconds...
    timeout /t 3 /nobreak >nul
    start /wait "" "downloads\python-installer.exe"
    echo.
    echo [OK] Python installation completed
    echo.
)

if %NODE_INSTALLED% equ 0 (
    echo [INSTALL] Node.js 20 LTS...
    echo IMPORTANT: The installer will open in a new window
    echo.
    echo Please follow these steps:
    echo   1. The installer will open automatically
    echo   2. Click "Next" through all prompts
    echo   3. Wait for installation to complete
    echo   4. Click "Finish" when done
    echo   5. Return to this window and press any key to continue
    echo.
    echo Starting installer in 3 seconds...
    timeout /t 3 /nobreak >nul
    start /wait "" "downloads\nodejs-installer.msi"
    echo.
    echo [OK] Node.js installation completed
    echo.
)

echo ========================================
echo Installation Complete!
echo ========================================
echo.
echo IMPORTANT: You need to restart this script or open a new cmd window
echo to make the environment changes take effect.
echo.
echo Press any key to restart the script...
pause >nul

REM Restart the script
call "%~f0"
