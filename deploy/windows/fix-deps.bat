@echo off
REM ========================================
REM OCR Card Recognizer - Fix Dependencies
REM Version: v1.0
REM ========================================
REM

title OCR Card Recognizer - Fix Dependencies

echo ========================================
echo OCR Card Recognizer - Fix Dependencies
echo ========================================
echo.

REM Check administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Please run this script as Administrator
    echo Right-click on fix-deps.bat and select "Run as administrator"
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)

echo [Step 1/3] Checking Python installation...
python --version >nul 2>&1
if %errorLevel% neq 0 (
    py --version >nul 2>&1
    if %errorLevel% equ 0 (
        set PYTHON_CMD=py
        echo Using Python: py
    ) else (
        echo [ERROR] Python is not installed
        echo.
        echo Please run setup.bat first to install Python
        echo.
        echo Press any key to exit...
        pause >nul
        exit /b 1
    )
) else (
    set PYTHON_CMD=python
    echo Using Python: python
)

for /f "tokens=*" %%i in ('%PYTHON_CMD% --version 2^>^&1') do set PYTHON_VERSION=%%i
echo Python version: %PYTHON_VERSION%

echo.
echo [Step 2/3] Installing FastAPI and backend dependencies...
echo This may take a few minutes...
echo.

cd /d "%~dp0backend"
if %errorLevel% neq 0 (
    echo [ERROR] Cannot change to backend directory
    echo Current directory: %CD%
    echo Trying: cd /d "%~dp0backend"
    echo.
    echo Please check:
    echo   1. You are running this script from the correct directory
    echo   2. The backend folder exists next to fix-deps.bat
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)

echo [INFO] Now in directory: %CD%
echo.

if exist "requirements.txt" (
    echo Installing dependencies from requirements.txt...
    %PYTHON_CMD% -m pip install -r requirements.txt --upgrade
    if %errorLevel% neq 0 (
        echo.
        echo [WARNING] Installation from requirements.txt failed
        echo Trying to install essential dependencies manually...
        echo.
        echo Installing FastAPI and Uvicorn...
        %PYTHON_CMD% -m pip install fastapi uvicorn[standard] python-multipart
        if %errorLevel% neq 0 (
            echo [ERROR] Failed to install FastAPI dependencies
            echo.
            cd /d "%~dp0"
            echo Press any key to exit...
            pause >nul
            exit /b 1
        )
        echo.
        echo Installing PaddlePaddle and PaddleOCR...
        echo Note: This may take a few minutes...
        %PYTHON_CMD% -m pip install paddleocr opencv-python-headless pillow numpy pydantic pydantic-settings python-dotenv
        if %errorLevel% neq 0 (
            echo.
            echo [WARNING] Failed to install PaddleOCR dependencies
            echo Trying alternative installation method...
            echo.
            %PYTHON_CMD% -m pip install paddleocr -i https://pypi.tuna.tsinghua.edu.cn/simple
        )
    )
) else (
    echo [WARNING] requirements.txt not found in backend directory
    echo Installing essential dependencies manually...
    echo.
    echo Installing FastAPI and Uvicorn...
    %PYTHON_CMD% -m pip install fastapi uvicorn[standard] python-multipart
    if %errorLevel% neq 0 (
        echo [ERROR] Failed to install dependencies
        cd /d "%~dp0"
        echo Press any key to exit...
        pause >nul
        exit /b 1
    )
    echo.
    echo Installing PaddlePaddle and PaddleOCR...
    echo Note: This may take a few minutes...
    %PYTHON_CMD% -m pip install paddleocr opencv-python-headless pillow numpy pydantic pydantic-settings python-dotenv
    if %errorLevel% neq 0 (
        echo.
        echo [WARNING] Failed to install PaddleOCR dependencies
        echo Trying alternative installation method...
        echo.
        %PYTHON_CMD% -m pip install paddleocr -i https://pypi.tuna.tsinghua.edu.cn/simple
    )
)

cd /d "%~dp0"

cd ..
echo.
echo [OK] Backend dependencies installed successfully

echo.
echo [Step 3/3] Verifying installation...
echo.

%PYTHON_CMD% -c "import fastapi" 2>nul
if %errorLevel% neq 0 (
    echo [ERROR] FastAPI verification failed
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)
echo [OK] FastAPI is installed

%PYTHON_CMD% -c "import uvicorn" 2>nul
if %errorLevel% neq 0 (
    echo [ERROR] Uvicorn verification failed
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)
echo [OK] Uvicorn is installed

%PYTHON_CMD% -c "import PIL" 2>nul
if %errorLevel% neq 0 (
    echo [ERROR] Pillow verification failed
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)
echo [OK] Pillow is installed

echo.
echo ========================================
echo Dependencies Fixed Successfully!
echo ========================================
echo.
echo You can now run start.bat to start the service
echo.
echo Press any key to exit...
pause >nul
