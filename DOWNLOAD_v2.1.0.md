# 🎉 Windows标准部署包 v2.1.0 - 下载（依赖修复版）

## 📥 直接下载链接

**文件名**：`ocr-card-recognizer-windows-standard-v2.1.0.tar.gz`

**文件大小**：140.13 KB

**版本**：v2.1.0

**有效期**：7天（2026-02-11过期）

### 🔗 下载地址

```
https://coze-coding-project.tos.coze.site/coze_storage_7602859016070627343/ocr-card-recognizer-windows-standard-v2.1.0.tar_53ca5121.gz?sign=1770806040-86d5c704d2-0-4753a1304f55e05fffa07392fa65665fb16f050dea2d83fbae6380db66c2a09b
```

---

## 🔧 v2.1.0 新增功能

### 问题：后端启动失败，提示"ModuleNotFoundError: No module named 'fastapi'"

**原因**：
- Python后端依赖（FastAPI、Uvicorn等）未安装
- install.bat可能没有正确执行
- 依赖安装过程中出现错误但未提示

**解决方案**：
✅ **新增fix-deps.bat - 一键修复依赖脚本**
- 自动检测Python环境
- 自动安装所有后端依赖
- 自动验证安装结果
- 提供详细的错误提示和解决方案

---

## 🚀 3步完成部署

### 步骤1：下载并解压（2分钟）

1. **点击上方下载链接**，开始下载
2. 使用7-Zip解压到 `C:\OCR\`
3. 确认看到backend/、src/等目录

---

### 步骤2：安装依赖（5-10分钟）

**重要：必须以管理员身份运行！**

**方式1：自动安装（推荐）⭐**
1. 右键点击 `setup.bat`
2. 选择 **"以管理员身份运行"**
3. 等待安装完成

**方式2：手动安装**
1. 右键点击 `install.bat`
2. 选择 **"以管理员身份运行"**
3. 等待安装完成

---

### 步骤3：启动服务（1分钟）

1. 双击 `start.bat`
2. 如果启动失败，运行 `fix-deps.bat`
3. 重新运行 `start.bat`
4. 访问 http://localhost:5000

✅ **完成！**

---

## 🔧 遇到问题时的解决方案

### 问题1：后端启动失败，提示"ModuleNotFoundError"

**错误信息**：
```
ModuleNotFoundError: No module named 'fastapi'
```

**解决方案**：
1. 右键点击 `fix-deps.bat`
2. 选择 **"以管理员身份运行"**
3. 等待依赖安装完成
4. 重新运行 `start.bat`

**fix-deps.bat会做什么**：
```
[Step 1/3] Checking Python installation...
Python version: Python 3.14.2
Using Python: python

[Step 2/3] Installing FastAPI and backend dependencies...
Installing dependencies from requirements.txt...

[Step 3/3] Verifying installation...
[OK] FastAPI is installed
[OK] Uvicorn is installed
[OK] Pillow is installed

Dependencies Fixed Successfully!
```

---

### 问题2：fix-deps.bat安装失败

**错误信息**：
```
[ERROR] Failed to install dependencies
```

**解决方案**：
1. 检查网络连接
2. 手动运行以下命令：
   ```cmd
   cd backend
   python -m pip install -r requirements.txt
   ```
3. 如果失败，使用国内镜像：
   ```cmd
   pip install fastapi uvicorn pillow python-multipart -i https://pypi.tuna.tsinghua.edu.cn/simple
   ```

---

### 问题3：start.bat卡在"Backend service is starting..."

**可能原因**：
1. 下载OCR模型（首次启动需要1-5分钟）
2. 后端依赖缺失
3. 后端服务启动失败

**解决方案**：
1. 查看 `logs\backend.log` 日志
2. 如果看到"ModuleNotFoundError"，运行 `fix-deps.bat`
3. 如果看到"Downloading OCR models"，继续等待
4. 如果超过5分钟，检查网络连接

---

## 📝 文件说明

### fix-deps.bat ⭐（新增）

**用途**：一键修复后端依赖问题

**运行方式**：右键 → "以管理员身份运行"

**功能**：
- 检测Python环境
- 安装FastAPI、Uvicorn、Pillow等依赖
- 验证安装结果
- 提供详细的错误提示

**适用场景**：
- 后端启动失败，提示模块缺失
- install.bat运行失败
- 依赖安装不完整

---

## 💡 完整的部署流程

### 首次部署（推荐）

1. **下载v2.1.0部署包**
   - 点击上方下载链接
   - 使用7-Zip解压到 `C:\OCR\`

2. **运行setup.bat**
   - 右键 `setup.bat` → "以管理员身份运行"
   - 等待所有依赖安装完成

3. **启动服务**
   - 双击 `start.bat`
   - 如果成功，访问 http://localhost:5000
   - 如果失败，查看问题2的解决方案

---

### 遇到依赖问题

1. **运行fix-deps.bat**
   - 右键 `fix-deps.bat` → "以管理员身份运行"
   - 等待依赖安装完成

2. **重新启动服务**
   - 双击 `start.bat`
   - 应该可以正常启动

---

## 📊 版本对比

| 版本 | 新功能/修复 | 状态 |
|------|------------|------|
| v2.0.0 - v2.0.7 | 缺少源代码 | ❌ 不完整 |
| v2.0.8 | 包含完整源代码 | ⚠️ 缺少依赖修复工具 |
| v2.0.9 | 增强诊断信息 | ⚠️ 缺少依赖修复工具 |
| v2.1.0 | 新增fix-deps.bat | ✅ 完全可用 |

---

## 🎯 总结

### 最简单的3步：

1. **下载部署包**
   - 点击上方下载链接
   - 文件：`ocr-card-recognizer-windows-standard-v2.1.0.tar.gz`

2. **安装依赖**
   - 右键 `setup.bat` → "以管理员身份运行"
   - 等待安装完成

3. **启动服务**
   - 双击 `start.bat`
   - 如果失败，运行 `fix-deps.bat`
   - 重新运行 `start.bat`
   - 访问 http://localhost:5000

---

## 🔍 当前用户的快速修复方案

如果您已经在使用v2.0.9或更早版本，遇到"ModuleNotFoundError"问题：

### 方案A：手动修复（无需重新下载）

1. **打开cmd窗口**（以管理员身份）
2. **进入部署目录**：
   ```cmd
   cd C:\CARD-OCR-LO
   ```
3. **安装依赖**：
   ```cmd
   cd backend
   python -m pip install -r requirements.txt
   ```
4. **返回根目录**：
   ```cmd
   cd ..
   ```
5. **重新启动**：
   ```cmd
   start.bat
   ```

### 方案B：下载v2.1.0（推荐）

1. 下载v2.1.0版本
2. 解压到新目录
3. 运行setup.bat
4. 如果遇到问题，运行fix-deps.bat

---

## 📦 下载信息

- **版本**：v2.1.0
- **文件大小**：140.13 KB
- **上传时间**：2026-02-04 18:33
- **有效期**：7天
- **过期时间**：2026-02-11 18:33
- **新增功能**：fix-deps.bat依赖修复脚本

---

**祝您使用愉快！🎉**

**v2.1.0版本新增fix-deps.bat，一键解决依赖问题！**
