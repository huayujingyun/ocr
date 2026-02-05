@echo off
chcp 65001 > nul
echo ==================================
echo Starting PaddleOCR Backend...
echo ==================================
echo.

REM 禁用 oneDNN 相关功能
set PADDLE_NO_QUANTIZE_KERNEL=1
set PADDLE_DISABLE_MKLDNN=1
set PADDLE_NO_BUILTIN_KERNEL=1
set FLAGS_use_mkldnn=0

echo Environment variables set:
echo - PADDLE_NO_QUANTIZE_KERNEL=1
echo - PADDLE_DISABLE_MKLDNN=1
echo - PADDLE_NO_BUILTIN_KERNEL=1
echo - FLAGS_use_mkldnn=0
echo.

echo Starting backend server...
py -m uvicorn main:app --host 0.0.0.0 --port 8000
