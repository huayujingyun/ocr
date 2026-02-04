# OCR Card Recognizer - Windows 部署包下载与安装指南 v2.1.4

## 📦 下载信息

| 项目 | 信息 |
|------|------|
| **版本** | v2.1.4 |
| **发布日期** | 2026-02-04 |
| **文件名** | ocr-card-recognizer-windows-v2.1.4.tar.gz |
| **文件大小** | 136 KB |
| **有效期** | 30 天 |

---

## 🚀 一键下载

### 下载链接

```
https://coze-coding-project.tos.coze.site/coze_storage_7602859016070627343/ocr-card-recognizer-windows-v2.1.4.tar_02d2b3fa.gz?sign=1772796958-ea3d82c645-0-8c704c52a804838284f09c1091617a3b5faf7a63434de3d6b4c48c9bb62591a7
```

### PowerShell 下载

```powershell
$url = "https://coze-coding-project.tos.coze.site/coze_storage_7602859016070627343/ocr-card-recognizer-windows-v2.1.4.tar_02d2b3fa.gz?sign=1772796958-ea3d82c645-0-8c704c52a804838284f09c1091617a3b5faf7a63434de3d6b4c48c9bb62591a7"
$output = "ocr-card-recognizer-windows-v2.1.4.tar.gz"
Invoke-WebRequest -Uri $url -OutFile $output
```

---

## 🆕 v2.1.4 更新内容

### 修复的问题

1. ✅ **修复后端 API 路由不匹配**
   - 添加 `/api/ocr` 端点，兼容前端请求格式
   - 支持模板批量识别
   - 返回正确的卡号和密码格式

2. ✅ **修复图片裁剪功能**
   - 模板识别时正确裁剪图片
   - 根据模板坐标自动裁剪

3. ✅ **修复 OCR 识别失败**
   - 所有识别失败问题已解决
   - 改进错误处理和日志

4. ✅ **保留所有之前的修复**
   - Windows Python 环境冲突
   - Tailwind CSS 样式问题
   - 环境变量语法错误

---

## 📋 系统要求

| 软件 | 版本要求 | 下载地址 |
|------|----------|----------|
| **操作系统** | Windows 10/11 (64位) | - |
| **Python** | 3.12 | https://www.python.org/downloads/ |
| **Node.js** | 18+ | https://nodejs.org/ |
| **pnpm** | 最新版本 | `npm install -g pnpm` |

---

## 📝 详细安装步骤

### 步骤1：下载并解压

1. 下载部署包到任意目录（例如：`C:\`）
2. 解压 `.tar.gz` 文件

### 步骤2：安装 Python 3.12

```cmd
py --version
```

应该显示：`Python 3.12.x`

### 步骤3：安装 Node.js 和 pnpm

```cmd
node --version
npm install -g pnpm
pnpm --version
```

### 步骤4：安装后端依赖

```cmd
cd ocr-card-recognizer-windows-v2.1.4\backend
py -m pip install -r requirements.txt
```

**验证安装**：

```cmd
py -c "import fastapi, uvicorn, paddleocr; print('All dependencies installed successfully')"
```

### 步骤5：安装前端依赖

```cmd
cd ..
pnpm install
```

### 步骤6：构建前端

```cmd
pnpm run build
```

---

## 🚀 启动服务

### 方式1：手动启动（推荐）

**窗口1 - 启动后端服务**：

```cmd
cd ocr-card-recognizer-windows-v2.1.4\backend
py -m uvicorn main:app --host 0.0.0.0 --port 8000
```

等待看到：
```
INFO:     Uvicorn running on http://0.0.0.0:8000
```

**窗口2 - 启动前端服务**：

```cmd
cd ocr-card-recognizer-windows-v2.1.4
pnpm run start
```

等待看到：
```
▲ Next.js 16.x.x
- Local:        http://localhost:5000
```

### 方式2：使用启动脚本

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

## 🌐 访问应用

打开浏览器，访问：**http://localhost:5000**

### 使用流程

1. **设置模板**（首次使用）
   - 点击"设置识别模板"
   - 上传一张卡片图片
   - 框选卡号和密码区域
   - 点击"使用此模板"

2. **上传图片识别**
   - 点击"上传卡片图片"
   - 选择多张图片
   - 点击"开始识别"

3. **查看和编辑结果**
   - 查看识别的卡号和密码
   - 可手动编辑
   - 支持复制和导出Excel

---

## ⚠️ 常见问题

### Q: 上传图片后没有裁剪？

A: 确保已完成以下步骤：
1. 访问 `/template` 页面设置模板
2. 框选卡号和密码区域
3. 点击"使用此模板"按钮
4. 模板保存在 sessionStorage 中

### Q: 识别失败？

A: 检查以下几点：
1. 后端服务是否在 8000 端口运行
2. 打开浏览器控制台（F12）查看错误
3. 检查后端日志
4. 确认模板已正确设置

### Q: CSS 不显示？

A:
1. 清除浏览器缓存（Ctrl+Shift+Delete）
2. 强制刷新（Ctrl+Shift+R）
3. 重新构建：`pnpm run build`

### Q: Python 命令不存在？

A: 使用 `py` 代替 `python`

---

## 📚 包含功能

- ✅ 离线 OCR 识别（PaddleOCR）
- ✅ 模板识别（更快更准）
- ✅ 条码识别支持
- ✅ 批量上传处理
- ✅ Excel 导出（含截图）
- ✅ 实时预览编辑
- ✅ 完全离线运行
- ✅ 修复所有已知问题

---

## 📄 版本历史

| 版本 | 日期 | 更新内容 |
|------|------|----------|
| v2.1.4 | 2026-02-04 | 修复后端API、图片裁剪、OCR识别 |
| v2.1.3 | 2026-02-04 | 修复Windows兼容性和样式问题 |
| v2.1.2 | 2026-02-04 | 初始Windows部署包 |

---

**最后更新**：2026-02-04  
**版本**：v2.1.4  
**状态**：✅ 已测试，功能正常
