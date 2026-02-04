# Windows快速开始指南

## 🚀 3分钟快速部署

### 前提条件
- Windows 10/11 64位
- 4GB+ 内存
- 2GB+ 可用磁盘空间

---

## 方案选择

### 方案1：Docker部署（最简单，推荐）
```
优点：一键启动，无需配置Python环境
时间：约5分钟
难度：⭐

步骤：
1. 安装Docker Desktop（https://www.docker.com）
2. 下载部署包
3. 双击 docker-manager.bat
4. 选择"启动服务"
5. 访问 http://localhost:5000
```

### 方案2：标准部署
```
优点：灵活，易于定制
时间：约10分钟
难度：⭐⭐⭐

步骤：
1. 下载部署包
2. 双击 install.bat（会自动安装Python和Node.js）
3. 双击 start.bat
4. 访问 http://localhost:5000
```

### 方案3：便携式部署
```
优点：无需安装Python，不影响系统环境
时间：约15分钟
难度：⭐⭐⭐⭐

步骤：
1. 下载Python嵌入式版本
2. 解压到 backend\python\
3. 运行 install.bat
4. 双击 start.bat
5. 访问 http://localhost:5000
```

---

## 📦 下载部署包

### 方式1：在线安装（文件小，约50MB）
```
1. 下载：ocr-card-recognizer-windows.zip
2. 解压到任意目录（如：C:\ocr-card-recognizer\）
3. 运行安装脚本自动下载依赖
```

### 方式2：离线完整包（文件大，约1.5GB）
```
1. 下载：ocr-card-recognizer-windows-full.zip
2. 解压到任意目录
3. 双击 start.bat 直接运行
```

---

## 🎯 快速使用

### 1. 上传图片
- 点击"上传图片"按钮
- 选择购物卡/加油卡图片
- 支持多张图片同时上传

### 2. 设置模板（推荐，提高准确率）
- 点击"设置识别模板"
- 上传一张标准卡片图片
- 框选卡号区域
- 框选密码区域
- 保存模板

### 3. 开始识别
- 选择识别模式：
  - 模板识别（推荐）：使用模板框选，速度快、准确率高
  - 传统OCR：自动识别整张图片
- 点击"开始识别"按钮
- 等待识别完成（约0.5-2秒/张）

### 4. 编辑结果
- 查看识别结果
- 手动修正卡号和密码
- 点击"重新识别"重新识别

### 5. 导出结果
- 点击"导出文档"：生成文本文件
- 点击"导出Excel"：生成Excel文件（包含密码图片）

---

## 🔧 管理命令

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
后端日志：type logs\backend.log
前端日志：type logs\frontend.log
```

---

## ⚠️ 常见问题

### Q1: 安装脚本提示"Python未安装"
**A**:
1. 访问 https://www.python.org/downloads/release/python-3128/
2. 下载 Windows installer (64-bit)
3. 安装时勾选 "Add Python to PATH"
4. 重新运行 install.bat

### Q2: 端口被占用
**A**:
1. 双击 stop.bat 停止现有服务
2. 或修改配置文件更改端口

### Q3: 首次启动很慢
**A**: 正常现象，首次启动需要下载OCR模型文件（约200MB），后续启动只需10-30秒

### Q4: 识别结果不准确
**A**:
1. 使用模板框选模式（推荐）
2. 提高图片清晰度
3. 确保图片光线充足

### Q5: Docker构建失败
**A**:
1. 检查Docker Desktop是否运行
2. 检查网络连接
3. 尝试重新构建：docker-compose build --no-cache

---

## 📞 获取帮助

### 查看文档
- 完整部署指南：`README.md`
- 便携式Python指南：`PORTABLE_PYTHON.md`
- PaddleOCR文档：`PADDLEOCR_DEPLOY.md`

### 查看日志
```batch
type logs\backend.log
type logs\frontend.log
```

### 检查服务状态
```batch
curl http://localhost:8001/health
curl http://localhost:5000
```

---

## 🎉 完成！

现在您可以：
- ✅ 上传卡片图片自动识别
- ✅ 导出识别结果到Excel
- ✅ 完全离线运行，无需联网
- ✅ 数据安全，本地处理

**访问地址：http://localhost:5000**
