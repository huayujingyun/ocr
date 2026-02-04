@echo off
chcp 65001 >nul
title 停止OCR识别服务

echo =====================================
echo 停止购物卡/加油卡OCR识别服务
echo =====================================
echo.

echo [停止] 正在停止前端服务（端口5000）...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":5000" ^| findstr "LISTENING"') do (
    taskkill /F /PID %%a 2>nul
    echo 已终止PID %%a
)

echo.
echo [停止] 正在停止后端服务（端口8001）...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8001" ^| findstr "LISTENING"') do (
    taskkill /F /PID %%a 2>nul
    echo 已终止PID %%a
)

echo.
echo [清理] 清理进程残留...
taskkill /F /IM python.exe 2>nul
taskkill /F /IM node.exe 2>nul

echo.
echo =====================================
echo 服务已停止
echo =====================================
echo.
echo 按任意键退出...
pause >nul
