# OCR Card Recognizer - v2.1.5（最终版）

> 离线购物卡/加油卡 OCR 识别系统 - Windows 平台稳定版

**推荐：使用静默模式，电脑不卡顿！**

---

## 🚀 3分钟快速开始

### 1. 下载链接

```
https://coze-coding-project.tos.coze.site/coze_storage_7602859016070627343/ocr-card-recognizer-windows-v2.1.5.tar_6d4f00a0.gz?sign=1772859892-1df6f0b828-0-c2c62a1e47d76609a0896b3934ef3a11d1022ffaffcdec575e1e40562b556e3e
```

### 2. 解压文件

解压到任意目录（建议：`C:\CARD-OCR-LO\`）

### 3. 安装依赖

```cmd
cd backend
install.bat

cd ..
pnpm install
```

### 4. 构建前端

```cmd
pnpm run build
```

### 5. 启动服务（推荐方式）

双击运行 `start-silent.bat`，选择模式 `1`（静默模式）

### 6. 访问应用

打开浏览器：**http://localhost:5000**

---

## 🎯 核心功能

- ✅ **离线 OCR 识别**：无需联网，本地识别
- ✅ **模板识别**：自定义卡号和密码区域
- ✅ **条码识别**：支持二维码和条形码
- ✅ **批量上传**：一次上传多张图片
- ✅ **Excel 导出**：导出卡号和密码
- ✅ **实时预览**：查看识别结果并编辑

---

## 🚀 启动方式对比

| 方式 | 命令 | 电脑卡顿 | 推荐场景 |
|------|------|---------|---------|
| **静默模式** | `start-silent.bat` 选择 `1` | ❌ 不卡 | ✅ 日常使用 |
| **详细模式** | `start-silent.bat` 选择 `2` | ⚠️ 可能卡 | 调试问题 |
| **传统方式** | `start.bat` | ⚠️ 可能卡 | 不推荐 |

**推荐使用静默模式（模式 1）！**

---

## ⚡ 快速命令

### 启动后端（静默模式）
```cmd
cd backend
start-backend-silent.bat
```

### 停止后端
```cmd
cd backend
stop-backend.bat
```

### 启动前端
```cmd
pnpm run start
```

---

## ⚠️ 重要提示

### 必须使用指定版本

**⚠️ 不要手动修改 PaddlePaddle 或 PaddleOCR 版本！**

- PaddlePaddle: 2.6.2（必须）
- PaddleOCR: 2.8.0（必须）

### 使用正确的启动脚本

**推荐使用 `start-silent.bat` 启动服务！**

选择模式 `1`（静默模式）：
- 后端在后台运行
- 不占用终端窗口
- 电脑不卡顿
- 适合长时间使用

---

## 🆘 常见问题

### 1. 电脑卡顿

**解决方案**：使用静默模式
```cmd
start-silent.bat
```
选择模式 `1`

### 2. OCR 识别失败

**检查版本**：
```cmd
py -c "import paddle; print(f'PaddlePaddle: {paddle.__version__}')"
py -c "import paddleocr; print(f'PaddleOCR: {paddleocr.__version__}')"
```

**重新安装依赖**：
```cmd
cd backend
py -m pip uninstall paddlepaddle paddleocr -y
py -m pip install "paddlepaddle==2.6.2"
py -m pip install "paddleocr==2.8.0"
```

### 3. 查看后端日志

```cmd
type backend\backend.log | more
```

---

## 📚 详细文档

- `USAGE.md` - 快速使用指南
- `docs/QUICKSTART_v2.1.5.md` - 快速开始
- `docs/CHANGELOG_v2.1.5.md` - 更新日志
- `docs/SILENT_MODE.md` - 后台运行详细指南
- `docs/DOWNLOAD_FINAL.md` - 下载指南

---

## 📊 系统要求

| 软件 | 版本 | 下载 |
|------|------|------|
| Python | 3.12 | https://www.python.org/downloads/ |
| Node.js | 18+ | https://nodejs.org/ |
| pnpm | 8+ | `npm install -g pnpm` |
| Windows | 10/11 | - |

---

## 🔒 隐私安全

- ✅ 完全离线运行，无需联网
- ✅ 所有数据在本地处理
- ✅ 不上传任何图片或信息
- ✅ 密码区域自动遮罩保护

---

**版本**: v2.1.5（最终版）  
**状态**: ✅ Windows 平台稳定版  
**大小**: 145 KB  
**有效期**: 30 天  
**发布日期**: 2026-02-05  

**推荐：使用静默模式，电脑不卡顿！**
