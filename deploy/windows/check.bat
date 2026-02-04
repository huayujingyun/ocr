@echo off
chcp 65001 >nul
title 服务状态检查

echo =====================================
echo 服务状态检查
echo =====================================
echo.

echo [检查] 后端服务（端口8001）...
netstat -ano | findstr ":8001" | findstr "LISTENING" >nul
if %errorLevel% equ 0 (
    echo [运行中] 后端服务
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8001" ^| findstr "LISTENING"') do (
        echo         进程ID: %%a
        tasklist /FI "PID eq %%a" /FO TABLE /NH
    )
    echo.
    curl -s http://localhost:8001/health
    echo.
) else (
    echo [停止] 后端服务
)

echo.
echo [检查] 前端服务（端口5000）...
netstat -ano | findstr ":5000" | findstr "LISTENING" >nul
if %errorLevel% equ 0 (
    echo [运行中] 前端服务
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":5000" ^| findstr "LISTENING"') do (
        echo         进程ID: %%a
        tasklist /FI "PID eq %%a" /FO TABLE /NH
    )
    echo         访问地址: http://localhost:5000
) else (
    echo [停止] 前端服务
)

echo.
echo =====================================
echo 按任意键退出...
pause >nul
