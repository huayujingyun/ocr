# PaddleOCR-VL-1.5 本地OCR服务

基于PaddleOCR-VL-1.5的本地化OCR识别服务，支持中英文文字识别，完全离线运行。

## 功能特性

- ✅ 支持中英文文字识别
- ✅ 完全离线运行（无需联网）
- ✅ 支持图片预处理（灰度化、二值化、对比度增强、去噪）
- ✅ 支持单张和批量识别
- ✅ 支持裁剪区域识别
- ✅ RESTful API接口
- ✅ Docker部署支持

## 系统要求

- Python 3.8+
- 内存: 4GB+
- 磁盘空间: 2GB+（模型文件）

## 快速开始

### 方式1: Docker部署（推荐）

```bash
# 1. 构建Docker镜像
docker build -t paddleocr-service:latest .

# 2. 运行容器
docker run -d \
  --name paddleocr-service \
  -p 8001:8001 \
  paddleocr-service:latest

# 3. 检查服务状态
curl http://localhost:8001/health
```

### 方式2: 本地Python部署

```bash
# 1. 安装依赖
pip install -r requirements.txt

# 2. 启动服务
python main.py

# 3. 服务将在 http://localhost:8001 启动
```

## API文档

启动服务后，访问以下地址查看完整API文档：

- Swagger UI: http://localhost:8001/docs
- ReDoc: http://localhost:8001/redoc

## API接口说明

### 1. 健康检查

**请求:**
```bash
GET /health
```

**响应:**
```json
{
  "status": "healthy",
  "ocr_ready": true
}
```

### 2. 单张图片识别

**请求:**
```bash
POST /api/ocr/recognize
Content-Type: application/json

{
  "image": "data:image/jpeg;base64,...",
  "preprocess": "grayscale"
}
```

**参数说明:**
- `image`: base64编码的图片（可包含data:image前缀）
- `preprocess`: 可选，预处理方式
  - `grayscale`: 灰度化
  - `threshold`: 二值化
  - `contrast`: 对比度增强
  - `denoise`: 去噪

**响应:**
```json
{
  "success": true,
  "text": "识别到的文字",
  "message": "识别成功"
}
```

### 3. 批量识别

**请求:**
```bash
POST /api/ocr/batch
Content-Type: application/json

{
  "images": [
    "data:image/jpeg;base64,...",
    "data:image/jpeg;base64,..."
  ],
  "preprocess": "grayscale"
}
```

**响应:**
```json
{
  "success": true,
  "results": ["识别结果1", "识别结果2"],
  "message": "批量识别成功"
}
```

### 4. 裁剪区域识别

**请求:**
```bash
POST /api/ocr/crop-recognize
Content-Type: application/json

{
  "image": "data:image/jpeg;base64,...",
  "crop_box": [0.1, 0.2, 0.3, 0.4],
  "preprocess": "grayscale"
}
```

**参数说明:**
- `crop_box`: 裁剪区域 `[x, y, width, height]`，使用相对坐标（0-1）

**响应:**
```json
{
  "success": true,
  "text": "识别到的文字",
  "message": "裁剪识别成功"
}
```

### 5. 文件上传识别

**请求:**
```bash
POST /api/ocr/upload
Content-Type: multipart/form-data

file: <binary file>
preprocess: grayscale
```

**响应:**
```json
{
  "success": true,
  "text": "识别到的文字",
  "message": "识别成功"
}
```

## 性能优化

### 1. 首次启动慢

首次启动时，PaddleOCR会自动下载模型文件（约200MB），需要等待1-5分钟。后续启动会使用缓存的模型文件。

### 2. 批处理优化

批量识别时，建议控制单批数量在10-20张图片，以平衡速度和内存占用。

### 3. 图片预处理

根据图片质量选择合适的预处理方式：
- 清晰图片: 无需预处理
- 低对比度: `contrast`
- 噪点较多: `denoise`
- 背景复杂: `grayscale` 或 `threshold`

## 离线部署

### 完全离线部署步骤

1. **在有网络的环境中预下载模型**

```bash
# 启动服务，首次会自动下载模型
python main.py

# 等待模型下载完成（看到"PaddleOCR-VL-1.5引擎初始化成功"）
# 按 Ctrl+C 停止服务
```

2. **打包模型文件**

```bash
# 打包模型缓存目录
tar -czf paddleocr-models.tar.gz ~/.paddleocr/

# 将 paddleocr-models.tar.gz 和代码一起复制到离线环境
```

3. **在离线环境中部署**

```bash
# 解压模型文件
tar -xzf paddleocr-models.tar.gz -C ~/

# 启动服务
python main.py
```

### Docker离线部署

```bash
# 1. 在有网络环境构建镜像
docker build -t paddleocr-service:latest .

# 2. 导出镜像
docker save paddleocr-service:latest | gzip > paddleocr-service.tar.gz

# 3. 在离线环境导入
docker load < paddleocr-service.tar.gz

# 4. 运行容器
docker run -d --name paddleocr-service -p 8001:8001 paddleocr-service:latest
```

## 常见问题

### 1. ImportError: libGL.so.1

**问题:** 缺少OpenGL库

**解决:**
```bash
# Ubuntu/Debian
apt-get install libgl1-mesa-glx

# CentOS/RHEL
yum install mesa-libGL
```

### 2. 模型下载失败

**问题:** 网络问题导致模型下载失败

**解决:**
```bash
# 手动下载模型
wget https://paddleocr.bj.bcebos.com/PP-OCRv4/chinese/ch_PP-OCRv4_det.tar
wget https://paddleocr.bj.bcebos.com/PP-OCRv4/chinese/ch_PP-OCRv4_rec.tar

# 解压到模型目录
mkdir -p ~/.paddleocr/whl/det/ch/ch_PP-OCRv4_det
mkdir -p ~/.paddleocr/whl/rec/ch/ch_PP-OCRv4_rec
tar -xf ch_PP-OCRv4_det.tar -C ~/.paddleocr/whl/det/ch/ch_PP-OCRv4_det
tar -xf ch_PP-OCRv4_rec.tar -C ~/.paddleocr/whl/rec/ch/ch_PP-OCRv4_rec
```

### 3. 内存不足

**问题:** 识别时内存占用过高

**解决:**
- 减小图片尺寸
- 使用更小的批处理大小
- 在 `ocr_service.py` 中调整 `rec_batch_num` 参数

### 4. 识别精度不高

**问题:** 识别结果不准确

**解决:**
- 尝试不同的预处理方式
- 提高输入图片质量
- 调整检测阈值（`det_db_thresh`）

## 与前端集成

前端应用需要修改OCR API调用地址，从云端SDK改为本地服务：

```typescript
// 修改 src/app/api/ocr/route.ts
const OCR_API_URL = 'http://localhost:8001/api/ocr/recognize';

async function recognizeText(image: string): Promise<string> {
  const response = await fetch(OCR_API_URL, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      image: image,
      preprocess: 'grayscale' // 可选
    })
  });

  const result = await response.json();
  return result.text;
}
```

## 许可证

本服务基于PaddleOCR开发，遵循Apache 2.0许可证。

## 支持

如有问题，请参考：
- [PaddleOCR官方文档](https://github.com/PaddlePaddle/PaddleOCR)
- [FastAPI官方文档](https://fastapi.tiangolo.com/)
