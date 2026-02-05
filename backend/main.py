"""
FastAPI后端服务 - 集成PaddleOCR-VL-1.5
提供OCR识别API接口
"""

import os
# 禁用oneDNN以避免兼容性问题
os.environ['USE_ONEDNN'] = '0'

from fastapi import FastAPI, File, UploadFile, HTTPException, Form
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field
from typing import List, Optional, Dict, Any
import base64
import numpy as np
from ocr_service import OCRService
import logging
import cv2

# 配置日志
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# 创建FastAPI应用
app = FastAPI(
    title="PaddleOCR-VL-1.5 API",
    description="基于PaddleOCR-VL-1.5的本地OCR识别服务",
    version="1.0.0"
)

# 配置CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 生产环境应限制为具体域名
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 初始化OCR服务（单例）
try:
    ocr_service = OCRService()
    logger.info("OCR服务初始化成功")
except Exception as e:
    logger.error(f"OCR服务初始化失败: {e}")
    ocr_service = None


# 请求/响应模型
class RecognitionRequest(BaseModel):
    """OCR识别请求"""
    image: str = Field(..., description="base64编码的图片")
    preprocess: Optional[str] = Field(None, description="预处理方式: grayscale, threshold, contrast, denoise")


class BatchRecognitionRequest(BaseModel):
    """批量OCR识别请求"""
    images: List[str] = Field(..., description="base64编码的图片列表")
    preprocess: Optional[str] = Field(None, description="预处理方式")


class CropRecognitionRequest(BaseModel):
    """裁剪区域识别请求"""
    image: str = Field(..., description="base64编码的原始图片")
    crop_box: List[float] = Field(..., description="裁剪区域 [x, y, width, height]，相对坐标（0-1）")
    preprocess: Optional[str] = Field(None, description="预处理方式")


class CardImage(BaseModel):
    """卡片图片"""
    label: str = Field(..., description="标签（卡号/密码）")
    imageData: str = Field(..., description="base64编码的图片")


class TemplateOCRRequest(BaseModel):
    """模板OCR识别请求（前端使用）"""
    croppedImages: List[CardImage] = Field(..., description="裁剪后的图片列表")
    useTemplate: bool = Field(True, description="是否使用模板")


class RecognitionResponse(BaseModel):
    """OCR识别响应"""
    success: bool = Field(..., description="是否成功")
    text: str = Field(..., description="识别到的文字")
    message: Optional[str] = Field(None, description="额外信息")


class BatchRecognitionResponse(BaseModel):
    """批量识别响应"""
    success: bool = Field(..., description="是否成功")
    results: List[str] = Field(..., description="识别结果列表")
    message: Optional[str] = Field(None, description="额外信息")


class HealthResponse(BaseModel):
    """健康检查响应"""
    status: str = Field(..., description="服务状态")
    ocr_ready: bool = Field(..., description="OCR引擎是否就绪")


# API路由
@app.get("/", tags=["系统"])
async def root():
    """根路径"""
    return {
        "service": "PaddleOCR-VL-1.5 API",
        "version": "1.0.0",
        "status": "running"
    }


@app.get("/health", response_model=HealthResponse, tags=["系统"])
async def health_check():
    """健康检查"""
    ocr_ready = ocr_service is not None
    return HealthResponse(
        status="healthy" if ocr_ready else "unhealthy",
        ocr_ready=ocr_ready
    )


@app.post("/api/ocr/recognize", response_model=RecognitionResponse, tags=["OCR识别"])
async def recognize_text(request: RecognitionRequest):
    """
    单张图片OCR识别

    Args:
        request: 包含base64图片和预处理参数的请求

    Returns:
        识别结果
    """
    if ocr_service is None:
        raise HTTPException(status_code=503, detail="OCR服务未初始化")

    try:
        # 解码图片
        image = ocr_service.base64_to_image(request.image)

        # 执行识别
        text = ocr_service.recognize_text(image, request.preprocess)

        logger.info(f"OCR识别成功，识别到: {text}")

        return RecognitionResponse(
            success=True,
            text=text,
            message="识别成功"
        )

    except Exception as e:
        logger.error(f"OCR识别失败: {e}")
        return RecognitionResponse(
            success=False,
            text="",
            message=f"识别失败: {str(e)}"
        )


@app.post("/api/ocr/batch", response_model=BatchRecognitionResponse, tags=["OCR识别"])
async def recognize_batch(request: BatchRecognitionRequest):
    """
    批量图片OCR识别

    Args:
        request: 包含base64图片列表和预处理参数的请求

    Returns:
        识别结果列表
    """
    if ocr_service is None:
        raise HTTPException(status_code=503, detail="OCR服务未初始化")

    try:
        # 解码图片列表
        images = []
        for idx, img_base64 in enumerate(request.images):
            try:
                image = ocr_service.base64_to_image(img_base64)
                images.append(image)
            except Exception as e:
                logger.error(f"第{idx+1}张图片解码失败: {e}")
                images.append(np.array([]))  # 占位符

        # 执行批量识别
        results = ocr_service.recognize_batch(images, request.preprocess)

        logger.info(f"批量识别完成，共 {len(results)} 张图片")

        return BatchRecognitionResponse(
            success=True,
            results=results,
            message="批量识别成功"
        )

    except Exception as e:
        logger.error(f"批量识别失败: {e}")
        return BatchRecognitionResponse(
            success=False,
            results=[],
            message=f"批量识别失败: {str(e)}"
        )


@app.post("/api/ocr/crop-recognize", response_model=RecognitionResponse, tags=["OCR识别"])
async def recognize_with_crop(request: CropRecognitionRequest):
    """
    裁剪指定区域并识别文字

    Args:
        request: 包含原始图片、裁剪区域和预处理参数的请求

    Returns:
        识别结果
    """
    if ocr_service is None:
        raise HTTPException(status_code=503, detail="OCR服务未初始化")

    try:
        # 验证裁剪区域
        if len(request.crop_box) != 4:
            raise HTTPException(status_code=400, detail="裁剪区域必须包含4个值: [x, y, width, height]")

        x, y, w, h = request.crop_box
        if not (0 <= x <= 1 and 0 <= y <= 1 and 0 <= w <= 1 and 0 <= h <= 1):
            raise HTTPException(status_code=400, detail="裁剪区域参数必须在0-1之间")

        # 解码图片
        image = ocr_service.base64_to_image(request.image)

        # 裁剪并识别
        crop_box_tuple = (x, y, w, h)
        text = ocr_service.recognize_with_crop(image, crop_box_tuple, request.preprocess)

        logger.info(f"裁剪识别成功，识别到: {text}")

        return RecognitionResponse(
            success=True,
            text=text,
            message="裁剪识别成功"
        )

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"裁剪识别失败: {e}")
        return RecognitionResponse(
            success=False,
            text="",
            message=f"裁剪识别失败: {str(e)}"
        )


@app.post("/api/ocr/upload", response_model=RecognitionResponse, tags=["OCR识别"])
async def recognize_from_file(
    file: UploadFile = File(..., description="上传的图片文件"),
    preprocess: Optional[str] = Form(None, description="预处理方式")
):
    """
    从上传的文件进行OCR识别

    Args:
        file: 上传的图片文件
        preprocess: 预处理方式

    Returns:
        识别结果
    """
    if ocr_service is None:
        raise HTTPException(status_code=503, detail="OCR服务未初始化")

    try:
        # 读取文件内容
        contents = await file.read()

        # 转换为OpenCV格式
        nparr = np.frombuffer(contents, np.uint8)
        image = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

        if image is None:
            raise HTTPException(status_code=400, detail="无法解码图片")

        # 执行识别
        text = ocr_service.recognize_text(image, preprocess)

        logger.info(f"文件上传识别成功，识别到: {text}")

        return RecognitionResponse(
            success=True,
            text=text,
            message="识别成功"
        )

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"文件上传识别失败: {e}")
        return RecognitionResponse(
            success=False,
            text="",
            message=f"识别失败: {str(e)}"
        )


@app.post("/api/ocr", tags=["OCR识别"])
async def recognize_with_template(request: TemplateOCRRequest):
    """
    模板OCR识别（前端使用）

    支持多个裁剪区域的批量识别，返回卡号和密码

    Args:
        request: 包含裁剪图片列表和模板标志的请求

    Returns:
        识别结果列表
    """
    if ocr_service is None:
        raise HTTPException(status_code=503, detail="OCR服务未初始化")

    try:
        results = []

        for card_image in request.croppedImages:
            try:
                # 解码图片
                image = ocr_service.base64_to_image(card_image.imageData)

                # 执行识别
                text = ocr_service.recognize_text(image)

                logger.info(f"区域 {card_image.label} 识别成功，识别到: {text}")

                # 根据标签判断是卡号还是密码
                label_lower = card_image.label.lower()
                is_card_number = any(keyword in label_lower for keyword in ['卡号', 'card', 'number'])

                result = {
                    'label': card_image.label,
                    'text': text,
                    'isCardNumber': is_card_number
                }
                results.append(result)

            except Exception as e:
                logger.error(f"区域 {card_image.label} 识别失败: {e}")
                # 即使失败也添加结果，标记为空
                results.append({
                    'label': card_image.label,
                    'text': '',
                    'isCardNumber': '卡号' in card_image.label or 'card' in card_image.label.lower()
                })

        # 整理为前端期望的格式
        card_number = None
        password = None

        for result in results:
            if result['isCardNumber'] and not card_number:
                card_number = result['text']
            elif not result['isCardNumber'] and not password:
                password = result['text']

        return {
            'success': True,
            'cards': [{
                'cardNumber': card_number or '',
                'password': password or ''
            }],
            'message': '识别完成'
        }

    except Exception as e:
        logger.error(f"模板识别失败: {e}")
        return {
            'success': False,
            'error': str(e),
            'cards': []
        }


# 全局异常处理
@app.exception_handler(Exception)
async def global_exception_handler(request, exc):
    logger.error(f"未处理的异常: {exc}")
    return JSONResponse(
        status_code=500,
        content={
            "success": False,
            "message": f"服务器内部错误: {str(exc)}"
        }
    )


if __name__ == "__main__":
    import uvicorn

    logger.info("启动PaddleOCR-VL-1.5服务...")
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8001,
        reload=False,
        log_level="info"
    )
