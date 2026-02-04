@echo off
REM ========================================
REM OCR Card Recognizer - Windows Installer
REM Version: v2.0.2
REM ========================================
REM

REM Check administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Please run this script as Administrator
    echo Right-click on install.bat and select "Run as administrator"
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)

echo ========================================
echo OCR Card Recognizer - Installer
echo Version: v2.0.2
echo ========================================
echo.

echo [Step 1/7] Checking system requirements...
echo.

REM Check OS version
ver | findstr /i "10\.0\|6\.3\|6\.2" >nul
if %errorLevel% neq 0 (
    echo [WARNING] This installer is for Windows 8/10/11
    echo Other versions may have compatibility issues
) else (
    echo Operating System: Windows 8/10/11
)

echo.
echo [Step 2/7] Checking Python installation...

REM Try python command first
python --version >nul 2>&1
if %errorLevel% equ 0 (
    for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
    echo Python version: %PYTHON_VERSION%
    echo Python command: python
    goto :python_found
)

REM Try py command (Python Launcher)
py --version >nul 2>&1
if %errorLevel% equ 0 (
    for /f "tokens=2" %%i in ('py --version 2^>^&1') do set PYTHON_VERSION=%%i
    echo Python version: %PYTHON_VERSION%
    echo Python command: py
    REM Create python.bat as wrapper
    echo @echo off > python.bat
    echo py %%* >> python.bat
    echo Created python.bat wrapper
    goto :python_found
)

REM Python not found
echo [ERROR] Python is not installed or not in PATH
echo.
echo Current system only found PowerShell can run python
echo But cmd.exe cannot find python command
echo.
echo Possible solutions:
echo.
echo [Solution 1] Check if Python is installed in PATH
echo   1. Open cmd.exe and run: python --version
echo   2. If it works, the PATH is correct
echo   3. If not, Python is not in system PATH
echo.
echo [Solution 2] Reinstall Python with PATH added
echo   1. Visit: https://www.python.org/downloads/release/python-3128/
echo   2. Download: Windows installer (64-bit)
echo   3. Run the installer
echo   4. IMPORTANT: Check "Add Python to PATH"
echo   5. Click "Install Now"
echo   6. Restart cmd.exe after installation
echo.
echo [Solution 3] Manually add Python to PATH
echo   1. Find Python installation path (usually: C:\Users\YourName\AppData\Local\Programs\Python\Python312\)
echo   2. Right-click "This PC" -^> Properties -^> Advanced system settings -^> Environment Variables
echo   3. Edit "Path" variable
echo   4. Add Python installation path
echo   5. Add Scripts subfolder path
echo   6. Click OK and restart cmd.exe
echo.
echo After fixing PATH, please run this script again
echo.
echo Press any key to exit...
pause >nul
exit /b 1

:python_found

echo.
echo [Step 3/7] Checking Node.js installation...
node --version >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Node.js is not installed
    echo.
    echo Please install Node.js:
    echo 1. Visit: https://nodejs.org/
    echo 2. Download: LTS version (recommended Node.js 20 LTS)
    echo 3. Run the installer
    echo 4. Click "Install" to complete
    echo.
    echo After installation, please run this script again
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
) else (
    for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
    echo Node.js version: %NODE_VERSION%
)

echo.
echo [Step 4/7] Installing pnpm...
pnpm --version >nul 2>&1
if %errorLevel% neq 0 (
    echo Installing pnpm...
    npm install -g pnpm
    if %errorLevel% neq 0 (
        echo [ERROR] pnpm installation failed
        echo.
        echo Press any key to exit...
        pause >nul
        exit /b 1
    )
) else (
    for /f "tokens=*" %%i in ('pnpm --version') do set PNPM_VERSION=%%i
    echo pnpm already installed, version: %PNPM_VERSION%
)

echo.
echo [Step 5/7] Installing backend dependencies...
cd backend
echo Checking backend directory...
if not exist "requirements.txt" (
    echo [ERROR] requirements.txt not found
    echo Please make sure you are running this script in the correct directory
    cd ..
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)

echo Installing Python dependencies (this may take a few minutes)...
pip install -r requirements.txt
if %errorLevel% neq 0 (
    echo [ERROR] Python dependencies installation failed
    echo.
    echo Possible solutions:
    echo 1. Check network connection
    echo 2. Try updating pip: python -m pip install --upgrade pip
    echo 3. Use domestic mirror: pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
    echo.
    cd ..
    echo Press any key to exit...
    pause >nul
    exit /b 1
)
echo Python dependencies installed successfully
cd ..

echo.
echo [Step 6/7] Installing frontend dependencies...
echo Checking frontend files...
if not exist "package.json" (
    echo [ERROR] package.json not found
    echo Please make sure you are running this script in the correct directory
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)

echo Installing Node.js dependencies (this may take a few minutes)...
pnpm install
if %errorLevel% neq 0 (
    echo [ERROR] Node.js dependencies installation failed
    echo.
    echo Possible solutions:
    echo 1. Check network connection
    echo 2. Clear cache: pnpm store prune
    echo 3. Use domestic mirror: pnpm config set registry https://registry.npmmirror.com
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)
echo Node.js dependencies installed successfully

echo.
echo Building frontend...
pnpm run build
if %errorLevel% neq 0 (
    echo [WARNING] Frontend build failed
    echo This usually doesn't affect usage, frontend will be built on first startup
    echo If you encounter issues later, manually run: pnpm run build
) else (
    echo Frontend built successfully
)

echo.
echo [Step 7/7] Creating necessary directories...
if not exist "logs" (
    mkdir logs
    echo Created directory: logs\
)
if not exist "data\uploads" (
    mkdir data\uploads
    echo Created directory: data\uploads\
)
if not exist "data\exports" (
    mkdir data\exports
    echo Created directory: data\exports\
)

echo.
echo ========================================
echo Installation Complete!
echo ========================================
echo.
echo Usage:
echo   1. Double-click start.bat to start the service
echo   2. Double-click stop.bat to stop the service
echo   3. Double-click check.bat to check service status
echo   4. Visit http://localhost:5000 to use the system
echo.
echo Notes:
echo   - First startup requires downloading OCR models (~200MB), please be patient
echo   - First startup may take 30-60 seconds
echo   - Subsequent startups only take 10-20 seconds
echo.
echo If you encounter issues, please check:
echo   - logs\backend.log (backend log)
echo   - logs\frontend.log (frontend log)
echo.
echo Press any key to exit...
pause >nul
