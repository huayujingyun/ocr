# Windows部署包下载说明

## 📦 部署包版本信息

**版本**：v2.0.0
**发布日期**：2024-02-04
**平台**：Windows 10/11 64位

---

## 🎯 下载选项

### 选项1：在线安装包（推荐）

**文件名**：`ocr-card-recognizer-windows.zip`

**文件大小**：约50MB

**特点**：
- ✅ 文件小，下载快
- ✅ 自动下载依赖
- ✅ 占用空间小

**适用场景**：
- 网络连接稳定
- 磁盘空间有限
- 第一次安装

**下载地址**：
```
https://your-domain.com/downloads/ocr-card-recognizer-windows.zip
```

**使用说明**：
1. 下载并解压
2. 双击 `install.bat` 安装
3. 双击 `start.bat` 启动

---

### 选项2：离线完整包

**文件名**：`ocr-card-recognizer-windows-full.zip`

**文件大小**：约1.5GB

**特点**：
- ✅ 包含所有依赖
- ✅ 无需联网安装
- ✅ 开箱即用

**适用场景**：
- 无网络环境
- 需要快速部署
- 多台电脑部署

**下载地址**：
```
https://your-domain.com/downloads/ocr-card-recognizer-windows-full.zip
```

**使用说明**：
1. 下载并解压
2. 双击 `start.bat` 直接启动

---

### 选项3：便携式版本（Python嵌入式）

**文件1**：`ocr-card-recognizer-portable-base.zip`（约50MB）
**文件2**：`python-3.12-embed-amd64.zip`（约10MB）

**总大小**：约60MB

**特点**：
- ✅ 无需安装Python
- ✅ 不影响系统环境
- ✅ 可以卸载（删除文件夹）

**适用场景**：
- 无管理员权限
- 不想安装Python
- 临时使用

**下载地址**：
```
基础包：https://your-domain.com/downloads/ocr-card-recognizer-portable-base.zip
Python：https://www.python.org/downloads/windows/
       选择：Windows embeddable package (64-bit)
```

**使用说明**：
1. 下载两个文件
2. 解压基础包
3. 将Python嵌入式版本解压到 `backend\python\`
4. 双击 `start.bat` 启动

---

## 📋 部署包内容

### 在线安装包（ocr-card-recognizer-windows.zip）

```
ocr-card-recognizer/
├── README.md                          # 完整部署指南
├── QUICKSTART.md                      # 快速开始指南
├── package.json                       # 版本信息
├── install.bat                        # 安装脚本
├── start.bat                          # 启动脚本
├── stop.bat                           # 停止脚本
├── check.bat                          # 状态检查
├── docker-manager.bat                 # Docker管理
├── PORTABLE_PYTHON.md                 # 便携式Python指南
├── frontend/                          # 前端源码
└── backend/                           # 后端源码
```

### 离线完整包（ocr-card-recognizer-windows-full.zip）

包含在线安装包的所有内容，加上：
```
├── frontend/node_modules/             # Node.js依赖
├── backend/python/                    # 便携式Python环境
└── models/                            # OCR模型文件
```

---

## 🚀 快速开始

### 方法1：使用在线安装包

```batch
1. 下载 ocr-card-recognizer-windows.zip
2. 解压到 C:\ocr-card-recognizer\
3. 右键点击 install.bat → 以管理员身份运行
4. 等待安装完成
5. 双击 start.bat
6. 访问 http://localhost:5000
```

### 方法2：使用离线完整包

```batch
1. 下载 ocr-card-recognizer-windows-full.zip
2. 解压到 C:\ocr-card-recognizer\
3. 双击 start.bat
4. 访问 http://localhost:5000
```

### 方法3：使用Docker

```batch
1. 下载 ocr-card-recognizer-windows.zip
2. 解压到任意目录
3. 安装Docker Desktop
4. 双击 docker-manager.bat
5. 选择"启动服务"
6. 访问 http://localhost:5000
```

---

## 🔐 校验下载文件

为确保下载文件的完整性，请校验MD5或SHA256哈希值：

### 在线安装包
```
文件名：ocr-card-recognizer-windows.zip
MD5：[待生成]
SHA256：[待生成]
```

### 离线完整包
```
文件名：ocr-card-recognizer-windows-full.zip
MD5：[待生成]
SHA256：[待生成]
```

### 校验方法

**Windows PowerShell**：
```powershell
# 计算MD5
Get-FileHash ocr-card-recognizer-windows.zip -Algorithm MD5

# 计算SHA256
Get-FileHash ocr-card-recognizer-windows.zip -Algorithm SHA256
```

**命令提示符**：
```batch
certutil -hashfile ocr-card-recognizer-windows.zip MD5
certutil -hashfile ocr-card-recognizer-windows.zip SHA256
```

---

## 📝 更新日志

### v2.0.0 (2024-02-04)
- ✅ 使用本地PaddleOCR替代云端服务
- ✅ 实现完全离线运行
- ✅ 支持Windows本地部署
- ✅ 提供便携式Python方案
- ✅ 支持Docker部署
- ✅ 优化识别速度（提升2-3倍）
- ✅ 增强数据隐私保护

### v1.0.0 (2024-01-15)
- 初始版本
- 使用云端OCR服务
- 支持模板识别和传统OCR

---

## ⚠️ 注意事项

### 系统要求
- **操作系统**：Windows 10/11 64位
- **内存**：4GB+（推荐8GB）
- **磁盘空间**：
  - 在线安装包：2GB+
  - 离线完整包：3GB+
- **权限**：管理员权限（在线安装需要）

### 网络要求
- **在线安装包**：首次安装需要网络连接（下载依赖约300MB）
- **离线完整包**：无需网络连接
- **OCR模型**：首次启动会自动下载模型（约200MB，仅在线安装包）

### 安全建议
1. 从官方渠道下载
2. 校验文件哈希值
3. 运行杀毒软件扫描
4. 在安全的环境中使用

---

## 📞 技术支持

### 文档
- 完整部署指南：`README.md`
- 快速开始指南：`QUICKSTART.md`
- 便携式Python指南：`PORTABLE_PYTHON.md`
- PaddleOCR文档：`PADDLEOCR_DEPLOY.md`

### 常见问题
查看：`README.md` 中的"常见问题"章节

### 联系方式
- 问题反馈：[您的邮箱]
- 技术支持：[您的联系方式]

---

## 🎉 开始使用

选择适合您的部署方案，按照上述说明即可快速部署！

**祝您使用愉快！**
