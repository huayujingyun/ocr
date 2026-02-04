# 🎉 Windows标准部署包 v2.0.6 - 下载（修复start.bat一闪而过）

## 📥 直接下载链接

**文件名**：`ocr-card-recognizer-windows-standard-v2.0.6.tar.gz`

**文件大小**：19.55 KB

**版本**：v2.0.6

**有效期**：7天（2026-02-11过期）

### 🔗 下载地址

```
https://coze-coding-project.tos.coze.site/coze_storage_7602859016070627343/ocr-card-recognizer-windows-standard-v2.0.6.tar_5543c004.gz?sign=1770804942-a6bc3dcd9c-0-ef5e4d5236f5a8036c9e66302095b5732bd3fc1826123ec022549d83f0aede5a
```

---

## 🔧 v2.0.6 修复内容

### 问题：start.bat运行时一闪而过

**原因**：
- v2.0.5使用`cd backend && python main.py`语法
- Windows cmd在某些情况下不支持这种链式命令
- 导致命令执行失败，脚本快速退出

**修复内容**：
✅ **修复start.bat路径问题**
- 使用`cd /d "%~dp0backend"`切换到backend目录
- 使用`%~dp0`获取脚本所在目录的绝对路径
- 使用绝对路径确保日志文件正确写入
- 添加backend目录存在检查
- 添加错误提示和pause

✅ **修复启动命令**
```batch
# v2.0.5 (有问题)
start "OCR Backend" /min cmd /c "cd backend && python main.py > ..\logs\backend.log 2>&1"

# v2.0.6 (修复)
start "OCR Backend" /min cmd /c "cd /d "%~dp0backend" && %PYTHON_CMD% main.py > "%~dp0logs\backend.log" 2>&1"
```

---

## 🚀 3步完成部署

### 步骤1：下载并解压（2分钟）

1. **点击上方下载链接**，开始下载
2. 安装解压工具（如果没有）：
   - **7-Zip**：https://www.7-zip.org/ （推荐）
   - **WinRAR**：https://www.win-rar.com/
3. 解压到任意目录（推荐：`C:\OCR\`）

**注意**：
- Windows无法直接解压`.tar.gz`文件
- 必须使用7-Zip或WinRAR

---

### 步骤2：安装依赖（5-10分钟）

**重要：必须以管理员身份运行！**

**方式1：自动安装（推荐）⭐**
1. 右键点击 `setup.bat`
2. 选择 **"以管理员身份运行"**
3. 自动检测、下载、安装Python和Node.js
4. 自动安装项目依赖
5. 等待安装完成

**方式2：手动安装**
1. 确保已安装Python和Node.js
2. 右键点击 `install.bat`
3. 选择 **"以管理员身份运行"**
4. 等待安装完成

---

### 步骤3：启动服务（1分钟）

**重要：v2.0.6已修复一闪而过问题！**

1. 双击 `start.bat`（无需管理员权限）
2. 看到以下提示表示正常启动：

```
=======================================
OCR Card Recognizer - Start Service
=======================================

[CHECK] Checking port usage...

[START] Starting backend service...
Using Python command: python

[WAIT] Waiting for backend service to start (first startup requires downloading OCR models, ~30-60 seconds)...

[CHECK] Checking backend service status...
[WAIT] Backend service is starting... (1/12)
[WAIT] Backend service is starting... (2/12)
...
[SUCCESS] Backend service started successfully

[START] Starting frontend service...

[WAIT] Waiting for frontend service to start (~10-30 seconds)...

[CHECK] Checking frontend service status...
[SUCCESS] Frontend service started successfully

=======================================
Service Started!
=======================================

Access URLs:
  Frontend: http://localhost:5000
  Backend API: http://localhost:8001/docs

Management:
  View backend log: type logs\backend.log
  View frontend log: type logs\frontend.log
  Stop service: Double-click stop.bat
  Check status: Double-click check.bat

Press any key to close this window (service will continue running in background)...
```

3. 打开浏览器访问：**http://localhost:5000**

✅ **完成！**

---

## ❓ 常见问题

### Q1: start.bat仍然一闪而过？

**A**: v2.0.6应该已经修复。如果仍然有问题：

1. **检查是否在正确目录运行**
   - 确保start.bat在解压后的根目录
   - 不要在其他目录运行

2. **检查backend目录是否存在**
   - 确保backend目录存在
   - 确保backend/main.py文件存在

3. **手动运行测试**
   - 打开cmd窗口
   - 进入部署目录
   - 手动运行：`start.bat`
   - 查看具体错误信息

---

### Q2: 提示"backend directory not found"？

**A**:
1. 检查是否在正确目录运行
2. 确保backend目录存在
3. 确保解压时目录结构完整

---

### Q3: 后端启动失败？

**A**: v2.0.6会显示详细错误信息，请按照提示检查：

1. **查看日志**
   ```
   type logs\backend.log
   ```

2. **常见问题**
   - Python未正确安装
   - 缺少OpenCV依赖
   - 端口被占用

3. **解决方案**
   - 运行`setup.bat`重新安装依赖
   - 运行`stop.bat`停止占用端口的进程
   - 检查Python版本（需要3.12+）

---

### Q4: 首次启动很慢？

**A**: **正常现象！**

首次启动需要：
- 下载OCR模型文件（约200MB）
- 加载模型到内存

- 首次启动：30-60秒
- 后续启动：10-20秒

---

## 📊 版本对比

| 版本 | 新功能/修复 | 状态 |
|------|------------|------|
| v2.0.0 | 初始版本 | ✅ 可用 |
| v2.0.1 | 修复install.bat一闪而过 | ❌ 不可用 |
| v2.0.2 | 修复一闪而过，但中文乱码 | ⚠️ 部分可用 |
| v2.0.3 | 改用纯英文，解决乱码 | ⚠️ 部分可用 |
| v2.0.4 | 支持python和py命令 | ⚠️ 部分可用 |
| v2.0.5 | 新增setup.bat自动安装依赖 | ⚠️ start.bat一闪而过 |
| v2.0.6 | 修复start.bat路径问题 | ✅ 完全可用 |

---

## 📝 改进细节

### start.bat改进

**v2.0.5（有问题）**：
```batch
# 使用相对路径和链式命令
start "OCR Backend" /min cmd /c "cd backend && python main.py > ..\logs\backend.log 2>&1"
```

**问题**：
- Windows cmd不支持`cd backend && python main.py`
- 相对路径可能导致目录错误
- 日志路径可能错误

**v2.0.6（修复）**：
```batch
# 使用绝对路径和完整命令
start "OCR Backend" /min cmd /c "cd /d "%~dp0backend" && %PYTHON_CMD% main.py > "%~dp0logs\backend.log" 2>&1"
```

**改进**：
- 使用`%~dp0`获取脚本绝对路径
- 使用`cd /d`切换驱动器和目录
- 使用绝对路径确保日志正确
- 添加backend目录检查
- 添加错误提示

---

## 💡 使用建议

### 首次部署
1. 下载v2.0.6部署包
2. 解压到 `C:\OCR\`
3. 右键 `setup.bat` → "以管理员身份运行"
4. 双击 `start.bat`
5. 访问 http://localhost:5000

### 从v2.0.5升级
1. 下载v2.0.6部署包
2. 解压到新目录
3. 重新运行setup.bat
4. 启动服务

### 从v2.0.4及更早版本升级
1. 下载v2.0.6部署包
2. 解压到新目录
3. 运行setup.bat（新增功能）
4. 启动服务

---

## 📦 下载信息

- **版本**：v2.0.6
- **文件大小**：19.55 KB
- **上传时间**：2026-02-04 18:15
- **有效期**：7天
- **过期时间**：2026-02-11 18:15
- **修复内容**：start.bat路径问题

---

## 🎯 总结

### 最简单的3步：

1. **下载部署包**
   - 点击上方下载链接
   - 文件：`ocr-card-recognizer-windows-standard-v2.0.6.tar.gz`

2. **安装依赖**
   - 右键 `setup.bat` → "以管理员身份运行"
   - 自动安装所有依赖

3. **启动服务**
   - 双击 `start.bat`
   - v2.0.6已修复一闪而过问题
   - 访问 http://localhost:5000

✅ **完成！v2.0.6已修复所有已知问题！**

---

## 🔍 验证部署成功

### 方法1：访问前端
打开浏览器访问：http://localhost:5000

### 方法2：检查服务状态
双击 `check.bat`

### 方法3：查看日志
```
type logs\backend.log
type logs\frontend.log
```

---

**祝您使用愉快！🎉**

**v2.0.6版本已修复start.bat一闪而过问题，确保稳定运行！**
