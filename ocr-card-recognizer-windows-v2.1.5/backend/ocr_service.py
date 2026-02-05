"""
PaddleOCR-VL-1.5 服务封装
支持中英文文字识别，支持图片预处理
"""

import numpy as np
from paddleocr import PaddleOCR
from PIL import Image
import io
import base64
from typing import Optional, List, Tuple
import logging

# 配置日志
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class OCRService:
    """PaddleOCR服务类"""

    _instance: Optional['OCRService'] = None
    _ocr_engine: Optional[PaddleOCR] = None

    def __new__(cls):
        """单例模式，确保只初始化一次OCR引擎"""
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

    def __init__(self):
        """初始化OCR服务"""
        if self._ocr_engine is None:
            self._initialize_ocr()

    def _initialize_ocr(self):
        """初始化PaddleOCR引擎"""
        try:
            logger.info("正在初始化PaddleOCR-VL-1.5引擎...")
            self._ocr_engine = PaddleOCR(
                use_angle_cls=True,  # 使用方向分类器
                lang='ch',           # 中英文识别
            )
            logger.info("PaddleOCR-VL-1.5引擎初始化成功（CPU模式）")
        except Exception as e:
            logger.error(f"初始化PaddleOCR失败: {e}")
            raise

    @staticmethod
    def base64_to_image(base64_string: str) -> np.ndarray:
        """
        将base64字符串转换为OpenCV图像格式

        Args:
            base64_string: base64编码的图片字符串（可包含data:image/xxx;base64,前缀）

        Returns:
            OpenCV图像数组（BGR格式）
        """
        # 移除data URI前缀
        if base64_string.startswith('data:image/'):
            base64_string = base64_string.split(',', 1)[1]

        # 解码base64
        image_data = base64.b64decode(base64_string)

        # 转换为PIL Image
        image = Image.open(io.BytesIO(image_data))

        # 转换为OpenCV格式（BGR）
        opencv_image = cv2.cvtColor(np.array(image), cv2.COLOR_RGB2BGR)

        return opencv_image

    @staticmethod
    def image_to_base64(image: np.ndarray) -> str:
        """
        将OpenCV图像转换为base64字符串

        Args:
            image: OpenCV图像数组（BGR格式）

        Returns:
            base64编码的图片字符串（不含前缀）
        """
        # 编码为JPEG格式
        _, buffer = cv2.imencode('.jpg', image, [int(cv2.IMWRITE_JPEG_QUALITY), 95])

        # 转换为base64
        base64_string = base64.b64encode(buffer).decode('utf-8')

        return base64_string

    @staticmethod
    def preprocess_grayscale(image: np.ndarray) -> np.ndarray:
        """
        灰度化处理

        Args:
            image: 输入图像

        Returns:
            灰度图像
        """
        return cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    @staticmethod
    def preprocess_threshold(image: np.ndarray, threshold: int = 128) -> np.ndarray:
        """
        二值化处理

        Args:
            image: 输入图像（灰度图）
            threshold: 二值化阈值

        Returns:
            二值化图像
        """
        _, binary = cv2.threshold(image, threshold, 255, cv2.THRESH_BINARY)
        return binary

    @staticmethod
    def preprocess_contrast(image: np.ndarray, alpha: float = 1.5, beta: int = 0) -> np.ndarray:
        """
        对比度增强

        Args:
            image: 输入图像
            alpha: 对比度因子（1.0为原图）
            beta: 亮度调整

        Returns:
            增强后的图像
        """
        return cv2.convertScaleAbs(image, alpha=alpha, beta=beta)

    @staticmethod
    def preprocess_denoise(image: np.ndarray) -> np.ndarray:
        """
        去噪处理

        Args:
            image: 输入图像

        Returns:
            去噪后的图像
        """
        return cv2.fastNlMeansDenoisingColored(image, None, 10, 10, 7, 21)

    def recognize_text(
        self,
        image: np.ndarray,
        preprocess: Optional[str] = None
    ) -> str:
        """
        识别图像中的文字

        Args:
            image: OpenCV图像数组（BGR格式）
            preprocess: 预处理方式（'grayscale', 'threshold', 'contrast', 'denoise'或None）

        Returns:
            识别到的文字（合并所有检测到的文本）
        """
        try:
            # 图片预处理
            processed_image = image.copy()

            if preprocess == 'grayscale':
                processed_image = self.preprocess_grayscale(processed_image)
                processed_image = cv2.cvtColor(processed_image, cv2.COLOR_GRAY2BGR)
            elif preprocess == 'threshold':
                processed_image = self.preprocess_grayscale(processed_image)
                processed_image = self.preprocess_threshold(processed_image, 128)
                processed_image = cv2.cvtColor(processed_image, cv2.COLOR_GRAY2BGR)
            elif preprocess == 'contrast':
                processed_image = self.preprocess_contrast(processed_image, 1.5, 0)
            elif preprocess == 'denoise':
                processed_image = self.preprocess_denoise(processed_image)

            # 执行OCR识别
            result = self._ocr_engine.ocr(processed_image)

            # 提取识别到的文字
            if result and result[0]:
                texts = [line[1][0] for line in result[0]]
                # 合并所有文字，去除空格
                combined_text = ''.join(texts).replace(' ', '').replace('\n', '').replace('\t', '')
                return combined_text

            return ''

        except Exception as e:
            logger.error(f"OCR识别失败: {e}")
            return ''

    def recognize_batch(
        self,
        images: List[np.ndarray],
        preprocess: Optional[str] = None
    ) -> List[str]:
        """
        批量识别图像中的文字

        Args:
            images: OpenCV图像数组列表
            preprocess: 预处理方式

        Returns:
            识别结果列表
        """
        results = []
        for idx, image in enumerate(images):
            logger.info(f"正在处理第 {idx + 1}/{len(images)} 张图片...")
            text = self.recognize_text(image, preprocess)
            results.append(text)
        return results

    def recognize_with_crop(
        self,
        image: np.ndarray,
        crop_box: Tuple[float, float, float, float],
        preprocess: Optional[str] = None
    ) -> str:
        """
        裁剪指定区域并识别文字

        Args:
            image: 原始图像
            crop_box: 裁剪区域 (x, y, width, height)，使用相对坐标（0-1）
            preprocess: 预处理方式

        Returns:
            识别到的文字
        """
        try:
            h, w = image.shape[:2]
            x, y, crop_w, crop_h = crop_box

            # 计算实际坐标
            x1 = int(x * w)
            y1 = int(y * h)
            x2 = int((x + crop_w) * w)
            y2 = int((y + crop_h) * h)

            # 裁剪图片
            cropped = image[y1:y2, x1:x2]

            # 识别文字
            return self.recognize_text(cropped, preprocess)

        except Exception as e:
            logger.error(f"裁剪识别失败: {e}")
            return ''


# 导入cv2（需要在import之后）
try:
    import cv2
except ImportError:
    logger.error("未安装opencv-python-headless，请运行: pip install opencv-python-headless")
    raise
