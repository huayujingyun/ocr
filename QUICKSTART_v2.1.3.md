# OCR Card Recognizer - 快速启动指南

## 🚀 5分钟快速开始

### 1. 下载部署包

```
https://coze-coding-project.tos.coze.site/coze_storage_7602859016070627343/ocr-card-recognizer-windows-v2.1.3.tar_fbb696ab.gz?sign=1772796261-df39060e4b-0-7dfb925b121db795a26be418a40b56212de668b11cbeda9c68b5864afa690b8c
```

### 2. 解压到任意目录

### 3. 安装依赖（仅需一次）

**后端依赖**：
```cmd
cd backend
py -m pip install -r requirements.txt
```

**前端依赖**：
```cmd
cd ..
pnpm install
```

### 4. 构建前端

```cmd
pnpm run build
```

### 5. 启动服务

**窗口1 - 后端**：
```cmd
cd backend
py -m uvicorn main:app --host 0.0.0.0 --port 8000
```

**窗口2 - 前端**：
```cmd
pnpm run start
```

### 6. 访问应用

打开浏览器：http://localhost:5000

---

## ✅ 验证安装

运行以下命令验证安装：

```cmd
# 验证 Python
py --version
py -c "import fastapi, uvicorn, paddleocr; print('Backend OK')"

# 验证 Node.js
node --version
pnpm --version

# 验证构建
dir .next
```

---

## 📦 包含功能

- ✅ 离线 OCR 识别（PaddleOCR）
- ✅ 模板识别（更快更准）
- ✅ 条码识别支持
- ✅ 批量上传处理
- ✅ Excel 导出（含截图）
- ✅ 实时预览编辑
- ✅ 完全离线运行

---

## ⚡ 一键启动脚本

创建 `start.bat`：

```batch
@echo off
echo Starting OCR Card Recognizer...
start "OCR Backend" cmd /k "cd /d %~dp0backend && py -m uvicorn main:app --host 0.0.0.0 --port 8000"
timeout /t 3 /nobreak >nul
start "OCR Frontend" cmd /k "cd /d %~dp0 && pnpm run start"
echo.
echo Backend: http://localhost:8000
echo Frontend: http://localhost:5000
pause
```

双击运行即可！

---

## 🆘 遇到问题？

1. **Python 命令不存在** → 使用 `py` 代替 `python`
2. **端口被占用** → 改用 8001 和 5001
3. **CSS 不显示** → 清除浏览器缓存（Ctrl+Shift+R）
4. **更多帮助** → 查看 DOWNLOAD_v2.1.3.md

---

**版本**：v2.1.3  
**日期**：2026-02-04  
**状态**：✅ 已测试
