# 🎉 Windows标准部署包 v2.1.2 - 下载（cd命令修复版）

## 📥 直接下载链接

**文件名**：`ocr-card-recognizer-windows-standard-v2.1.2.tar.gz`

**文件大小**：140.28 KB

**版本**：v2.1.2

**有效期**：7天（2026-02-11过期）

### 🔗 下载地址

```
https://coze-coding-project.tos.coze.site/coze_storage_7602859016070627343/ocr-card-recognizer-windows-standard-v2.1.2.tar_eeabb12d.gz?sign=1770806399-d52e7d73d3-0-d312ea1ced43b6a69ae200ec0f357a41b650d7d74234af0b594807490198098f
```

---

## 🔧 v2.1.2 修复内容

### 问题：fix-deps.bat提示"系统找不到指定的路径"

**错误信息**：
```
系统找不到指定的路径。
[ERROR] requirements.txt not found in backend directory
```

**原因**：
- fix-deps.bat和install.bat使用了`cd backend`命令
- 在Windows批处理中，`cd backend`可能无法正确切换目录
- 需要使用`cd /d`命令来切换驱动器和目录

**解决方案**：
✅ **修复cd命令**
- 将`cd backend`改为`cd /d "%~dp0backend"`
- 将`cd ..`改为`cd /d "%~dp0"`
- 使用绝对路径确保目录切换成功
- 添加详细的错误提示

---

## 🚀 当前用户的快速修复方案（无需重新下载）

如果您已经在使用v2.1.1或更早版本，遇到cd命令问题：

### 步骤1：继续安装依赖（FastAPI已安装）

从您的输出看，FastAPI已经成功安装了。现在需要安装PaddleOCR等其他依赖。

### 步骤2：手动安装PaddleOCR依赖

打开cmd窗口（以管理员身份），运行：

```cmd
cd C:\CARD-OCR-LO\backend
python -m pip install paddleocr opencv-python-headless pillow numpy pydantic pydantic-settings python-dotenv
cd ..
```

**如果安装失败，使用国内镜像**：
```cmd
cd C:\CARD-OCR-LO\backend
python -m pip install paddleocr -i https://pypi.tuna.tsinghua.edu.cn/simple
python -m pip install opencv-python-headless pillow numpy pydantic pydantic-settings python-dotenv -i https://pypi.tuna.tsinghua.edu.cn/simple
cd ..
```

### 步骤3：启动服务

```cmd
start.bat
```

---

## 🎯 或者下载v2.1.2版本（推荐）

### 步骤1：下载并解压

1. 点击上方下载链接
2. 使用7-Zip解压到 `C:\OCR\`

### 步骤2：运行setup.bat

1. 右键 `setup.bat` → "以管理员身份运行"
2. 等待安装完成

### 步骤3：如果遇到问题，运行fix-deps.bat

1. 右键 `fix-deps.bat` → "以管理员身份运行"
2. 等待依赖安装完成

**修复后的fix-deps.bat**：
```
[INFO] Now in directory: C:\OCR\ocr-card-recognizer\backend

Installing dependencies from requirements.txt...
[OK] Backend dependencies installed successfully
```

### 步骤4：启动服务

1. 双击 `start.bat`
2. 访问 http://localhost:5000

---

## 📊 版本对比

| 版本 | 修复内容 | 状态 |
|------|---------|------|
| v2.0.0 - v2.0.7 | 缺少源代码 | ❌ 不完整 |
| v2.0.8 | 包含完整源代码 | ⚠️ cd命令问题 |
| v2.0.9 | 增强诊断信息 | ⚠️ cd命令问题 |
| v2.1.0 | 新增fix-deps.bat | ⚠️ cd命令问题 |
| v2.1.1 | 修复requirements.txt版本号 | ⚠️ cd命令问题 |
| v2.1.2 | 修复cd命令问题 | ✅ 完全可用 |

---

## 💡 改进详情

### fix-deps.bat改进

**v2.1.1（有问题）**：
```batch
cd backend
if exist "requirements.txt" (
    ...
)
cd ..
```

**问题**：
- ❌ `cd backend`可能无法切换目录
- ❌ `cd ..`可能返回错误的目录

**v2.1.2（修复）**：
```batch
cd /d "%~dp0backend"
if %errorLevel% neq 0 (
    echo [ERROR] Cannot change to backend directory
    echo Current directory: %CD%
    echo Trying: cd /d "%~dp0backend"
    exit /b 1
)
...
cd /d "%~dp0"
```

**改进**：
- ✅ 使用`cd /d`切换驱动器和目录
- ✅ 使用绝对路径`%~dp0backend`
- ✅ 添加错误检测和详细提示
- ✅ 使用`cd /d "%~dp0"`返回脚本目录

### install.bat改进

同样修复了install.bat中的cd命令问题。

---

## ❓ 常见问题

### Q1: fix-deps.bat提示"系统找不到指定的路径"？

**A**: 这是cd命令的问题，已修复。请下载v2.1.2版本或手动安装依赖。

### Q2: FastAPI已经安装，但PaddleOCR安装失败？

**A**: 按照上述步骤手动安装PaddleOCR依赖。

### Q3: pip安装速度慢？

**A**: 使用国内镜像源

```cmd
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
```

### Q4: opencv-python-headless安装失败？

**A**: 尝试安装完整版opencv-python

```cmd
pip install opencv-python
```

---

## 📦 下载信息

- **版本**：v2.1.2
- **文件大小**：140.28 KB
- **上传时间**：2026-02-04 18:39
- **有效期**：7天
- **过期时间**：2026-02-11 18:39
- **修复内容**：修复cd命令问题

---

## 🎯 总结

### v2.1.2关键修复：
1. ✅ 修复cd命令问题（使用cd /d）
2. ✅ 使用绝对路径确保目录切换成功
3. ✅ 添加详细的错误提示
4. ✅ 修复fix-deps.bat和install.bat

### 快速修复（当前用户）：
```cmd
cd C:\CARD-OCR-LO\backend
python -m pip install paddleocr opencv-python-headless pillow numpy pydantic pydantic-settings python-dotenv -i https://pypi.tuna.tsinghua.edu.cn/simple
cd ..
start.bat
```

### 推荐方案：
1. 下载v2.1.2部署包
2. 运行setup.bat
3. 如果遇到问题，运行fix-deps.bat
4. 启动start.bat

✅ **v2.1.2版本修复了cd命令问题，确保目录切换成功！**

---

**祝您使用愉快！🎉**
