@echo off
chcp 65001 >nul
echo =====================================
echo 购物卡/加油卡OCR识别系统 - Windows安装程序
echo =====================================
echo.

REM 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [错误] 请以管理员身份运行此脚本
    echo 右键点击 install.bat，选择"以管理员身份运行"
    pause
    exit /b 1
)

echo [步骤 1/7] 检查系统要求...
echo.

REM 检查操作系统版本
ver | findstr /i "10\.0" >nul
if %errorLevel% neq 0 (
    echo [警告] 此安装程序适用于 Windows 10/11
    echo 其他版本可能存在兼容性问题
)

REM 检查内存
systeminfo | findstr /C:"Total Physical Memory" > temp_mem.txt
set /p MEMORY=<temp_mem.txt
del temp_mem.txt
echo 系统内存: %MEMORY%

echo.
echo [步骤 2/7] 检查Python安装...
python --version >nul 2>&1
if %errorLevel% neq 0 (
    echo Python未安装，正在下载Python 3.12...
    echo 请手动下载并安装Python: https://www.python.org/downloads/release/python-3128/
    echo 安装时请勾选 "Add Python to PATH"
    pause
    exit /b 1
) else (
    for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
    echo Python版本: %PYTHON_VERSION%
)

echo.
echo [步骤 3/7] 检查Node.js安装...
node --version >nul 2>&1
if %errorLevel% neq 0 (
    echo Node.js未安装，正在下载Node.js...
    echo 请手动下载并安装Node.js: https://nodejs.org/
    echo 建议版本: Node.js 20 LTS 或更高
    pause
    exit /b 1
) else (
    for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
    echo Node.js版本: %NODE_VERSION%
)

echo.
echo [步骤 4/7] 安装pnpm...
npm install -g pnpm

echo.
echo [步骤 5/7] 安装后端依赖...
cd backend
echo 正在安装Python依赖...
pip install -r requirements.txt
if %errorLevel% neq 0 (
    echo [错误] Python依赖安装失败
    pause
    exit /b 1
)
echo Python依赖安装完成
cd ..

echo.
echo [步骤 6/7] 安装前端依赖...
cd frontend
echo 正在安装Node.js依赖...
pnpm install
if %errorLevel% neq 0 (
    echo [错误] Node.js依赖安装失败
    pause
    exit /b 1
)
echo Node.js依赖安装完成

echo 正在构建前端...
pnpm run build
if %errorLevel% neq 0 (
    echo [警告] 前端构建失败，将在首次启动时构建
)
cd ..

echo.
echo [步骤 7/7] 创建必要的目录...
if not exist "logs" mkdir logs
if not exist "data\uploads" mkdir data\uploads
if not exist "data\exports" mkdir data\exports

echo.
echo =====================================
echo 安装完成！
echo =====================================
echo.
echo 使用说明：
echo   1. 双击 start.bat 启动服务
echo   2. 双击 stop.bat 停止服务
echo   3. 双击 check.bat 检查服务状态
echo   4. 访问 http://localhost:5000 使用系统
echo.
echo 按任意键退出...
pause >nul
