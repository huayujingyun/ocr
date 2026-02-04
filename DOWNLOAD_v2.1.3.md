# OCR Card Recognizer - Windows 部署包下载与安装指南 v2.1.3

## 📦 下载信息

| 项目 | 信息 |
|------|------|
| **版本** | v2.1.3 |
| **发布日期** | 2026-02-04 |
| **文件名** | ocr-card-recognizer-windows-v2.1.3.tar.gz |
| **文件大小** | 132 KB |
| **有效期** | 30 天 |

---

## 🚀 一键下载

点击以下链接直接下载部署包：

### 下载链接

```
https://coze-coding-project.tos.coze.site/coze_storage_7602859016070627343/ocr-card-recognizer-windows-v2.1.3.tar_fbb696ab.gz?sign=1772796261-df39060e4b-0-7dfb925b121db795a26be418a40b56212de668b11cbeda9c68b5864afa690b8c
```

### 备用下载方式

如果上述链接无法访问，请尝试以下方式：

1. **复制链接到浏览器下载**
2. **使用下载工具**（如 IDM、迅雷等）
3. **使用命令行工具**（参考下方）

### Windows PowerShell 下载

打开 PowerShell，运行以下命令：

```powershell
$url = "https://coze-coding-project.tos.coze.site/coze_storage_7602859016070627343/ocr-card-recognizer-windows-v2.1.3.tar_fbb696ab.gz?sign=1772796261-df39060e4b-0-7dfb925b121db795a26be418a40b56212de668b11cbeda9c68b5864afa690b8c"
$output = "ocr-card-recognizer-windows-v2.1.3.tar.gz"
Invoke-WebRequest -Uri $url -OutFile $output
```

---

## 📋 v2.1.3 更新内容

### 修复的问题

1. ✅ **修复 Windows Python 环境冲突**
   - 优先使用 `py` 命令调用真实的 Python 3.12
   - 解决 Windows Store Python 的 PATH 冲突问题

2. ✅ **修复 Tailwind CSS 样式加载问题**
   - 降级到稳定的 Tailwind CSS 3.4.19 版本
   - 解决生产构建时 CSS 文件名不匹配问题
   - 确保所有样式正确加载和显示

3. ✅ **修复 Windows 环境变量语法问题**
   - 修复 `PORT=5000` Unix 语法在 Windows 下不兼容的问题
   - 改为使用命令行参数 `-p 5000`

4. ✅ **优化依赖安装**
   - 使用官方 PyPI 源，避免镜像源兼容性问题
   - 所有依赖已测试并验证

---

## 🔧 系统要求

### 必需软件

| 软件 | 版本要求 | 下载地址 |
|------|----------|----------|
| **操作系统** | Windows 10/11 (64位) | - |
| **Python** | 3.12 | https://www.python.org/downloads/ |
| **Node.js** | 18+ | https://nodejs.org/ |
| **pnpm** | 最新版本 | `npm install -g pnpm` |
| **Git** (可选) | 最新版本 | https://git-scm.com/ |

### 推荐配置

- **内存**：至少 4GB RAM（推荐 8GB+）
- **磁盘空间**：至少 2GB 可用空间
- **网络**：首次安装需要网络（下载依赖）

---

## 📝 详细安装步骤

### 步骤1：下载并解压

1. 下载部署包到任意目录（例如：`C:\`）
2. 解压 `.tar.gz` 文件
   - Windows 11：右键点击文件 → "全部提取"
   - 或使用工具：7-Zip、WinRAR 等

解压后的目录结构：
```
ocr-card-recognizer-windows-v2.1.3/
├── src/                      # 前端源码
├── backend/                  # 后端源码
├── docs/                     # 文档
├── package.json              # Node.js 依赖
├── requirements.txt          # Python 依赖（在backend目录）
├── README_PACKAGING.md       # 打包说明
└── VERSION.txt               # 版本信息
```

### 步骤2：安装 Python 3.12

1. 访问 https://www.python.org/downloads/
2. 下载 Python 3.12.x Windows installer (64-bit)
3. 运行安装程序
   - **重要**：勾选 "Add Python to PATH"
   - 选择 "Install Now" 或 "Customize installation"
4. 验证安装：打开命令提示符（CMD），运行：

```cmd
py --version
```

应该显示：`Python 3.12.x`

### 步骤3：安装 Node.js 和 pnpm

1. 访问 https://nodejs.org/
2. 下载 LTS 版本（推荐 Node.js 20.x）
3. 运行安装程序，按默认选项完成安装
4. 验证 Node.js 安装：

```cmd
node --version
```

5. 安装 pnpm：

```cmd
npm install -g pnpm
```

6. 验证 pnpm 安装：

```cmd
pnpm --version
```

### 步骤4：安装后端依赖

打开命令提示符（CMD），进入项目目录：

```cmd
cd C:\ocr-card-recognizer-windows-v2.1.3\backend
```

安装 Python 依赖（使用官方 PyPI 源）：

```cmd
py -m pip install -r requirements.txt
```

等待安装完成（可能需要几分钟）。

**验证安装**：

```cmd
py -c "import fastapi, uvicorn, paddleocr; print('All dependencies installed successfully')"
```

如果显示 "All dependencies installed successfully"，说明安装成功。

### 步骤5：安装前端依赖

返回项目根目录：

```cmd
cd ..
```

安装 Node.js 依赖：

```cmd
pnpm install
```

等待安装完成。

**验证安装**：检查是否生成了 `node_modules` 目录。

### 步骤6：构建前端

```cmd
pnpm run build
```

等待构建完成（约 1-2 分钟）。

**验证构建**：检查是否生成了 `.next` 目录。

---

## 🚀 启动服务

### 方式1：手动启动（推荐）

打开**两个命令提示符窗口**：

#### 窗口1 - 启动后端服务

```cmd
cd C:\ocr-card-recognizer-windows-v2.1.3\backend
py -m uvicorn main:app --host 0.0.0.0 --port 8000
```

等待看到：
```
INFO:     Started server process [xxxx]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     Uvicorn running on http://0.0.0.0:8000
```

**保持此窗口打开，不要关闭！**

#### 窗口2 - 启动前端服务

打开新的命令提示符窗口：

```cmd
cd C:\ocr-card-recognizer-windows-v2.1.3
pnpm run start
```

等待看到：
```
▲ Next.js 16.x.x
- Local:        http://localhost:5000
- Ready in xxx ms
```

**保持此窗口打开，不要关闭！**

### 方式2：使用启动脚本

创建 `start.bat` 文件：

```batch
@echo off
echo Starting OCR Card Recognizer...
echo.

REM Start backend
start "OCR Backend" cmd /k "cd /d %~dp0backend && py -m uvicorn main:app --host 0.0.0.0 --port 8000"

REM Wait for backend to start
timeout /t 3 /nobreak >nul

REM Start frontend
start "OCR Frontend" cmd /k "cd /d %~dp0 && pnpm run start"

echo.
echo Backend: http://localhost:8000
echo Frontend: http://localhost:5000
echo.
pause
```

双击 `start.bat` 即可启动服务。

---

## 🌐 访问应用

打开浏览器，访问：

**http://localhost:5000**

### 首次使用

1. 点击 "设置识别模板" 创建识别模板
2. 或直接点击 "上传卡片图片" 开始识别
3. 支持批量上传多张图片
4. 识别完成后可以：
   - 复制单个或全部结果
   - 导出 Excel 文件（包含密码截图）
   - 手动编辑识别结果

---

## ⚠️ 常见问题与解决方案

### 问题1：Python 命令不可用

**症状**：
```
'python' 不是内部或外部命令
```

**解决方案**：
使用 `py` 命令代替 `python`：

```cmd
py --version
py -m pip install ...
```

### 问题2：端口已被占用

**症状**：
```
OSError: [WinError 10048] 通常每个套接字地址只允许使用一次
```

**解决方案**：
更改端口号：

**后端**：
```cmd
py -m uvicorn main:app --host 0.0.0.0 --port 8001
```

**前端**（修改 `package.json`）：
```json
"start": "next start -p 5001"
```

### 问题3：CSS 样式不显示

**症状**：界面显示混乱，图标很大

**解决方案**：
1. 清除浏览器缓存（Ctrl+Shift+Delete）
2. 强制刷新（Ctrl+Shift+R）
3. 检查 `.next` 目录是否存在，重新构建：

```cmd
pnpm run build
```

### 问题4：PaddleOCR 下载慢

**症状**：依赖安装时卡在 downloading paddleocr

**解决方案**：
使用国内镜像源（清华大学）：

```cmd
py -m pip install paddleocr -i https://pypi.tuna.tsinghua.edu.cn/simple
```

### 问题5：pnpm 安装失败

**症状**：
```
pnpm: command not found
```

**解决方案**：
1. 确保已安装 Node.js
2. 重新安装 pnpm：

```cmd
npm install -g pnpm
```

3. 重启命令提示符

---

## 🛠️ 卸载方法

1. 停止服务（关闭所有命令提示符窗口）
2. 删除项目目录：

```cmd
rmdir /s /q C:\ocr-card-recognizer-windows-v2.1.3
```

3. 卸载 Python、Node.js（可选）

---

## 📚 更多信息

- **项目主页**：查看 README.md
- **技术文档**：查看 docs/ 目录
- **版本历史**：查看 VERSION.txt

---

## 💡 使用技巧

### 1. 批量识别

- 可以一次性上传多张图片
- 识别速度取决于图片数量和模板设置
- 使用模板识别可以大幅提升速度

### 2. 模板识别

- 首次使用建议先设置识别模板
- 模板支持混合模式（OCR + 条码识别）
- 模板保存在浏览器 sessionStorage 中

### 3. Excel 导出

- 导出的 Excel 包含序号、卡号、密码、密码截图
- 密码图片与数据行精确对应
- 支持手动编辑后再导出

---

## 🆘 技术支持

如果遇到问题：

1. 查看本文档的常见问题部分
2. 检查控制台错误信息（F12）
3. 查看后端日志（启动后端的命令提示符窗口）
4. 确保所有依赖正确安装

---

## 📄 许可证

本项目由 Coze Coding Expert 开发，仅供学习和个人使用。

---

**最后更新**：2026-02-04  
**版本**：v2.1.3  
**状态**：✅ 已测试，可正常使用
