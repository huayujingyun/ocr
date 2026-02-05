# OCR Card Recognizer - 快速启动指南 v2.1.5

## 🚀 5分钟快速开始

### 1. 下载部署包

```
https://coze-coding-project.tos.coze.site/coze_storage_7602859016070627343/ocr-card-recognizer-windows-v2.1.4.tar_02d2b3fa.gz?sign=1772796958-ea3d82c645-0-8c704c52a804838284f09c1091617a3b5faf7a63434de3d6b4c48c9bb62591a7
```

### 2. 解压文件

解压到任意目录（如 `C:\CARD-OCR-LO`）

### 3. 安装依赖

**后端依赖（重要：必须安装指定版本）**：
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

**窗口1 - 后端（使用修复后的启动脚本）**：
```cmd
cd backend
start-backend-fixed.bat
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
py -c "import fastapi, uvicorn, paddleocr, paddle; print('Backend OK')"

# 验证版本（重要）
py -c "import paddle; print(f'PaddlePaddle: {paddle.__version__}')"
py -c "import paddleocr; print(f'PaddleOCR: {paddleocr.__version__}')"

# 验证 Node.js
node --version
pnpm --version

# 验证构建
dir .next
```

---

## ⚠️ 重要版本说明

### Windows 平台必须使用的版本组合

| 组件 | 版本 | 说明 |
|------|------|------|
| PaddlePaddle | 2.6.2 | ⚠️ 必须使用此版本 |
| PaddleOCR | 2.8.0 | ⚠️ 必须使用此版本 |
| Python | 3.12 | 推荐版本 |

### 已知问题

**问题1：PaddlePaddle 3.x 版本在 Windows 上会出现 oneDNN 错误**
```
ERROR: ConvertPirAttribute2RuntimeAttribute not support
```
**解决方案**：使用 `start-backend-fixed.bat` 启动，或降级到 2.6.2

**问题2：PaddleOCR 3.4.0 与 PaddlePaddle 2.6.2 不兼容**
```
ERROR: 'AnalysisConfig' object has no attribute 'set_optimization_level'
```
**解决方案**：安装 PaddleOCR 2.8.0

### 手动修复依赖版本

如果遇到版本问题，请手动安装：
```cmd
cd backend
py -m pip uninstall paddlepaddle paddleocr -y
py -m pip install "paddlepaddle==2.6.2"
py -m pip install "paddleocr==2.8.0"
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

## 🆕 v2.1.5 新增

- ✅ 修复 PaddlePaddle 3.x 兼容性问题
- ✅ 固定依赖版本到稳定组合
- ✅ 添加版本验证步骤
- ✅ 添加手动修复依赖指南
- ✅ 添加一键安装脚本

---

## ⚡ 一键启动脚本

### 完整启动脚本（推荐）

创建 `start.bat`：

```batch
@echo off
chcp 65001 > nul
echo ==================================
echo Starting OCR Card Recognizer...
echo ==================================
echo.

echo [1/2] Starting Backend...
start "OCR Backend" cmd /k "cd /d %~dp0backend && start-backend-fixed.bat"

echo [2/2] Waiting for backend to start...
timeout /t 5 /nobreak >nul

echo Starting Frontend...
start "OCR Frontend" cmd /k "cd /d %~dp0 && pnpm run start"

echo.
echo ==================================
echo Services Started:
echo ==================================
echo Backend:  http://localhost:8000
echo Frontend: http://localhost:5000
echo.
echo Press any key to exit this window...
echo.
pause
```

---

## 🆘 遇到问题？

### 常见问题

1. **Python 命令不存在** → 使用 `py` 代替 `python`
2. **端口被占用** → 改用 8001 和 5001
3. **CSS 不显示** → 清除缓存（Ctrl+Shift+R）
4. **识别失败** → 确保后端运行且模板已设置

### OCR 识别失败

**症状**：
```
ERROR: OCR识别失败: ...
```

**检查步骤**：
1. 确认后端服务运行正常（访问 http://localhost:8000/health）
2. 检查依赖版本：
   ```cmd
   py -c "import paddle; print(f'PaddlePaddle: {paddle.__version__}')"
   py -c "import paddleocr; print(f'PaddleOCR: {paddleocr.__version__}')"
   ```
3. 如果版本不正确，手动修复依赖（见上方"手动修复依赖版本"）

### 安装失败

**症状**：
```
ERROR: Failed to install dependencies
```

**解决方案**：
1. 使用 `install.bat` 脚本安装：
   ```cmd
   cd backend
   install.bat
   ```
2. 或者手动安装：
   ```cmd
   py -m pip install -r requirements.txt
   ```

---

## 📝 技术支持

- **版本**：v2.1.5
- **日期**：2026-02-05
- **状态**：✅ Windows 平台验证通过

---

**推荐配置**：
- Python 3.12
- PaddlePaddle 2.6.2
- PaddleOCR 2.8.0
- Node.js 24
- Windows 10/11
