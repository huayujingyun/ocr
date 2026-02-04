# 📦 Windows标准部署包下载

## 🎉 部署包已生成！

### 📥 下载文件

**文件名**：`ocr-card-recognizer-windows-standard-v2.0.0.tar.gz`

**文件大小**：约140KB

**包含内容**：
- ✅ 安装脚本（install.bat）
- ✅ 启动脚本（start.bat）
- ✅ 停止脚本（stop.bat）
- ✅ 检查脚本（check.bat）
- ✅ 完整文档（README.md, QUICKSTART.md）
- ✅ 后端源代码
- ✅ 前端源代码
- ✅ 配置文件

---

## 🚀 3步完成部署

### 步骤1：下载并解压

1. 下载 `ocr-card-recognizer-windows-standard-v2.0.0.tar.gz`
2. 使用 **7-Zip** 或 **WinRAR** 解压
3. 解压到任意目录（推荐：`C:\OCR\`）

**提示**：Windows无法直接解压tar.gz文件，需要使用7-Zip或WinRAR

---

### 步骤2：安装依赖

1. 右键点击 `install.bat`
2. 选择 **"以管理员身份运行"**
3. 等待安装完成（5-10分钟）

**安装内容**：
- 自动下载并安装Python 3.12
- 自动下载并安装Node.js
- 安装后端依赖（PaddleOCR等）
- 安装前端依赖（Next.js等）
- 下载OCR模型文件（约200MB）

---

### 步骤3：启动服务

1. 双击 `start.bat`
2. 等待30-60秒（首次启动需要下载OCR模型）
3. 浏览器访问：**http://localhost:5000**

✅ **完成！**

---

## 📖 快速使用

### 1️⃣ 上传图片

点击"上传图片"按钮，选择卡片图片

### 2️⃣ 识别

点击"开始识别"按钮，等待1-2秒

### 3️⃣ 导出

点击"导出Excel"，生成Excel文件（包含密码图片）

---

## 🛠️ 管理服务

```
启动服务：双击 start.bat
停止服务：双击 stop.bat
检查状态：双击 check.bat
```

---

## ❓ 常见问题

### Q: 无法解压tar.gz文件？

**A**:
- Windows无法直接解压tar.gz
- 下载 **7-Zip**：https://www.7-zip.org/
- 或下载 **WinRAR**：https://www.win-rar.com/

### Q: 双击install.bat没反应？

**A**: 右键以管理员身份运行

### Q: 提示Python未安装？

**A**:
- 访问：https://www.python.org/downloads/release/python-3128/
- 下载Windows installer (64-bit)
- 运行安装程序，勾选"Add Python to PATH"
- 重新运行install.bat

### Q: 首次启动很慢？

**A**: 正常现象，需要下载OCR模型（200MB），等待30-60秒

### Q: 端口被占用？

**A**: 双击stop.bat，再双击start.bat

---

## 📊 系统要求

- Windows 10/11 64位
- 4GB+ 内存（推荐8GB）
- 2GB+ 可用磁盘空间
- 管理员权限
- 7-Zip或WinRAR（用于解压）

---

## 📞 获取帮助

### 查看文档
- 完整指南：解压后的 `README.md`
- 快速开始：解压后的 `QUICKSTART.md`

### 检查服务状态
```
双击：check.bat
```

### 查看日志
```
打开：logs\backend.log
```

---

## 💡 提示

### 优化识别准确率
1. 使用模板识别模式
2. 使用高清图片
3. 确保卡片水平放置
4. 光线充足

### 提高识别速度
1. 减少同时上传的图片数量
2. 使用模板识别模式
3. 关闭不必要的程序

### 确保数据安全
1. 定期备份识别结果
2. 不要在公共电脑上使用
3. 识别完成后及时删除原始图片

---

## 🎉 完成！

现在您可以：
- ✅ 自动识别购物卡和加油卡
- ✅ 批量处理，提高效率
- ✅ 导出Excel，方便整理
- ✅ 完全离线，数据安全
- ✅ 无需联网，随时使用

**访问地址：http://localhost:5000**

---

## 📝 版本信息

- 版本：v2.0.0
- 更新日期：2024-02-04
- 部署方式：标准部署（无需Docker）

---

## 🔄 后续更新

如果需要更新：
1. 下载最新版本的部署包
2. 备份现有数据（识别结果）
3. 解压新版本覆盖现有文件
4. 重新运行install.bat
5. 启动服务

---

**祝您使用愉快！🎉**
