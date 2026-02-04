@echo off
chcp 65001 >nul
title 打包部署文件
color 0B

echo.
echo ==========================================
echo  打包部署文件
echo ==========================================
echo.

set PACKAGE_NAME=card-ocr-deployment
set VERSION=1.0.0
set PACKAGE_FILE=%PACKAGE_NAME%-v%VERSION%.zip

echo 包名: %PACKAGE_FILE%
echo 版本: %VERSION%
echo.

REM 检查7-Zip是否安装
where 7z >nul 2>&1
if %errorLevel% equ 0 (
    echo [✓] 检测到7-Zip，将使用7-Zip打包
    set USE_7ZIP=1
) else (
    echo [!] 未检测到7-Zip，将使用PowerShell打包
    set USE_7ZIP=0
)

echo.
echo 正在打包文件...
echo.

REM 创建临时目录
set TEMP_DIR=%TEMP%\%PACKAGE_NAME%-package
if exist "%TEMP_DIR%" rmdir /s /q "%TEMP_DIR%"
mkdir "%TEMP_DIR%"

REM 复制必要文件
echo 复制文件...
xcopy install.bat "%TEMP_DIR%\" /Y >nul
xcopy start.bat "%TEMP_DIR%\" /Y >nul
xcopy stop.bat "%TEMP_DIR%\" /Y >nul
xcopy status.bat "%TEMP_DIR%\" /Y >nul
xcopy check-deps.bat "%TEMP_DIR%\" /Y >nul
xcopy docker-compose.yml "%TEMP_DIR%\" /Y >nul
xcopy README.md "%TEMP_DIR%\" /Y >nul

REM 复制后端文件
echo 复制后端文件...
xcopy backend "%TEMP_DIR%\backend\" /E /I /Y >nul

REM 复制前端文件
echo 复制前端文件...
xcopy frontend "%TEMP_DIR%\frontend\" /E /I /Y /EXCLUDE:exclude.txt >nul 2>&1

REM 复制配置文件
echo 复制配置文件...
xcopy config "%TEMP_DIR%\config\" /E /I /Y >nul 2>&1

REM 复制文档
echo 复制文档...
mkdir "%TEMP_DIR%\docs" >nul 2>&1
copy docs\DEPLOYMENT_GUIDE.md "%TEMP_DIR%\docs\" /Y >nul 2>&1
copy docs\USER_MANUAL.md "%TEMP_DIR%\docs\" /Y >nul 2>&1
copy docs\TROUBLESHOOTING.md "%TEMP_DIR%\docs\" /Y >nul 2>&1

echo.
echo 正在压缩...
echo.

REM 打包
if "%USE_7ZIP%"=="1" (
    7z a -tzip "%PACKAGE_FILE%" "%TEMP_DIR%\*" -mx9
) else (
    powershell -Command "Compress-Archive -Path '%TEMP_DIR%\*' -DestinationPath '%PACKAGE_FILE%' -Force"
)

if %errorLevel% neq 0 (
    echo.
    echo [错误] 打包失败！
    pause
    exit /b 1
)

REM 清理临时目录
rmdir /s /q "%TEMP_DIR%"

echo.
echo ==========================================
echo  打包完成！
echo ==========================================
echo.
echo 文件: %PACKAGE_FILE%
echo 大小:
for %%F in ("%PACKAGE_FILE%") do (
    echo       %%~zF 字节
    set SIZE=%%~zF
)
echo.
echo 文件已保存到当前目录。
echo.

REM 计算大小（MB）
set /a SIZE_MB=%SIZE% / 1048576
echo 约大小: %SIZE_MB% MB
echo.

REM 询问是否打开文件夹
set /p OPEN_DIR=是否打开文件夹？(Y/N):
if /i "%OPEN_DIR%"=="Y" (
    explorer .
)

echo.
echo 提示：
echo   - 将此压缩文件发送给用户
echo   - 用户解压后运行 install.bat 即可安装
echo.

pause
