@echo off
chcp 65001 >nul
echo =====================================
echo 购物卡/加油卡OCR识别系统 - Windows安装程序
echo 版本: v2.0.1
echo =====================================
echo.

REM 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [错误] 请以管理员身份运行此脚本
    echo 右键点击 install.bat，选择"以管理员身份运行"
    echo.
    echo 按任意键退出...
    pause >nul
    exit /b 1
)

echo [步骤 1/7] 检查系统要求...
echo.

REM 检查操作系统版本
ver | findstr /i "10\.0\|6\.3\|6\.2" >nul
if %errorLevel% neq 0 (
    echo [警告] 此安装程序适用于 Windows 8/10/11
    echo 其他版本可能存在兼容性问题
) else (
    echo 操作系统: Windows 8/10/11
)

echo.
echo [步骤 2/7] 检查Python安装...
python --version >nul 2>&1
if %errorLevel% neq 0 (
    echo [错误] Python未安装
    echo.
    echo 请按以下步骤安装Python：
    echo 1. 访问: https://www.python.org/downloads/release/python-3128/
    echo 2. 下载: Windows installer (64-bit)
    echo 3. 运行安装程序
    echo 4. 重要: 勾选 "Add Python to PATH"
    echo 5. 点击 "Install Now"
    echo.
    echo 安装完成后，请重新运行此脚本
    echo.
    echo 按任意键退出...
    pause >nul
    exit /b 1
) else (
    for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
    echo Python版本: %PYTHON_VERSION%
)

echo.
echo [步骤 3/7] 检查Node.js安装...
node --version >nul 2>&1
if %errorLevel% neq 0 (
    echo [错误] Node.js未安装
    echo.
    echo 请按以下步骤安装Node.js：
    echo 1. 访问: https://nodejs.org/
    echo 2. 下载: LTS版本 (推荐 Node.js 20 LTS)
    echo 3. 运行安装程序
    echo 4. 点击 "Install" 完成安装
    echo.
    echo 安装完成后，请重新运行此脚本
    echo.
    echo 按任意键退出...
    pause >nul
    exit /b 1
) else (
    for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
    echo Node.js版本: %NODE_VERSION%
)

echo.
echo [步骤 4/7] 安装pnpm...
pnpm --version >nul 2>&1
if %errorLevel% neq 0 (
    echo 正在安装pnpm...
    npm install -g pnpm
    if %errorLevel% neq 0 (
        echo [错误] pnpm安装失败
        echo.
        echo 按任意键退出...
        pause >nul
        exit /b 1
    )
) else (
    for /f "tokens=*" %%i in ('pnpm --version') do set PNPM_VERSION=%%i
    echo pnpm已安装，版本: %PNPM_VERSION%
)

echo.
echo [步骤 5/7] 安装后端依赖...
cd backend
echo 正在检查backend目录...
if not exist "requirements.txt" (
    echo [错误] 找不到 requirements.txt 文件
    echo 请确保您在正确的目录中运行此脚本
    cd ..
    echo.
    echo 按任意键退出...
    pause >nul
    exit /b 1
)

echo 正在安装Python依赖（这可能需要几分钟）...
pip install -r requirements.txt
if %errorLevel% neq 0 (
    echo [错误] Python依赖安装失败
    echo.
    echo 可能的解决方案：
    echo 1. 检查网络连接
    echo 2. 尝试更新pip: python -m pip install --upgrade pip
    echo 3. 使用国内镜像源: pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
    echo.
    cd ..
    echo 按任意键退出...
    pause >nul
    exit /b 1
)
echo Python依赖安装完成
cd ..

echo.
echo [步骤 6/7] 安装前端依赖...
echo 正在检查前端文件...
if not exist "package.json" (
    echo [错误] 找不到 package.json 文件
    echo 请确保您在正确的目录中运行此脚本
    echo.
    echo 按任意键退出...
    pause >nul
    exit /b 1
)

echo 正在安装Node.js依赖（这可能需要几分钟）...
pnpm install
if %errorLevel% neq 0 (
    echo [错误] Node.js依赖安装失败
    echo.
    echo 可能的解决方案：
    echo 1. 检查网络连接
    echo 2. 清除缓存: pnpm store prune
    echo 3. 使用国内镜像源: pnpm config set registry https://registry.npmmirror.com
    echo.
    echo 按任意键退出...
    pause >nul
    exit /b 1
)
echo Node.js依赖安装完成

echo.
echo 正在构建前端...
pnpm run build
if %errorLevel% neq 0 (
    echo [警告] 前端构建失败
    echo 这通常不影响使用，前端将在首次启动时构建
    echo 如果后续遇到问题，请手动运行: pnpm run build
) else (
    echo 前端构建完成
)

echo.
echo [步骤 7/7] 创建必要的目录...
if not exist "logs" (
    mkdir logs
    echo 创建目录: logs\
)
if not exist "data\uploads" (
    mkdir data\uploads
    echo 创建目录: data\uploads\
)
if not exist "data\exports" (
    mkdir data\exports
    echo 创建目录: data\exports\
)

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
echo 注意事项：
echo   - 首次启动需要下载OCR模型（约200MB），请耐心等待
echo   - 首次启动可能需要30-60秒
echo   - 后续启动只需要10-20秒
echo.
echo 如果遇到问题，请查看：
echo   - logs\backend.log（后端日志）
echo   - logs\frontend.log（前端日志）
echo.
echo 按任意键退出...
pause >nul
