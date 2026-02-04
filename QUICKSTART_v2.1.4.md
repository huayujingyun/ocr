# OCR Card Recognizer - 快速启动指南 v2.1.4

## 🚀 5分钟快速开始

### 1. 下载部署包

```
https://coze-coding-project.tos.coze.site/coze_storage_7602859016070627343/ocr-card-recognizer-windows-v2.1.4.tar_02d2b3fa.gz?sign=1772796958-ea3d82c645-0-8c704c52a804838284f09c1091617a3b5faf7a63434de3d6b4c48c9bb62591a7
```

### 2. 解压文件

解压到任意目录（如 `C:\`）

### 3. 安装依赖

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

## 🎯 使用流程

### 首次使用

1. **设置模板**
   - 点击"设置识别模板"
   - 上传卡片图片
   - 框选卡号和密码区域
   - 点击"使用此模板"

2. **上传识别**
   - 返回首页
   - 点击"上传卡片图片"
   - 选择多张图片
   - 点击"开始识别"

3. **查看结果**
   - 查看识别的卡号和密码
   - 可手动编辑
   - 导出Excel或复制

---

## ✅ 验证安装

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

- ✅ 离线 OCR 识别
- ✅ 模板识别
- ✅ 条码识别
- ✅ 批量上传
- ✅ Excel 导出
- ✅ 实时预览

---

## 🆕 v2.1.4 新增

- ✅ 修复后端API路由
- ✅ 修复图片裁剪
- ✅ 修复识别失败
- ✅ 所有功能正常

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

---

## 🆘 遇到问题？

1. **Python 命令不存在** → 使用 `py` 代替 `python`
2. **端口被占用** → 改用 8001 和 5001
3. **CSS 不显示** → 清除缓存（Ctrl+Shift+R）
4. **识别失败** → 确保后端运行且模板已设置

---

**版本**：v2.1.4  
**日期**：2026-02-04  
**状态**：✅ 功能正常
