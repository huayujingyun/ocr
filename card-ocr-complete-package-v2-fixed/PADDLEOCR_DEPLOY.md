# PaddleOCR-VL-1.5 离线OCR系统部署指南

## 概述

本系统已成功将OCR识别模块从云端服务替换为本地PaddleOCR-VL-1.5，实现完全离线运行。

## 系统架构

```
┌─────────────────┐         ┌─────────────────┐
│   Next.js前端   │         │  Python后端     │
│   (端口5000)    │◄────────►│  (端口8001)     │
│                 │  HTTP    │                 │
│  - 购物卡识别   │         │  - PaddleOCR    │
│  - 图片上传     │         │  - FastAPI      │
│  - Excel导出    │         │  - 图片处理     │
└─────────────────┘         └─────────────────┘
```

## 功能特性

✅ **完全离线运行**：无需联网，所有OCR识别在本地完成
✅ **高精度识别**：基于PaddleOCR-VL-1.5，支持中英文识别
✅ **批量识别**：支持多张图片同时上传识别
✅ **模板识别**：支持模板框选模式，精准识别卡号和密码
✅ **传统OCR**：支持整张图片识别，自动提取卡号和密码
✅ **图片预处理**：支持灰度化、二值化、对比度增强、去噪

## 快速开始

### 前置要求

- **操作系统**：Linux（推荐Ubuntu 20.04+）或Windows
- **Python**：3.8+
- **Node.js**：16+
- **内存**：4GB+
- **磁盘空间**：3GB+

### 方式1：自动部署（推荐）

```bash
# 1. 进入项目目录
cd /workspace/projects

# 2. 启动开发环境（自动安装依赖并启动服务）
coze dev

# 服务将在以下端口启动：
# - 前端: http://localhost:5000
# - 后端: http://localhost:8001
```

### 方式2：手动部署

#### 步骤1：安装Python依赖

```bash
# 安装Python依赖
cd backend
pip3 install -r requirements.txt
```

#### 步骤2：启动后端服务

```bash
# 方式1：直接启动
cd backend
python3 main.py

# 方式2：使用启动脚本
cd backend
bash start.sh

# 方式3：Docker部署
cd backend
docker build -t paddleocr-service:latest .
docker run -d -p 8001:8001 --name paddleocr-service paddleocr-service:latest
```

#### 步骤3：启动前端服务

```bash
# 安装Node.js依赖
pnpm install

# 启动前端
pnpm run dev
```

### 方式3：生产部署

```bash
# 1. 构建前端
pnpm run build

# 2. 启动生产服务
coze start

# 或者手动启动
pnpm run start
```

## 离线部署

### 完全离线部署步骤

#### 1. 预下载模型文件（在有网络环境）

```bash
# 启动后端服务，首次会自动下载模型
cd backend
python3 main.py

# 等待看到 "PaddleOCR-VL-1.5引擎初始化成功"
# 按 Ctrl+C 停止服务
```

#### 2. 打包模型文件

```bash
# 打包PaddleOCR模型缓存
tar -czf paddleocr-models.tar.gz ~/.paddleocr/

# 或者只打包核心模型
tar -czf paddleocr-core-models.tar.gz ~/.paddleocr/whl/
```

#### 3. 复制到离线环境

```bash
# 复制以下内容到离线环境：
# - 整个项目代码
# - paddleocr-models.tar.gz
```

#### 4. 在离线环境部署

```bash
# 解压模型文件
tar -xzf paddleocr-models.tar.gz -C ~/

# 启动服务
cd backend
python3 main.py
```

### Docker离线部署

```bash
# 1. 在有网络环境构建镜像
cd backend
docker build -t paddleocr-service:latest .

# 2. 导出镜像
docker save paddleocr-service:latest | gzip > paddleocr-service.tar.gz

# 3. 在离线环境导入
docker load < paddleocr-service.tar.gz

# 4. 运行容器
docker run -d -p 8001:8001 --name paddleocr-service paddleocr-service:latest
```

## 配置说明

### 环境变量

在项目根目录创建 `.env` 文件：

```env
# PaddleOCR服务地址
PADDLEOCR_API_URL=http://localhost:8001

# 如果后端部署在其他服务器，修改为对应地址
# PADDLEOCR_API_URL=http://192.168.1.100:8001
```

### PaddleOCR参数调整

编辑 `backend/ocr_service.py`：

```python
self._ocr_engine = PaddleOCR(
    use_angle_cls=True,   # 使用方向分类器
    lang='ch',            # 中英文识别
    use_gpu=False,        # 是否使用GPU
    show_log=False,       # 是否显示详细日志
    det_db_thresh=0.3,    # 文本检测阈值（0-1）
    det_db_box_thresh=0.5,# 文本框阈值
    rec_batch_num=6,      # 批处理大小
    max_side_len=960,     # 最大边长
)
```

## 使用指南

### 1. 访问应用

打开浏览器访问：http://localhost:5000

### 2. 上传图片

支持以下两种方式：

#### 方式1：模板框选模式（推荐）

1. 点击"上传图片"
2. 在图片上框选卡号和密码区域
3. 点击"开始识别"
4. 系统会精准识别框选区域的内容

#### 方式2：传统OCR模式

1. 点击"上传图片"
2. 点击"开始识别"（不框选区域）
3. 系统会自动识别整张图片并提取卡号和密码

### 3. 编辑识别结果

识别完成后，可以：
- 编辑卡号和密码
- 查看识别的原始图片
- 重新识别

### 4. 导出结果

- **导出文档**：生成文本格式的识别结果
- **导出Excel**：生成包含卡号、密码、密码图片的Excel文件

## API文档

后端API文档地址：http://localhost:8001/docs

### 主要API端点

- `GET /health` - 健康检查
- `POST /api/ocr/recognize` - 单张图片识别
- `POST /api/ocr/batch` - 批量图片识别
- `POST /api/ocr/crop-recognize` - 裁剪区域识别
- `POST /api/ocr/upload` - 文件上传识别

### API使用示例

#### 单张图片识别

```bash
curl -X POST http://localhost:8001/api/ocr/recognize \
  -H "Content-Type: application/json" \
  -d '{
    "image": "data:image/jpeg;base64,...",
    "preprocess": "grayscale"
  }'
```

#### 批量识别

```bash
curl -X POST http://localhost:8001/api/ocr/batch \
  -H "Content-Type: application/json" \
  -d '{
    "images": [
      "data:image/jpeg;base64,...",
      "data:image/jpeg;base64,..."
    ],
    "preprocess": "grayscale"
  }'
```

## 性能优化

### 1. 首次启动慢

首次启动时，PaddleOCR会下载模型文件（约200MB），需要等待1-5分钟。

**解决方案**：
- 在有网络环境预下载模型
- 使用Docker镜像（已包含模型）

### 2. 识别速度慢

**优化方法**：
- 减小图片尺寸
- 减小批处理数量（`rec_batch_num`）
- 使用GPU加速（`use_gpu=True`）

### 3. 识别精度不高

**优化方法**：
- 提高输入图片质量
- 使用模板框选模式
- 尝试不同的预处理方式

## 故障排查

### 1. 后端无法启动

**错误信息**：`ImportError: libGL.so.1`

**解决方案**：
```bash
# Ubuntu/Debian
sudo apt-get install libgl1-mesa-glx libglib2.0-0 libsm6 libxext6 libxrender-dev

# CentOS/RHEL
sudo yum install mesa-libGL glib2 libSM libXext libXrender
```

### 2. 模型下载失败

**错误信息**：模型下载超时或失败

**解决方案**：
```bash
# 手动下载模型
cd backend
mkdir -p ~/.paddleocr/whl/det/ch/ch_PP-OCRv4_det
mkdir -p ~/.paddleocr/whl/rec/ch/ch_PP-OCRv4_rec

wget -P ~/.paddleocr/whl/det/ch/ch_PP-OCRv4_det \
  https://paddleocr.bj.bcebos.com/PP-OCRv4/chinese/ch_PP-OCRv4_det.tar

wget -P ~/.paddleocr/whl/rec/ch/ch_PP-OCRv4_rec \
  https://paddleocr.bj.bcebos.com/PP-OCRv4/chinese/ch_PP-OCRv4_rec.tar

cd ~/.paddleocr/whl/det/ch/ch_PP-OCRv4_det && tar -xf ch_PP-OCRv4_det.tar
cd ~/.paddleocr/whl/rec/ch/ch_PP-OCRv4_rec && tar -xf ch_PP-OCRv4_rec.tar
```

### 3. 前端无法连接后端

**错误信息**：`Failed to fetch` 或 `Connection refused`

**解决方案**：
1. 检查后端是否启动：`curl http://localhost:8001/health`
2. 检查防火墙设置
3. 检查环境变量 `PADDLEOCR_API_URL`
4. 查看后端日志：`tail -f /tmp/paddleocr-backend.log`

### 4. 内存不足

**错误信息**：`MemoryError` 或系统卡顿

**解决方案**：
1. 减小图片尺寸
2. 减小批处理数量
3. 增加系统内存
4. 关闭其他占用内存的程序

## 安全建议

1. **限制访问**：在生产环境中，限制后端API的访问来源
2. **使用HTTPS**：在生产环境中启用HTTPS加密
3. **定期更新**：保持PaddleOCR和依赖库的最新版本
4. **监控日志**：定期检查后端日志，及时发现异常

## 技术支持

- PaddleOCR官方文档：https://github.com/PaddlePaddle/PaddleOCR
- FastAPI官方文档：https://fastapi.tiangolo.com/
- Next.js官方文档：https://nextjs.org/docs

## 更新日志

### v2.0.0 (当前版本)

- ✅ 将OCR识别模块替换为PaddleOCR-VL-1.5
- ✅ 实现完全离线运行
- ✅ 添加Python FastAPI后端服务
- ✅ 优化批量识别性能
- ✅ 支持多种图片预处理方式

### v1.0.0

- 初始版本，使用云端OCR服务
