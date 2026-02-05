# OCR Card Recognizer - Windows Deployment Package v2.1.5

> 离线购物卡/加油卡 OCR 识别系统 - Windows 平台稳定版

[![Version](https://img.shields.io/badge/version-v2.1.5-green.svg)](https://github.com)
[![Platform](https://img.shields.io/badge/platform-Windows-blue.svg)](https://www.microsoft.com/windows)
[![Python](https://img.shields.io/badge/python-3.12-yellow.svg)](https://www.python.org)
[![Status](https://img.shields.io/badge/status-stable-success.svg)]()

---

## 📦 快速开始

### 1. 下载链接

```
https://coze-coding-project.tos.coze.site/coze_storage_7602859016070627343/ocr-card-recognizer-windows-v2.1.5.tar_4ae8a3ed.gz?sign=1772858667-6d1d3501e8-0-710c760300349e7c3a1dd13e66454f8a6d721d4632f6dcd61a258f001c00bfb0
```

详见：`DOWNLOAD_v2.1.5.md`

### 2. 解压文件

解压到任意目录（建议：`C:\CARD-OCR-LO\`）

### 3. 安装依赖

**后端依赖**：
```cmd
cd backend
install.bat
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

**方式一：一键启动（推荐）**
```cmd
start.bat
```

**方式二：分别启动**

**窗口1 - 后端**：
```cmd
cd backend
start-backend-fixed.bat
```

**窗口2 - 前端**：
```cmd
pnpm run start
```

### 6. 访问应用

打开浏览器：**http://localhost:5000**

---

## 🎯 主要功能

| 功能 | 描述 |
|------|------|
| ✅ 离线 OCR 识别 | 无需联网，本地识别，保护隐私 |
| ✅ 模板识别 | 自定义卡号和密码区域，提高准确率 |
| ✅ 条码识别 | 支持二维码和条形码识别 |
| ✅ 批量上传 | 一次上传多张图片，自动识别 |
| ✅ Excel 导出 | 导出卡号和密码到 Excel 文件 |
| ✅ 实时预览 | 查看识别结果，支持手动编辑 |
| ✅ 密码遮罩 | 保护敏感信息安全 |

---

## 🔧 系统要求

### 必需软件

| 软件 | 版本 | 下载链接 |
|------|------|----------|
| Python | 3.12 | https://www.python.org/downloads/ |
| Node.js | 18+ | https://nodejs.org/ |
| pnpm | 8+ | `npm install -g pnpm` |
| Windows | 10/11 | - |

### 依赖版本

| 组件 | 版本 | 说明 |
|------|------|------|
| PaddlePaddle | 2.6.2 | ⚠️ 必须使用此版本 |
| PaddleOCR | 2.8.0 | ⚠️ 必须使用此版本 |

### 硬件要求

- CPU: 双核及以上
- 内存: 4GB 及以上
- 硬盘: 2GB 可用空间

---

## 📂 目录结构

```
ocr-card-recognizer-windows-v2.1.5/
├── src/                      # 前端源代码
│   ├── app/                  # Next.js 应用
│   ├── components/           # React 组件
│   └── lib/                  # 工具函数
├── backend/                  # 后端源代码
│   ├── main.py              # FastAPI 应用
│   ├── ocr_service.py       # OCR 服务
│   ├── install.bat          # 安装脚本
│   ├── start-backend-fixed.bat  # 启动脚本
│   └── requirements.txt     # Python 依赖
├── docs/                     # 文档
│   ├── QUICKSTART_v2.1.5.md # 快速开始
│   └── CHANGELOG_v2.1.5.md  # 更新日志
├── start.bat                 # 一键启动脚本
├── package.json              # Node.js 依赖
├── .coze                     # Coze CLI 配置
└── README.md                 # 本文档
```

---

## 🆕 v2.1.5 更新内容

### 🔥 重大修复

**修复 Windows 平台 OCR 识别失败问题**

**问题**：
- PaddlePaddle 3.x + PaddleOCR 3.4.0 组合在 Windows 上出现严重兼容性问题
- oneDNN 错误导致识别失败
- API 不兼容导致初始化失败

**解决方案**：
- ✅ 降级 PaddlePaddle 到 2.6.2（稳定版本）
- ✅ 降级 PaddleOCR 到 2.8.0（稳定版本）
- ✅ 添加 install.bat 自动安装脚本
- ✅ 添加 start-backend-fixed.bat 启动脚本
- ✅ 完全修复 OCR 识别失败问题

### 📝 新增功能

- 一键启动脚本 `start.bat`
- 自动安装脚本 `install.bat`
- 版本兼容性文档
- 详细的故障排查指南

### 🔧 优化改进

- 修复前端 API 端口配置
- 更新所有文档
- 添加版本验证步骤

---

## ⚠️ 重要提示

### 必须使用指定版本

**⚠️ 不要手动修改 PaddlePaddle 或 PaddleOCR 版本！**

版本 2.1.5 已经将依赖版本固定为：
- `paddlepaddle==2.6.2`
- `paddleocr==2.8.0`

这是 Windows 平台上唯一稳定的版本组合。

### 使用正确的启动脚本

**必须使用 `start-backend-fixed.bat` 启动后端服务！**

此脚本包含了所有必要的配置：
- 禁用 oneDNN 功能（避免兼容性问题）
- 设置正确的环境变量
- 提供详细的启动日志

---

## 🚀 使用流程

### 首次使用

1. **设置识别模板**
   - 点击"设置识别模板"
   - 上传一张卡片图片
   - 框选卡号和密码区域
   - 点击"使用此模板"保存

2. **上传识别**
   - 返回首页
   - 点击"上传卡片图片"
   - 选择多张图片（支持拖拽）
   - 点击"开始识别"

3. **查看结果**
   - 查看识别的卡号和密码
   - 可手动编辑错误信息
   - 点击"导出Excel"或"复制到剪贴板"

### 识别模式

- **模板识别**：使用预定义的区域框选，识别速度快，准确率高
- **传统 OCR**：识别整张图片，然后提取卡号和密码
- **条码识别**：识别二维码和条形码

---

## 🆘 常见问题

### 1. 下载失败

**解决方案**：
- 复制链接到浏览器直接下载
- 使用下载工具（IDM、迅雷）
- 检查网络连接

详见：`DOWNLOAD_v2.1.5.md`

### 2. 依赖安装失败

**解决方案**：
```cmd
cd backend
install.bat
```

如果失败，手动安装：
```cmd
py -m pip install -r requirements.txt
```

### 3. Python 命令不存在

**解决方案**：
- 使用 `py` 代替 `python` 命令
- 重新安装 Python 3.12
- 检查是否勾选了 "Add Python to PATH"

### 4. OCR 识别失败

**检查步骤**：

1. 验证版本：
   ```cmd
   py -c "import paddle; print(f'PaddlePaddle: {paddle.__version__}')"
   py -c "import paddleocr; print(f'PaddleOCR: {paddleocr.__version__}')"
   ```

2. 确保版本为 2.6.2 和 2.8.0

3. 重新安装依赖：
   ```cmd
   cd backend
   py -m pip uninstall paddlepaddle paddleocr -y
   py -m pip install "paddlepaddle==2.6.2"
   py -m pip install "paddleocr==2.8.0"
   ```

4. 使用正确的启动脚本：
   ```cmd
   start-backend-fixed.bat
   ```

### 5. 前端无法连接后端

**解决方案**：
- 确认后端服务正在运行
- 访问 http://localhost:8000/health 检查后端健康状态
- 确认端口 8000 和 5000 未被占用

### 6. CSS 样式不显示

**解决方案**：
- 清除浏览器缓存（Ctrl+Shift+R）
- 确保已运行 `pnpm run build`
- 检查控制台是否有错误

---

## 📚 详细文档

- `DOWNLOAD_v2.1.5.md` - 下载指南
- `docs/QUICKSTART_v2.1.5.md` - 快速开始
- `docs/CHANGELOG_v2.1.5.md` - 更新日志
- `VERSION.txt` - 版本信息

---

## 📊 性能指标

| 操作 | 耗时 |
|------|------|
| 首次初始化 | ~5-10 秒 |
| 单张识别 | ~1-2 秒 |
| 批量识别（10张） | ~10 秒 |
| Excel 导出 | ~1 秒 |

---

## 🔒 隐私安全

- ✅ 完全离线运行，无需联网
- ✅ 所有数据在本地处理
- ✅ 不上传任何图片或信息
- ✅ 密码区域自动遮罩保护

---

## 📝 更新历史

### v2.1.5 (2026-02-05)

**修复**：
- 修复 PaddlePaddle 3.x 在 Windows 上的 oneDNN 兼容性问题
- 修复 PaddleOCR 3.4.0 与 PaddlePaddle 2.6.2 的 API 不兼容问题
- 降级到稳定版本组合：PaddlePaddle 2.6.2 + PaddleOCR 2.8.0

**新增**：
- 添加 install.bat 一键安装脚本
- 添加 start-backend-fixed.bat 启动脚本
- 添加 start.bat 一键启动脚本
- 添加版本验证和兼容性指南

**优化**：
- 修复前端 API 端口配置
- 更新所有文档

---

## 📞 技术支持

如遇到其他问题，请：
1. 查看 `docs/QUICKSTART_v2.1.5.md`
2. 检查 `docs/CHANGELOG_v2.1.5.md`
3. 验证系统要求和依赖版本

---

## 📄 许可证

本项目仅供学习和个人使用。

---

## 🙏 致谢

感谢以下开源项目：

- PaddleOCR - https://github.com/PaddlePaddle/PaddleOCR
- PaddlePaddle - https://github.com/PaddlePaddle/Paddle
- Next.js - https://nextjs.org/
- FastAPI - https://fastapi.tiangolo.com/

---

**版本**: v2.1.5
**状态**: ✅ Windows 平台稳定版
**日期**: 2026-02-05
