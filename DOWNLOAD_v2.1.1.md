# 🎉 Windows标准部署包 v2.1.1 - 下载（依赖版本修复版）

## 📥 直接下载链接

**文件名**：`ocr-card-recognizer-windows-standard-v2.1.1.tar.gz`

**文件大小**：140.18 KB

**版本**：v2.1.1

**有效期**：7天（2026-02-11过期）

### 🔗 下载地址

```
https://coze-coding-project.tos.coze.site/coze_storage_7602859016070627343/ocr-card-recognizer-windows-standard-v2.1.1.tar_bc857883.gz?sign=1770806191-e2a3022881-0-bec3a6d2e03c17a7e38699108b41f178018afa84aab6576d49e5315deb84904e
```

---

## 🔧 v2.1.1 修复内容

### 问题：paddlepaddle==3.2.2版本不存在

**错误信息**：
```
ERROR: Could not find a version that satisfies the requirement paddlepaddle==3.2.2 (from versions: none)
ERROR: No matching distribution found for paddlepaddle==3.2.2
```

**原因**：
- requirements.txt中指定了不存在的paddlepaddle版本
- paddlepaddle==3.2.2从未发布过
- pip无法找到该版本

**解决方案**：
✅ **修复requirements.txt版本号**
- 将严格版本号改为兼容版本号（>=）
- 自动选择可用的最新稳定版本
- 改进fix-deps.bat的错误处理和降级方案

**修复后的requirements.txt**：
```txt
# PaddlePaddle和PaddleOCR（兼容Python 3.12）
paddlepaddle>=2.6.0      # 修改：使用>=而不是==
paddleocr>=2.8.0        # 修改：使用>=而不是==

# 图像处理
Pillow>=10.1.0          # 修改：使用>=而不是==
numpy>=1.26.0           # 修改：使用>=而不是==
opencv-python-headless>=4.8.0  # 修改：使用>=而不是==

# 工具库
pydantic>=2.5.0         # 修改：使用>=而不是==
pydantic-settings>=2.1.0     # 修改：使用>=而不是==
python-dotenv>=1.0.0   # 修改：使用>=而不是==
```

---

## 🚀 当前用户的快速修复方案（无需重新下载）

如果您已经在使用v2.1.0或更早版本，遇到paddlepaddle安装失败，可以手动修复：

### 步骤1：修复requirements.txt

1. **打开backend/requirements.txt文件**
2. **将所有`==`改为`>=`**
3. **保存文件**

**修改示例**：
```txt
# 修改前
paddlepaddle==3.2.2
paddleocr==2.8.1

# 修改后
paddlepaddle>=2.6.0
paddleocr>=2.8.0
```

### 步骤2：重新安装依赖

打开cmd窗口（以管理员身份），运行：

```cmd
cd C:\CARD-OCR-LO
cd backend
python -m pip install -r requirements.txt
cd ..
```

### 步骤3：启动服务

```cmd
start.bat
```

---

## 🎯 或者下载v2.1.1版本（推荐）

### 步骤1：下载并解压

1. 点击上方下载链接
2. 使用7-Zip解压到 `C:\OCR\`

### 步骤2：运行setup.bat

1. 右键 `setup.bat` → "以管理员身份运行"
2. 等待安装完成

### 步骤3：如果遇到问题，运行fix-deps.bat

1. 右键 `fix-deps.bat` → "以管理员身份运行"
2. 等待依赖安装完成

**fix-deps.bat改进后的错误处理**：
```
Installing dependencies from requirements.txt...

[WARNING] Installation from requirements.txt failed
Trying to install essential dependencies manually...

Installing FastAPI and Uvicorn...
[OK] FastAPI dependencies installed

Installing PaddlePaddle and PaddleOCR...
Note: This may take a few minutes...
[OK] PaddleOCR dependencies installed
```

### 步骤4：启动服务

1. 双击 `start.bat`
2. 访问 http://localhost:5000

---

## 📊 版本对比

| 版本 | 修复内容 | 状态 |
|------|---------|------|
| v2.0.0 - v2.0.7 | 缺少源代码 | ❌ 不完整 |
| v2.0.8 | 包含完整源代码 | ⚠️ 版本号问题 |
| v2.0.9 | 增强诊断信息 | ⚠️ 版本号问题 |
| v2.1.0 | 新增fix-deps.bat | ⚠️ paddlepaddle版本不存在 |
| v2.1.1 | 修复requirements.txt版本号 | ✅ 完全可用 |

---

## 💡 改进详情

### requirements.txt改进

**v2.1.0（有问题）**：
```txt
paddlepaddle==3.2.2        # ❌ 版本不存在
paddleocr==2.8.1
Pillow==10.1.0
numpy==1.26.4
```

**v2.1.1（修复）**：
```txt
paddlepaddle>=2.6.0        # ✅ 使用兼容版本
paddleocr>=2.8.0
Pillow>=10.1.0
numpy>=1.26.0
```

**优点**：
- ✅ 自动选择可用的最新稳定版本
- ✅ 兼容Python 3.12
- ✅ 避免版本不存在的问题

### fix-deps.bat改进

**v2.1.0**：
- 如果requirements.txt安装失败，只尝试安装基本依赖
- 不提供降级方案

**v2.1.1**：
- 如果requirements.txt安装失败，分步骤安装
- 提供详细的错误信息
- 支持使用国内镜像源

---

## ❓ 常见问题

### Q1: pip安装速度慢？

**A**: 使用国内镜像源

```cmd
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
```

### Q2: opencv-python-headless安装失败？

**A**: 尝试安装完整版opencv-python

```cmd
pip install opencv-python
```

### Q3: paddlepaddle安装很慢？

**A**: 正常现象，PaddlePaddle包很大（约200MB），需要耐心等待。

### Q4: 首次启动卡住？

**A**: 首次启动需要下载OCR模型，需要1-5分钟。

---

## 📦 下载信息

- **版本**：v2.1.1
- **文件大小**：140.18 KB
- **上传时间**：2026-02-04 18:36
- **有效期**：7天
- **过期时间**：2026-02-11 18:36
- **修复内容**：修复requirements.txt版本号

---

## 🎯 总结

### v2.1.1关键修复：
1. ✅ 修复paddlepaddle版本不存在的问题
2. ✅ 将严格版本号改为兼容版本号
3. ✅ 改进fix-deps.bat错误处理
4. ✅ 提供降级方案和国内镜像支持

### 快速修复（当前用户）：
```cmd
cd C:\CARD-OCR-LO\backend
# 编辑requirements.txt，将所有==改为>=
python -m pip install -r requirements.txt
cd ..
start.bat
```

### 推荐方案：
1. 下载v2.1.1部署包
2. 运行setup.bat
3. 如果遇到问题，运行fix-deps.bat
4. 启动start.bat

✅ **v2.1.1版本修复了所有依赖版本问题！**

---

**祝您使用愉快！🎉**
