# 🎉 Windows标准部署包 - 现在可用！

## 📦 部署包信息

**文件名**：`ocr-card-recognizer-windows-standard-v2.0.0.tar.gz`

**文件大小**：138KB

**版本**：v2.0.0

**部署方式**：标准部署（最简单，无需Docker）

---

## 🚀 如何获取部署包？

### 方式1：从GitHub Release下载（推荐）

1. 访问：https://github.com/huayujingyun/ocr/releases
2. 找到 v2.0.0 版本
3. 下载：`ocr-card-recognizer-windows-standard-v2.0.0.tar.gz`

### 方式2：从项目目录获取

部署包文件已生成在项目根目录：
```
./ocr-card-recognizer-windows-standard-v2.0.0.tar.gz
```

---

## 📋 部署包内容

### 包含文件

✅ **部署脚本**
- install.bat - 安装脚本
- start.bat - 启动脚本
- stop.bat - 停止脚本
- check.bat - 检查脚本

✅ **文档**
- README.txt - 快速说明
- README.md - 完整指南
- QUICKSTART.md - 快速开始

✅ **后端**
- backend/ - Python后端源代码
- requirements.txt - Python依赖列表

✅ **前端**
- src/ - React前端源代码
- package.json - Node.js依赖配置

✅ **配置**
- .env.example - 环境变量模板
- tsconfig.json - TypeScript配置

✅ **目录**
- logs/ - 日志目录
- data/uploads/ - 上传目录
- data/exports/ - 导出目录

---

## ⚡ 3步完成部署

### 步骤1：下载并解压（2分钟）

1. 下载 `ocr-card-recognizer-windows-standard-v2.0.0.tar.gz`
2. 安装解压工具（如果没有）：
   - **7-Zip**：https://www.7-zip.org/
   - 或 **WinRAR**：https://www.win-rar.com/
3. 解压到任意目录（推荐：`C:\OCR\`）

**注意**：Windows无法直接解压tar.gz文件，需要使用7-Zip或WinRAR

---

### 步骤2：安装依赖（5-10分钟）

1. 右键点击 `install.bat`
2. 选择 **"以管理员身份运行"**
3. 看到黑色窗口弹出，显示安装进度
4. 等待安装完成（首次需要下载Python、Node.js和OCR模型）

**安装内容**：
- ✅ Python 3.12（如果未安装）
- ✅ Node.js（如果未安装）
- ✅ 后端依赖（PaddleOCR、FastAPI等）
- ✅ 前端依赖（Next.js、React等）
- ✅ OCR模型文件（约200MB）

**安装成功的标志**：
```
========================================
安装完成！
========================================
现在可以双击 start.bat 启动服务
访问地址：http://localhost:5000
========================================
```

---

### 步骤3：启动服务（1分钟）

1. 双击 `start.bat`（无需管理员权限）
2. 等待30-60秒（首次启动需要加载OCR模型）
3. 看到以下提示表示启动成功：

```
========================================
服务已启动！
========================================
前端地址：http://localhost:5000
后端地址：http://localhost:8001
========================================
```

4. 打开浏览器访问：**http://localhost:5000**

✅ **完成！**

---

## 🎮 快速使用指南

### 1️⃣ 上传图片

1. 打开浏览器访问 http://localhost:5000
2. 点击 **"上传图片"** 按钮
3. 选择购物卡或加油卡图片
4. 支持多张图片同时上传（最多10张）

### 2️⃣ 识别卡片

**方法A：自动识别**
- 直接点击 **"开始识别"** 按钮
- 系统自动识别卡号和密码

**方法B：模板识别（推荐，更准确）**
1. 点击 **"设置识别模板"**
2. 上传一张标准卡片图片
3. 用鼠标框选卡号区域
4. 用鼠标框选密码区域
5. 保存模板
6. 点击 **"开始识别"**

### 3️⃣ 编辑结果

- 查看识别结果
- 如有错误，直接修改卡号或密码
- 点击 **"重新识别"** 重新识别

### 4️⃣ 导出结果

- **导出文档**：生成文本文件
- **导出Excel**：生成Excel文件（包含密码图片）

---

## 🛠️ 管理服务

### 启动服务
```
双击：start.bat
```

### 停止服务
```
双击：stop.bat
```

### 检查状态
```
双击：check.bat
```

### 查看日志
```
打开：logs\backend.log
```

---

## ❓ 常见问题

### Q1: 无法解压tar.gz文件？

**A**:
- Windows无法直接解压tar.gz
- 下载 **7-Zip**：https://www.7-zip.org/
- 或下载 **WinRAR**：https://www.win-rar.com/

### Q2: 双击install.bat没反应？

**A**:
1. 右键点击 `install.bat`
2. 选择 **"以管理员身份运行"**
3. 点击 **"是"**

### Q3: 提示Python未安装？

**A**:
1. 访问：https://www.python.org/downloads/release/python-3128/
2. 下载 **"Windows installer (64-bit)"**
3. 运行安装程序
4. **重要**：勾选 **"Add Python to PATH"**
5. 点击 **"Install Now"**
6. 重新运行 `install.bat`

### Q4: 端口5000或8001被占用？

**A**:
1. 双击 `stop.bat` 停止现有服务
2. 重新双击 `start.bat`
3. 如果还不行，重启电脑

### Q5: 首次启动很慢？

**A**: **正常现象！**

首次启动需要：
- 下载OCR模型文件（约200MB）
- 加载模型到内存

- 首次启动：30-60秒
- 后续启动：10-20秒

### Q6: 识别结果不准确？

**A**:
1. 使用模板识别模式（推荐）
2. 使用高清图片
3. 确保卡片水平放置
4. 光线充足

---

## 📊 系统要求

### 最低配置
- Windows 10/11 64位
- 4GB 内存
- 2GB 可用磁盘空间
- 管理员权限

### 推荐配置
- Windows 10/11 64位
- 8GB 内存
- 5GB 可用磁盘空间
- 7-Zip或WinRAR（用于解压）

---

## 💡 使用技巧

### 优化识别准确率
1. 使用模板识别模式
2. 使用高清图片（建议300dpi以上）
3. 确保卡片水平放置
4. 光线充足，避免阴影

### 提高识别速度
1. 减少同时上传的图片数量（建议5张以内）
2. 使用模板识别模式（比自动识别快）
3. 关闭不必要的程序释放内存

### 确保数据安全
1. 定期备份识别结果
2. 不要在公共电脑上使用
3. 识别完成后及时删除原始图片

---

## 📖 详细文档

解压部署包后，可以查看以下文档：

- **README.txt** - 快速说明
- **README.md** - 完整部署指南
- **QUICKSTART.md** - 快速开始指南
- **DEPLOYMENT_PACKAGE_DOWNLOAD.md** - 下载说明

---

## 🎉 完成后的功能

现在您可以：

- ✅ 自动识别购物卡和加油卡
- ✅ 批量处理，提高效率
- ✅ 导出Excel，方便整理
- ✅ 完全离线，数据安全
- ✅ 无需联网，随时使用
- ✅ 支持模板识别，提高准确率

**访问地址：http://localhost:5000**

---

## 🔄 更新说明

如果将来需要更新：

1. 下载最新版本的部署包
2. 备份现有数据（识别结果）
3. 解压新版本覆盖现有文件
4. 重新运行 `install.bat`
5. 启动服务

---

## 📞 获取帮助

### 检查服务状态
```
双击：check.bat
```

### 查看日志
```
打开：logs\backend.log
```

### 在线文档
- GitHub仓库：https://github.com/huayujingyun/ocr
- GitHub Issues：https://github.com/huayujingyun/ocr/issues

---

## 🎯 总结

### 最简单的3步：

1. **下载部署包**
   - 访问GitHub Releases
   - 下载 `ocr-card-recognizer-windows-standard-v2.0.0.tar.gz`

2. **安装依赖**
   - 解压到 `C:\OCR\`
   - 右键 `install.bat` → "以管理员身份运行"

3. **启动服务**
   - 双击 `start.bat`
   - 访问 http://localhost:5000

✅ **完成！开始使用吧！**

---

**祝您使用愉快！🎉**
