@echo off
chcp 65001 >nul 2>&1
title Card OCR System - Package Deployment
color 0E

echo.
echo ==========================================
echo  Card OCR System - Package Deployment
echo ==========================================
echo.

echo This script will package the deployment files.
echo.

set "VERSION=1.0.0"
set "PACKAGE_NAME=card-ocr-deployment-%VERSION%"
set "ARCHIVE_NAME=%PACKAGE_NAME%.tar.gz"

echo Version: %VERSION%
echo Package Name: %PACKAGE_NAME%
echo Archive Name: %ARCHIVE_NAME%
echo.

echo Creating package directory...
if exist "%PACKAGE_NAME%" rd /s /q "%PACKAGE_NAME%"
mkdir "%PACKAGE_NAME%"

echo Copying files...
xcopy /E /I /Y /EXCLUDE:exclude.txt . "%PACKAGE_NAME%" >nul 2>&1

echo Packaging...
tar -czf "%ARCHIVE_NAME%" "%PACKAGE_NAME%"

if %errorLevel% equ 0 (
    echo.
    echo [OK] Package created successfully: %ARCHIVE_NAME%
    echo.
    echo Size:
    dir "%ARCHIVE_NAME%" | find "%ARCHIVE_NAME%"
) else (
    echo.
    echo [ERROR] Package creation failed!
    echo.
)

echo.
echo Cleaning up...
rd /s /q "%PACKAGE_NAME%"

echo.
echo ==========================================
echo.

pause
