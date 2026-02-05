# OCR Card Recognizer - v2.1.5 下载指南

## 📦 完整部署包下载链接

### 版本信息
- **版本号**: v2.1.5
- **发布日期**: 2026-02-05
- **文件大小**: 140 KB
- **平台**: Windows 10/11
- **有效期**: 30 天

### 下载链接

```
https://coze-coding-project.tos.coze.site/coze_storage_7602859016070627343/ocr-card-recognizer-windows-v2.1.5.tar_4ae8a3ed.gz?sign=1772858667-6d1d3501e8-0-710c760300349e7c3a1dd13e66454f8a6d721d4632f6dcd61a258f001c00bfb0
```

### 备用下载方式

如果上述链接无法下载，请尝试以下方法：

1. **右键另存为**: 复制链接到浏览器地址栏，右键选择"另存为"
2. **使用下载工具**: 使用 IDM、迅雷等下载工具
3. **命令行下载** (curl):
   ```cmd
   curl -L -o ocr-card-recognizer-windows-v2.1.5.tar.gz "https://coze-coding-project.tos.coze.site/coze_storage_7602859016070627343/ocr-card-recognizer-windows-v2.1.5.tar_4ae8a3ed.gz?sign=1772858667-6d1d3501e8-0-710c760300349e7c3a1dd13e66454f8a6d721d4632f6dcd61a258f001c00bfb0"
   ```

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

**启动后端** (使用修复后的启动脚本):
```cmd
cd backend
start-backend-fixed.bat
```

**启动前端** (新开一个终端窗口):
```cmd
cd ..
pnpm run start
```

### 6. 访问应用

打开浏览器访问: **http://localhost:5000**

---

## 🎯 主要功能

- ✅ **离线 OCR 识别**: 无需联网，本地识别
- ✅ **模板识别**: 自定义卡号和密码区域
- ✅ **条码识别**: 支持二维码和条形码
- ✅ **批量上传**: 一次上传多张图片
- ✅ **Excel 导出**: 导出卡号和密码到 Excel
- ✅ **实时预览**: 查看识别结果并编辑

---

## 🔧 v2.1.5 重要更新

### 修复 PaddlePaddle/PaddleOCR 版本兼容性问题

**问题**: Windows 平台上 PaddlePaddle 3.x + PaddleOCR 3.4.0 组合出现严重错误

**解决方案**:
- ✅ PaddlePaddle: 降级到 2.6.2
- ✅ PaddleOCR: 降级到 2.8.0
- ✅ 添加 install.bat 自动安装脚本
- ✅ 添加 start-backend-fixed.bat 启动脚本
- ✅ 完全修复 OCR 识别失败问题

### 版本兼容性

| 组件 | 版本 | 状态 |
|------|------|------|
| Python | 3.12 | ✅ 推荐版本 |
| PaddlePaddle | 2.6.2 | ✅ 必须使用此版本 |
| PaddleOCR | 2.8.0 | ✅ 必须使用此版本 |
| Node.js | 18+ | ✅ 测试通过 |
| Windows | 10/11 | ✅ 测试通过 |

### 已知不兼容组合

| PaddlePaddle | PaddleOCR | 状态 |
|--------------|-----------|------|
| 3.3.0 | 3.4.0 | ❌ oneDNN 错误 |
| 3.x | 2.8.0 | ❌ API 不兼容 |
| 2.6.2 | 3.4.0 | ❌ set_optimization_level |

---

## 📚 详细文档

解压后请查看以下文档：

- `README.md` - 主文档
- `docs/QUICKSTART_v2.1.5.md` - 快速开始指南
- `docs/CHANGELOG_v2.1.5.md` - 完整更新日志
- `VERSION.txt` - 版本信息

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

### 识别性能

- 首次识别: ~5-10 秒（模型加载）
- 单张识别: ~1-2 秒
- 批量识别（10张）: ~10 秒

---

## 🆘 常见问题

### 1. 下载失败

**解决方案**:
- 复制链接到浏览器直接下载
- 使用下载工具（IDM、迅雷）
- 检查网络连接

### 2. 解压失败

**解决方案**:
- 确保下载完整（文件大小应约为 140KB）
- 使用 7-Zip 或 WinRAR 解压
- 如果文件损坏，请重新下载

### 3. Python 命令不存在

**解决方案**:
- 使用 `py` 代替 `python` 命令
- 重新安装 Python 3.12
- 检查是否勾选了 "Add Python to PATH"

### 4. OCR 识别失败

**解决方案**:
1. 检查依赖版本:
   ```cmd
   py -c "import paddle; print(f'PaddlePaddle: {paddle.__version__}')"
   py -c "import paddleocr; print(f'PaddleOCR: {paddleocr.__version__}')"
   ```
2. 确保版本为 2.6.2 和 2.8.0
3. 使用 `start-backend-fixed.bat` 启动后端
4. 重新安装依赖:
   ```cmd
   cd backend
   py -m pip uninstall paddlepaddle paddleocr -y
   py -m pip install "paddlepaddle==2.6.2"
   py -m pip install "paddleocr==2.8.0"
   ```

### 5. 前端无法连接后端

**解决方案**:
- 确认后端服务正在运行
- 访问 http://localhost:8000/health 检查后端健康状态
- 确认端口 8000 和 5000 未被占用

### 6. CSS 样式不显示

**解决方案**:
- 清除浏览器缓存（Ctrl+Shift+R）
- 确保已运行 `pnpm run build`
- 检查控制台是否有错误

---

## 📞 技术支持

如遇到其他问题，请：
1. 查看详细文档：`docs/QUICKSTART_v2.1.5.md`
2. 检查更新日志：`docs/CHANGELOG_v2.1.5.md`
3. 验证系统要求和依赖版本

---

## 📝 更新记录

### v2.1.5 (2026-02-05)

**修复**:
- 修复 PaddlePaddle 3.x 在 Windows 上的 oneDNN 兼容性问题
- 修复 PaddleOCR 3.4.0 与 PaddlePaddle 2.6.2 的 API 不兼容问题
- 降级到稳定版本组合：PaddlePaddle 2.6.2 + PaddleOCR 2.8.0

**新增**:
- 添加 install.bat 一键安装脚本
- 添加 start-backend-fixed.bat 启动脚本
- 添加版本验证和兼容性指南

**优化**:
- 修复前端 API 端口配置
- 更新所有文档

---

**版本**: v2.1.5
**状态**: ✅ Windows 平台稳定版
**下载链接**: 见上方
**有效期**: 30 天
