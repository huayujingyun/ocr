# 🔧 后端服务连接问题排查与修复

## ❌ 问题描述

**错误信息**：`{"detail":"无法连接到后端服务"}`

**症状**：
- 前端页面无法连接到后端服务
- OCR识别功能无法使用
- 前端显示连接错误

---

## 🔍 排查过程

### 1. 检查服务状态

**检查端口监听**：
```bash
# 检查前端服务（5000端口）
ss -lptn 'sport = :5000'
# 结果：前端服务正常运行

# 检查后端服务（8001端口）
ss -lptn 'sport = :8001'
# 结果：后端服务未运行
```

**结论**：前端服务正常运行，但后端服务没有启动

---

### 2. 检查后端进程

```bash
ps aux | grep python
```

发现只有系统服务（9000端口）在运行，没有后端服务进程

---

### 3. 检查后端日志

```bash
tail -n 50 /tmp/paddleocr-backend.log
```

**错误信息**：
```
Traceback (most recent call last):
  File "/workspace/projects/backend/main.py", line 13, in <module>
    from ocr_service import OCRService
  File "/workspace/projects/backend/ocr_service.py", line 7, in <module>
    from paddleocr import PaddleOCR
  File "/usr/local/lib/python3.12/dist-packages/paddleocr/__init__.py", line 14, in <module>
    from .paddleocr import *
  File "/usr/local/lib/python3.12/dist-packages/paddleocr/paddleocr.py", line 26, in <module>
    import cv2
ImportError: libGL.so.1: cannot open shared object file: No such file or directory
```

**根本原因**：缺少OpenCV所需的系统依赖库 `libGL.so.1`

---

## ✅ 解决方案

### 步骤1：安装OpenCV系统依赖

```bash
apt-get update
apt-get install -y libgl1 libglib2.0-0 libsm6 libxext6 libxrender1 libgthread-2.0-0
```

**这些依赖的作用**：
- `libgl1` - OpenGL库
- `libglib2.0-0` - GLib库
- `libsm6` - X11会话管理库
- `libxext6` - X11扩展库
- `libxrender1` - X11渲染库
- `libgthread-2.0-0` - GLib线程库

---

### 步骤2：启动后端服务

```bash
cd backend
python3 -m uvicorn main:app --host 0.0.0.0 --port 8001 --log-level info > /tmp/paddleocr-backend.log 2>&1 &
```

**启动过程**：
1. 下载OCR模型文件（约16MB）
   - `ch_PP-OCRv4_det_infer.tar` (4.89MB) - 检测模型
   - `ch_PP-OCRv4_rec_infer.tar` (11.0MB) - 识别模型
   - `ch_ppocr_mobile_v2.0_cls_infer.tar` (2.19MB) - 分类模型
2. 加载模型到内存
3. 启动FastAPI服务

**启动成功的标志**：
```
INFO:     Started server process [1579]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     Uvicorn running on http://0.0.0.0:8001 (Press CTRL+C to quit)
```

---

### 步骤3：验证服务

```bash
# 检查端口监听
ss -lptn 'sport = :8001'
# 应该看到：LISTEN 0 2048 0.0.0.0:8001

# 测试健康检查
curl http://localhost:8001/health
# 应该返回：{"status":"healthy","ocr_ready":true}
```

---

## 📊 验证结果

| 检查项 | 状态 |
|--------|------|
| 前端服务（5000） | ✅ 运行正常 |
| 后端服务（8001） | ✅ 运行正常 |
| OCR模型 | ✅ 已加载 |
| 健康检查 | ✅ 通过 |

---

## 🎉 问题已解决

现在您可以：

1. 访问 http://localhost:5000
2. 上传图片进行OCR识别
3. 导出识别结果到Excel

---

## 💡 预防措施

### 在install.bat中添加系统依赖安装

编辑 `deploy/windows/install.bat`，添加：

```batch
REM 安装Python依赖
pip install -r backend/requirements.txt

REM 在Windows环境中，OpenCV的依赖通常已经包含在安装包中
REM 如果遇到类似问题，可以尝试重新安装opencv-python
pip uninstall opencv-python opencv-python-headless -y
pip install opencv-python-headless
```

### 在Linux环境中

在启动脚本中添加依赖检查：

```bash
#!/bin/bash

# 检查OpenCV依赖
if ! ldconfig -p | grep -q libGL.so.1; then
    echo "Installing OpenCV dependencies..."
    apt-get update
    apt-get install -y libgl1 libglib2.0-0 libsm6 libxext6 libxrender1 libgthread-2.0-0
fi

# 启动后端服务
cd backend
python3 -m uvicorn main:app --host 0.0.0.0 --port 8001 --log-level info
```

---

## ❓ 常见问题

### Q1: 为什么会缺少这些依赖？

**A**:
- Docker基础镜像通常不包含这些图形库
- OpenCV依赖这些库来处理图像
- 需要手动安装

### Q2: Windows环境会出现这个问题吗？

**A**:
- 不会。Windows的OpenCV安装包通常包含所有依赖
- 这个问题主要出现在Linux环境

### Q3: 如何避免这个问题？

**A**:
1. 在Dockerfile中安装这些依赖
2. 在install.bat中添加依赖检查
3. 使用官方的PaddleOCR Docker镜像

### Q4: 如果还有其他导入错误怎么办？

**A**:
检查错误信息，安装相应的依赖：

```bash
# 常见的OpenCV错误和解决方案
ImportError: libgthread-2.0-0 -> apt-get install libgthread-2.0-0
ImportError: libglib2.0-0 -> apt-get install libglib2.0-0
ImportError: libsm6 -> apt-get install libsm6
ImportError: libxext6 -> apt-get install libxext6
ImportError: libxrender1 -> apt-get install libxrender1
ImportError: libgl1 -> apt-get install libgl1
```

---

## 📝 完整的依赖列表

### Linux环境
```bash
apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    libgthread-2.0-0
```

### Docker环境

在Dockerfile中添加：
```dockerfile
RUN apt-get update && \
    apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    libgthread-2.0-0 && \
    rm -rf /var/lib/apt/lists/*
```

---

## 🚀 快速修复命令

如果再次遇到这个问题，直接运行：

```bash
# 安装依赖
apt-get update && apt-get install -y libgl1 libglib2.0-0 libsm6 libxext6 libxrender1 libgthread-2.0-0

# 重启后端服务
cd backend && python3 -m uvicorn main:app --host 0.0.0.0 --port 8001 --log-level info > /tmp/paddleocr-backend.log 2>&1 &

# 验证服务
sleep 5 && curl http://localhost:8001/health
```

---

## ✅ 总结

**问题**：后端服务无法启动，缺少OpenCV系统依赖

**原因**：`libGL.so.1` 等系统库未安装

**解决**：安装OpenCV依赖库并重启后端服务

**验证**：健康检查通过，服务正常运行

---

**现在系统已经完全可用！🎉**
