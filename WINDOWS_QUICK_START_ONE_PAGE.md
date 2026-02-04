# ⚡ 3分钟快速部署 - 一页纸指南

## 📦 准备工作

- Windows 10/11 64位
- 4GB+ 内存
- 管理员权限

---

## 🚀 3步完成

### 1️⃣ 下载部署包

访问：https://github.com/huayujingyun/ocr/releases

下载：`ocr-card-recognizer-windows-v2.0.0.zip`

解压到：`C:\OCR\`

---

### 2️⃣ 安装依赖

右键点击 `install.bat` → **"以管理员身份运行"**

等待5-10分钟（首次安装）

✅ 看到"安装完成"提示

---

### 3️⃣ 启动服务

双击 `start.bat`

等待30-60秒

浏览器访问：**http://localhost:5000**

✅ 完成！

---

## 🎮 使用

### 上传图片
点击"上传图片"按钮，选择卡片图片

### 识别
点击"开始识别"按钮

### 导出
点击"导出Excel"，生成Excel文件（包含密码图片）

---

## 🛠️ 常用命令

```
启动服务：双击 start.bat
停止服务：双击 stop.bat
检查状态：双击 check.bat
查看日志：双击 logs\backend.log
```

---

## ❓ 常见问题

**Q: 安装没反应？**
A: 右键以管理员身份运行

**Q: 提示Python未安装？**
A: 访问 https://www.python.org/downloads/release/python-3128/ 下载安装，记得勾选"Add Python to PATH"

**Q: 端口被占用？**
A: 双击 stop.bat，再双击 start.bat

**Q: 首次启动慢？**
A: 正常，需要下载OCR模型（200MB）

---

## 💡 提示

- 使用模板识别更准确
- 使用高清图片
- 光线充足

---

**访问地址：http://localhost:5000**
