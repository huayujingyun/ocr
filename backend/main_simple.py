"""
简化的FastAPI后端服务 - 使用基础PaddleOCR
提供OCR识别API接口
"""

from fastapi import FastAPI, File, UploadFile, HTTPException, Form
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field
from typing import List, Optional, Dict, Any
import base64
import numpy as np
from paddleocr import PaddleOCR
import cv2
import io
from PIL import Image
import logging

# 配置日志
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# 创建FastAPI应用
app = FastAPI(
    title="PaddleOCR API",
    description="基于PaddleOCR的本地OCR识别服务",
    version="2.0.0"
)

# 配置CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 全局OCR引擎
ocr_engine = None

def init_ocr():
    """初始化OCR引擎"""
    global ocr_engine
    if ocr_engine is None:
        try:
            logger.info("正在初始化PaddleOCR引擎...")
            # 使用最简化的初始化参数
            ocr_engine = PaddleOCR(
                use_angle_cls=True,
                lang='ch'
            )
            logger.info("✓ PaddleOCR引擎初始化成功")
        except Exception as e:
            logger.error(f"初始化PaddleOCR失败: {e}")
            raise

# 在应用启动时初始化OCR
@app.on_event("startup")
async def startup_event():
    init_ocr()

# 请求/响应模型
class RecognitionRequest(BaseModel):
    image: str = Field(..., description="base64编码的图片")

class RecognitionResponse(BaseModel):
    success: bool
    text: str
    message: Optional[str] = None

class BatchRecognitionRequest(BaseModel):
    images: List[str] = Field(..., description="base64编码的图片列表")

class BatchRecognitionResponse(BaseModel):
    success: bool
    results: List[str]
    message: Optional[str] = None

class CardImage(BaseModel):
    label: str
    imageData: str

class TemplateOCRRequest(BaseModel):
    croppedImages: List[CardImage]

class HealthResponse(BaseModel):
    status: str
    ocr_ready: bool

# 辅助函数
def base64_to_cv2(base64_string: str) -> np.ndarray:
    """将base64字符串转换为OpenCV图像"""
    if base64_string.startswith('data:image/'):
        base64_string = base64_string.split(',', 1)[1]

    image_data = base64.b64decode(base64_string)
    image = Image.open(io.BytesIO(image_data))
    return cv2.cvtColor(np.array(image), cv2.COLOR_RGB2BGR)

def preprocess_image(image: np.ndarray) -> np.ndarray:
    """图像预处理：灰度化和二值化"""
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    _, binary = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
    return binary

# API路由
@app.get("/", tags=["系统"])
async def root():
    return {
        "service": "PaddleOCR API",
        "version": "2.0.0",
        "status": "running"
    }

@app.get("/health", response_model=HealthResponse, tags=["系统"])
async def health_check():
    ocr_ready = ocr_engine is not None
    return HealthResponse(
        status="healthy" if ocr_ready else "unhealthy",
        ocr_ready=ocr_ready
    )

@app.post("/api/ocr/recognize", response_model=RecognitionResponse, tags=["OCR识别"])
async def recognize_text(request: RecognitionRequest):
    """单张图片OCR识别"""
    if ocr_engine is None:
        raise HTTPException(status_code=503, detail="OCR服务未初始化")

    try:
        image = base64_to_cv2(request.image)
        result = ocr_engine.ocr(image, cls=True)

        if not result or not result[0]:
            return RecognitionResponse(
                success=True,
                text="",
                message="未识别到文字"
            )

        # 提取所有文本
        text_list = [line[1][0] for line in result[0]]
        text = ''.join(text_list)

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
    """批量图片OCR识别"""
    if ocr_engine is None:
        raise HTTPException(status_code=503, detail="OCR服务未初始化")

    try:
        results = []
        for idx, img_base64 in enumerate(request.images):
            try:
                image = base64_to_cv2(img_base64)
                result = ocr_engine.ocr(image, cls=True)

                if result and result[0]:
                    text = ''.join([line[1][0] for line in result[0]])
                else:
                    text = ""

                results.append(text)
            except Exception as e:
                logger.error(f"第{idx+1}张图片识别失败: {e}")
                results.append("")

        return BatchRecognitionResponse(
            success=True,
            results=results,
            message=f"批量识别完成，共 {len(results)} 张图片"
        )

    except Exception as e:
        logger.error(f"批量识别失败: {e}")
        return BatchRecognitionResponse(
            success=False,
            results=[],
            message=f"批量识别失败: {str(e)}"
        )

@app.post("/api/ocr", tags=["OCR识别"])
async def recognize_with_template(request: TemplateOCRRequest):
    """模板OCR识别（前端使用）"""
    if ocr_engine is None:
        raise HTTPException(status_code=503, detail="OCR服务未初始化")

    try:
        results = []

        for card_image in request.croppedImages:
            try:
                image = base64_to_cv2(card_image.imageData)
                result = ocr_engine.ocr(image, cls=True)

                if result and result[0]:
                    text = ''.join([line[1][0] for line in result[0]])
                else:
                    text = ""

                label_lower = card_image.label.lower()
                is_card_number = any(keyword in label_lower for keyword in ['卡号', 'card', 'number'])

                results.append({
                    'label': card_image.label,
                    'text': text,
                    'isCardNumber': is_card_number
                })

            except Exception as e:
                logger.error(f"区域 {card_image.label} 识别失败: {e}")
                results.append({
                    'label': card_image.label,
                    'text': '',
                    'isCardNumber': '卡号' in card_image.label or 'card' in card_image.label.lower()
                })

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
    logger.info("启动PaddleOCR服务...")
    uvicorn.run(
        "main_simple:app",
        host="0.0.0.0",
        port=8001,
        reload=False,
        log_level="info"
    )
