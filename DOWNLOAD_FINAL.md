# OCR Card Recognizer v2.1.5 - 下载指南（最终版）

## 📦 完整部署包下载链接

### 版本信息
- **版本号**: v2.1.5（最终版）
- **发布日期**: 2026-02-05
- **文件大小**: 145 KB
- **平台**: Windows 10/11
- **有效期**: 30 天

### 下载链接

```
https://coze-coding-project.tos.coze.site/coze_storage_7602859016070627343/ocr-card-recognizer-windows-v2.1.5.tar_6d4f00a0.gz?sign=1772859892-1df6f0b828-0-c2c62a1e47d76609a0896b3934ef3a11d1022ffaffcdec575e1e40562b556e3e
```

### 备用下载方式

如果上述链接无法下载，请尝试以下方法：

1. **右键另存为**: 复制链接到浏览器地址栏，右键选择"另存为"
2. **使用下载工具**: 使用 IDM、迅雷等下载工具
3. **命令行下载** (curl):
   ```cmd
   curl -L -o ocr-card-recognizer-windows-v2.1.5.tar.gz "下载链接"
   ```

---

## 🎯 v2.1.5 最终版功能

### ✅ 核心功能
- 离线 OCR 识别（无需联网）
- 模板识别（自定义卡号和密码区域）
- 条码识别（二维码和条形码）
- 批量上传（一次上传多张图片）
- Excel 导出（导出卡号和密码）
- 实时预览（查看识别结果并编辑）

### 🚀 新增：后台运行模式（解决卡顿问题）

**问题**：运行过程中电脑很卡，终端不断打印日志

**解决方案**：
- ✅ 后端在后台运行，不占用终端
- ✅ 日志输出到文件，不影响性能
- ✅ 电脑不卡顿，适合长时间使用

### 🔧 启动方式

#### 推荐方式：静默模式（不卡电脑）

1. 双击运行 `start-silent.bat`
2. 选择模式 `1`（静默模式）
3. 等待服务启动
4. 浏览器自动打开

**优点**：
- ✅ 后端在后台运行
- ✅ 不占用终端窗口
- ✅ 电脑不卡顿
- ✅ 适合长时间使用

#### 停止后端服务

```cmd
cd backend
stop-backend.bat
```

#### 查看后端日志

```cmd
type backend\backend.log | more
```

---

## 📂 包含内容

### 项目文件
- ✅ 完整的前端源代码
- ✅ 完整的后端源代码
- ✅ 所有配置文件
- ✅ 依赖定义文件

### 脚本工具
- ✅ `start-silent.bat` - 一键启动脚本（支持静默和详细模式）
- ✅ `start.bat` - 传统启动脚本（带性能警告）
- ✅ `backend/install.bat` - 依赖安装脚本
- ✅ `backend/start-backend-fixed.bat` - 后端启动脚本（详细模式）
- ✅ `backend/start-backend-silent.bat` - 后端启动脚本（静默模式）
- ✅ `backend/stop-backend.bat` - 停止后端脚本

### 文档
- ✅ `README.md` - 完整使用说明
- ✅ `USAGE.md` - 快速使用指南
- ✅ `docs/QUICKSTART_v2.1.5.md` - 快速开始指南
- ✅ `docs/CHANGELOG_v2.1.5.md` - 详细更新日志
- ✅ `docs/SILENT_MODE.md` - 后台运行详细指南
- ✅ `docs/DOWNLOAD_v2.1.5.md` - 本下载指南

---

## 🚀 快速安装指南

### 1. 下载和解压

1. 点击上述下载链接下载文件
2. 下载完成后，右键点击文件选择"解压到..."
3. 解压到任意目录（建议：`C:\CARD-OCR-LO\`）

### 2. 系统要求检查

**必需软件**:
- ✅ Python 3.12
- ✅ Node.js 18+
- ✅ pnpm 包管理器

**安装方式**:
```cmd
# 安装 Python
# 访问 https://www.python.org/downloads/
# 下载 Python 3.12 安装包，安装时勾选 "Add Python to PATH"

# 安装 Node.js
# 访问 https://nodejs.org/
# 下载 LTS 版本安装包

# 安装 pnpm
npm install -g pnpm
```

### 3. 安装依赖

**安装后端依赖** (使用一键安装脚本):
```cmd
cd backend
install.bat
```

**安装前端依赖**:
```cmd
cd ..
pnpm install
```

### 4. 构建前端

```cmd
pnpm run build
```

### 5. 启动服务

**方式一：静默模式（推荐，不卡电脑）**

双击运行 `start-silent.bat`，选择模式 `1`

**方式二：详细日志模式**

双击运行 `start-silent.bat`，选择模式 `2`

**方式三：传统方式**

双击运行 `start.bat`（可能会有卡顿）

### 6. 访问应用

打开浏览器：**http://localhost:5000**

---

## 🎯 使用流程

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

## 🔧 v2.1.5 修复和优化

### 🔥 重大修复

**修复 Windows 平台 OCR 识别失败问题**

**问题**：
- PaddlePaddle 3.x + PaddleOCR 3.4.0 组合在 Windows 上出现严重兼容性问题
- oneDNN 错误导致识别失败
- API 不兼容导致初始化失败

**解决方案**：
- ✅ 降级 PaddlePaddle 到 2.6.2（稳定版本）
- ✅ 降级 PaddleOCR 到 2.8.0（稳定版本）
- ✅ 完全修复 OCR 识别失败问题

### 🚀 性能优化

**添加后台运行模式，解决日志输出导致的卡顿问题**

**问题**：
- 运行过程中电脑很卡
- 终端窗口不断打印日志
- 大量日志输出导致性能下降

**解决方案**：
- ✅ 后端在后台运行，不占用终端
- ✅ 日志输出到文件，不影响性能
- ✅ 优化批量识别日志输出
- ✅ 电脑不卡顿，适合长时间使用

### 📝 版本兼容性

| 组件 | 版本 | 状态 | 说明 |
|------|------|------|------|
| Python | 3.12 | ✅ 推荐版本 | 官方支持 |
| PaddlePaddle | 2.6.2 | ✅ 必须使用 | 稳定版本 |
| PaddleOCR | 2.8.0 | ✅ 必须使用 | 稳定版本 |
| Node.js | 18+ | ✅ 测试通过 | 需安装 pnpm |
| Windows | 10/11 | ✅ 测试通过 | 主要平台 |

### 已知不兼容组合

| PaddlePaddle | PaddleOCR | 状态 | 错误 |
|--------------|-----------|------|------|
| 3.3.0 | 3.4.0 | ❌ | oneDNN 错误 |
| 3.x | 2.8.0 | ❌ | API 不兼容 |
| 2.6.2 | 3.4.0 | ❌ | set_optimization_level |

---

## ⚠️ 重要提示

### 必须使用指定版本

**⚠️ 不要手动修改 PaddlePaddle 或 PaddleOCR 版本！**

版本 2.1.5 已经将依赖版本固定为：
- `paddlepaddle==2.6.2`
- `paddleocr==2.8.0`

这是 Windows 平台上唯一稳定的版本组合。

### 使用正确的启动脚本

**推荐使用 `start-silent.bat` 启动服务！**

选择模式 `1`（静默模式）：
- 后端在后台运行
- 不占用终端窗口
- 电脑不卡顿
- 适合长时间使用

---

## 🆘 常见问题

### 1. 下载失败

**解决方案**：
- 复制链接到浏览器直接下载
- 使用下载工具（IDM、迅雷）
- 检查网络连接

### 2. 解压失败

**解决方案**：
- 确保下载完整（文件大小应约为 145KB）
- 使用 7-Zip 或 WinRAR 解压
- 如果文件损坏，请重新下载

### 3. 依赖安装失败

**解决方案**：
```cmd
cd backend
install.bat
```

如果失败，手动安装：
```cmd
py -m pip install -r requirements.txt
```

### 4. Python 命令不存在

**解决方案**：
- 使用 `py` 代替 `python` 命令
- 重新安装 Python 3.12
- 检查是否勾选了 "Add Python to PATH"

### 5. OCR 识别失败

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
   start-silent.bat
   ```

### 6. 电脑卡顿

**解决方案**：

1. 停止当前服务
2. 使用静默模式重新启动：
   ```cmd
   start-silent.bat
   ```
3. 选择模式 `1`（静默模式）

### 7. 前端无法连接后端

**解决方案**：
- 确认后端服务正在运行
- 访问 http://localhost:8000/health 检查后端健康状态
- 确认端口 8000 和 5000 未被占用

---

## 📊 性能指标

| 操作 | 耗时 | 说明 |
|------|------|------|
| 首次初始化 | ~5-10 秒 | 模型加载 |
| 单张识别 | ~1-2 秒 | CPU 模式 |
| 批量识别（10张） | ~10 秒 | 批量处理 |
| Excel 导出 | ~1 秒 | 快速导出 |

**注意**：使用静默模式可以减少 CPU 占用，提升性能。

---

## 🔒 隐私安全

- ✅ 完全离线运行，无需联网
- ✅ 所有数据在本地处理
- ✅ 不上传任何图片或信息
- ✅ 密码区域自动遮罩保护

---

## 📚 详细文档

- `README.md` - 完整使用说明
- `USAGE.md` - 快速使用指南
- `docs/QUICKSTART_v2.1.5.md` - 快速开始
- `docs/CHANGELOG_v2.1.5.md` - 更新日志
- `docs/SILENT_MODE.md` - 后台运行详细指南
- `VERSION.txt` - 版本信息

---

## 📝 更新记录

### v2.1.5 (2026-02-05) - 最终版

**修复**：
- 修复 PaddlePaddle 3.x 在 Windows 上的 oneDNN 兼容性问题
- 修复 PaddleOCR 3.4.0 与 PaddlePaddle 2.6.2 的 API 不兼容问题
- 降级到稳定版本组合：PaddlePaddle 2.6.2 + PaddleOCR 2.8.0

**新增**：
- 添加后台运行模式（解决卡顿问题）
- 添加 start-silent.bat 一键启动脚本
- 添加 start-backend-silent.bat 后端启动脚本
- 添加 stop-backend.bat 停止脚本
- 添加 install.bat 一键安装脚本
- 添加版本验证和兼容性指南

**优化**：
- 优化批量识别日志输出
- 修复前端 API 端口配置
- 更新所有文档

---

## 📞 技术支持

如遇到其他问题，请：
1. 查看 `docs/SILENT_MODE.md` - 后台运行指南
2. 查看 `docs/QUICKSTART_v2.1.5.md` - 快速开始
3. 检查 `docs/CHANGELOG_v2.1.5.md` - 更新日志
4. 验证系统要求和依赖版本

---

## 📦 下载链接（最终版）

```
https://coze-coding-project.tos.coze.site/coze_storage_7602859016070627343/ocr-card-recognizer-windows-v2.1.5.tar_6d4f00a0.gz?sign=1772859892-1df6f0b828-0-c2c62a1e47d76609a0896b3934ef3a11d1022ffaffcdec575e1e40562b556e3e
```

---

**版本**: v2.1.5（最终版）
**状态**: ✅ Windows 平台稳定版
**大小**: 145 KB
**有效期**: 30 天
**发布日期**: 2026-02-05
**推荐**: 使用静默模式，电脑不卡顿！
