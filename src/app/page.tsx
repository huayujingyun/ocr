'use client';

import { useState, useRef, useEffect } from 'react';
import Link from 'next/link';
import { BrowserMultiFormatReader } from '@zxing/library';
import { logger, showImageModal, formatDateForFilename, normalizeLabel, fetchWithTimeout, downloadBlob } from '@/lib/utils';

// 类型定义
interface ImageData {
  id: string;
  name: string;
  data: string;
  croppedCardNumberImage?: string;
  croppedPasswordImage?: string;
  cardNumber?: string;
  password?: string;
  recognizeStatus?: 'pending' | 'processing' | 'success' | 'failed';
}

interface TemplateBox {
  relativeX: number;
  relativeY: number;
  relativeWidth: number;
  relativeHeight: number;
  label: string;
  recognizeMode: 'ocr' | 'barcode';
}

interface Template {
  imageData: string;
  boxes: TemplateBox[];
  name?: string;
}

// 常量配置
const RECOGNITION_TIMEOUT = 30000; // 30秒超时

type PreprocessFunction = (c: HTMLCanvasElement, ct: CanvasRenderingContext2D) => void;

const PREPROCESS_STRATEGIES: Array<{ name: string; process: PreprocessFunction }> = [
  { name: '原始图片', process: () => {} },
  { name: '灰度化', process: grayscaleImage },
  { name: '灰度化+对比度', process: (c, ct) => { grayscaleImage(c, ct); enhanceContrast(c, ct, 80); } },
  { name: '灰度化+二值化(128)', process: (c, ct) => { grayscaleImage(c, ct); thresholdImage(c, ct, 128); } },
  { name: '灰度化+二值化(100)', process: (c, ct) => { grayscaleImage(c, ct); thresholdImage(c, ct, 100); } },
];

const SCALES = [2, 4, 1, 0.5];

// 图片裁剪函数
async function cropImage(
  imageData: string,
  relativeX: number,
  relativeY: number,
  relativeWidth: number,
  relativeHeight: number
): Promise<string> {
  return new Promise((resolve, reject) => {
    const img = new Image();
    img.crossOrigin = 'anonymous';
    
    img.onload = () => {
      try {
        const canvas = document.createElement('canvas');
        const ctx = canvas.getContext('2d');
        
        if (!ctx) {
          reject(new Error('无法创建canvas context'));
          return;
        }

        const x = Math.floor(relativeX * img.width);
        const y = Math.floor(relativeY * img.height);
        const width = Math.floor(relativeWidth * img.width);
        const height = Math.floor(relativeHeight * img.height);

        canvas.width = width;
        canvas.height = height;
        ctx.drawImage(img, x, y, width, height, 0, 0, width, height);
        resolve(canvas.toDataURL('image/jpeg', 0.9));
      } catch (error) {
        reject(error);
      }
    };

    img.onerror = () => reject(new Error('图片加载失败'));
    img.src = imageData;
  });
}

// 批量裁剪图片区域
async function cropImageAreas(
  imageData: string,
  boxes: TemplateBox[]
): Promise<Array<{ label: string; imageData: string }>> {
  const results: Array<{ label: string; imageData: string }> = [];

  for (const box of boxes) {
    try {
      const cropped = await cropImage(
        imageData,
        box.relativeX,
        box.relativeY,
        box.relativeWidth,
        box.relativeHeight
      );
      results.push({ label: box.label, imageData: cropped });
    } catch (error) {
      logger.error(`裁剪区域 "${box.label}" 失败`, error);
    }
  }

  return results;
}

// 图片预处理函数
function grayscaleImage(canvas: HTMLCanvasElement, ctx: CanvasRenderingContext2D) {
  const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
  const data = imageData.data;

  for (let i = 0; i < data.length; i += 4) {
    const avg = (data[i] + data[i + 1] + data[i + 2]) / 3;
    data[i] = avg;
    data[i + 1] = avg;
    data[i + 2] = avg;
  }

  ctx.putImageData(imageData, 0, 0);
}

function thresholdImage(canvas: HTMLCanvasElement, ctx: CanvasRenderingContext2D, threshold: number = 128) {
  const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
  const data = imageData.data;

  for (let i = 0; i < data.length; i += 4) {
    const avg = (data[i] + data[i + 1] + data[i + 2]) / 3;
    const value = avg > threshold ? 255 : 0;
    data[i] = value;
    data[i + 1] = value;
    data[i + 2] = value;
  }

  ctx.putImageData(imageData, 0, 0);
}

function enhanceContrast(canvas: HTMLCanvasElement, ctx: CanvasRenderingContext2D, contrast: number = 50) {
  const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
  const data = imageData.data;
  const factor = (259 * (contrast + 255)) / (255 * (259 - contrast));

  for (let i = 0; i < data.length; i += 4) {
    data[i] = factor * (data[i] - 128) + 128;
    data[i + 1] = factor * (data[i + 1] - 128) + 128;
    data[i + 2] = factor * (data[i + 2] - 128) + 128;
  }

  ctx.putImageData(imageData, 0, 0);
}

// 条码识别函数
const recognizeBarcode = async (imageData: string): Promise<string | null> => {
  return new Promise((resolve) => {
    const img = new Image();
    img.crossOrigin = 'anonymous';

    img.onload = async () => {
      try {
        if (img.width < 20 || img.height < 20) {
          document.body.removeChild(img);
          resolve(null);
          return;
        }

        const canvas = document.createElement('canvas');
        const ctx = canvas.getContext('2d');
        if (!ctx) {
          document.body.removeChild(img);
          resolve(null);
          return;
        }

        const reader = new BrowserMultiFormatReader();

        for (const strategy of PREPROCESS_STRATEGIES) {
          for (const scale of SCALES) {
            const scaledWidth = Math.floor(img.width * scale);
            const scaledHeight = Math.floor(img.height * scale);

            canvas.width = scaledWidth;
            canvas.height = scaledHeight;
            ctx.drawImage(img, 0, 0, scaledWidth, scaledHeight);
            strategy.process(canvas, ctx);

            const scaledImg = new Image();
            scaledImg.crossOrigin = 'anonymous';
            scaledImg.style.display = 'none';
            document.body.appendChild(scaledImg);

            await new Promise((loadResolve, loadReject) => {
              scaledImg.onload = () => loadResolve(undefined);
              scaledImg.onerror = loadReject;
              scaledImg.src = canvas.toDataURL('image/png');
            });

            try {
              const result = await reader.decodeFromImageElement(scaledImg);
              const decodedText = result.getText();

              document.body.removeChild(scaledImg);
              document.body.removeChild(img);
              resolve(decodedText);
              return;
            } catch (scaleErr) {
              document.body.removeChild(scaledImg);
              // 继续尝试下一个策略
            }
          }
        }

        document.body.removeChild(img);
        resolve(null);
      } catch (error) {
        logger.error('条码识别过程出错');
        if (document.body.contains(img)) {
          document.body.removeChild(img);
        }
        resolve(null);
      }
    };

    img.onerror = () => {
      if (document.body.contains(img)) {
        document.body.removeChild(img);
      }
      resolve(null);
    };

    img.style.display = 'none';
    document.body.appendChild(img);
    img.src = imageData;
  });
};

// OCR识别单个区域
async function recognizeBox(
  box: TemplateBox,
  croppedImage: string
): Promise<{ label: string; value: string } | null> {
  if (box.recognizeMode === 'barcode') {
    const barcodeResult = await recognizeBarcode(croppedImage);
    if (barcodeResult) {
      return { label: box.label, value: barcodeResult };
    }
    return null;
  }

  // OCR识别
  try {
    const response = await fetchWithTimeout(
      '/api/ocr',
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          croppedImages: [{ label: box.label, imageData: croppedImage }],
          useTemplate: true,
        }),
      },
      RECOGNITION_TIMEOUT
    );

    if (!response.ok) {
      logger.error('OCR请求失败');
      return null;
    }

    const data = await response.json();

    if (data.error) {
      logger.error('OCR返回错误');
      return null;
    }

    if (data.cards?.[0]) {
      const card = data.cards[0];
      return { label: box.label, value: box.label.includes('卡') ? card.cardNumber : card.password };
    }

    return null;
  } catch (error) {
    logger.error('OCR识别出错');
    return null;
  }
}

export default function CardOCRPage() {
  const [selectedImages, setSelectedImages] = useState<ImageData[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string>('');
  const [copiedIndex, setCopiedIndex] = useState<number | null>(null);
  const [processingIndex, setProcessingIndex] = useState<number>(-1);
  const [editingField, setEditingField] = useState<{ index: number; field: 'cardNumber' | 'password' } | null>(null);
  const [currentTemplate, setCurrentTemplate] = useState<Template | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  // 从sessionStorage加载模板
  useEffect(() => {
    const savedTemplate = sessionStorage.getItem('current-template');
    if (savedTemplate) {
      try {
        const template = JSON.parse(savedTemplate);
        const boxesWithMode = template.boxes.map((box: TemplateBox) => ({
          ...box,
          recognizeMode: box.recognizeMode || 'ocr'
        }));
        setCurrentTemplate({ ...template, boxes: boxesWithMode });
      } catch (error) {
        logger.error('加载模板失败', error);
      }
    }
  }, []);

  // 处理图片上传
  const handleImageSelect = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const files = event.target.files;
    if (!files?.length) return;

    const fileArray = Array.from(files);
    const newImages: ImageData[] = [];
    const invalidFiles: string[] = [];
    let processedCount = 0;

    for (const file of fileArray) {
      if (!file.type.startsWith('image/')) {
        invalidFiles.push(file.name);
        processedCount++;
        continue;
      }

      const reader = new FileReader();
      
      reader.onload = async (e) => {
        try {
          const result = e.target?.result as string;
          if (!result?.startsWith('data:image')) {
            invalidFiles.push(file.name);
          } else {
            const imageData: ImageData = {
              id: `img_${Date.now()}_${Math.random()}`,
              name: file.name,
              data: result,
            };

            if (currentTemplate?.boxes) {
              const croppedAreas = await cropImageAreas(result, currentTemplate.boxes);
              imageData.croppedCardNumberImage = croppedAreas.find(img => normalizeLabel(img.label) === 'cardNumber')?.imageData;
              imageData.croppedPasswordImage = croppedAreas.find(img => normalizeLabel(img.label) === 'password')?.imageData;
            }

            newImages.push(imageData);
          }
        } catch (error) {
          logger.error(`处理图片 ${file.name} 时出错`, error);
          invalidFiles.push(file.name);
        }

        processedCount++;
        if (processedCount === fileArray.length) {
          if (invalidFiles.length > 0) {
            setError(`以下文件读取失败: ${invalidFiles.join(', ')}`);
          } else {
            setError('');
          }
          setSelectedImages(prev => [...prev, ...newImages]);
          if (newImages.length > 0) {
            logger.stats(`已添加 ${newImages.length} 张图片`);
          }
        }
      };

      reader.onerror = () => {
        invalidFiles.push(file.name);
        processedCount++;
        if (processedCount === fileArray.length) {
          setError(`以下文件读取失败: ${invalidFiles.join(', ')}`);
          setSelectedImages(prev => [...prev, ...newImages]);
        }
      };

      reader.readAsDataURL(file);
    }
  };

  // 批量识别
  const handleExtract = async () => {
    if (selectedImages.length === 0) {
      setError('请先上传图片');
      return;
    }

    if (!currentTemplate) {
      setError('请先设置识别模板');
      return;
    }

    setIsLoading(true);
    setError('');

    // 更新所有图片状态为待处理
    setSelectedImages(prev => prev.map(img => ({ ...img, recognizeStatus: 'pending' as const })));

    try {
      const imagesToProcess = [...selectedImages];
      const failedImages: string[] = [];

      for (let i = 0; i < imagesToProcess.length; i++) {
        const image = imagesToProcess[i];
        setProcessingIndex(i);

        setSelectedImages(prev =>
          prev.map(img => (img.id === image.id ? { ...img, recognizeStatus: 'processing' } : img))
        );

        try {
          const results: { label: string; value: string }[] = [];

          for (const box of currentTemplate.boxes) {
            const normalizedLabel = normalizeLabel(box.label);
            const croppedImage = normalizedLabel === 'cardNumber' ? image.croppedCardNumberImage : image.croppedPasswordImage;

            if (!croppedImage) {
              logger.warn(`区域 ${box.label} 没有对应的裁剪图片`);
              continue;
            }

            const result = await recognizeBox(box, croppedImage);
            if (result) {
              results.push(result);
            }
          }

          // 更新识别结果
          const cardNumberResult = results.find(r => normalizeLabel(r.label) === 'cardNumber');
          const passwordResult = results.find(r => normalizeLabel(r.label) === 'password');

          if (cardNumberResult || passwordResult) {
            setSelectedImages(prev =>
              prev.map(img =>
                img.id === image.id
                  ? {
                      ...img,
                      cardNumber: cardNumberResult?.value || '',
                      password: passwordResult?.value || '',
                      recognizeStatus: 'success',
                    }
                  : img
              )
            );
          } else {
            failedImages.push(image.name);
            setSelectedImages(prev =>
              prev.map(img => (img.id === image.id ? { ...img, recognizeStatus: 'failed' } : img))
            );
            if (failedImages.length === 1) {
              setError(`图片 ${image.name} 未识别到信息`);
            }
          }
        } catch (error) {
          logger.error(`图片 ${image.name} 识别出错`, error);
          failedImages.push(image.name);
          setSelectedImages(prev =>
            prev.map(img => (img.id === image.id ? { ...img, recognizeStatus: 'failed' } : img))
          );
        }
      }

      setProcessingIndex(-1);

      const successCount = selectedImages.filter(img => img.recognizeStatus === 'success').length;
      logger.stats(`识别完成: 成功 ${successCount}/${selectedImages.length}, 失败 ${failedImages.length}`);

      if (failedImages.length > 0) {
        setError(`以下图片识别失败: ${failedImages.join(', ')}`);
      }
    } catch (error) {
      logger.error('识别流程异常', error);
      setError(error instanceof Error ? error.message : '识别失败，请重试');
    } finally {
      setIsLoading(false);
    }
  };

  // 删除图片
  const handleRemoveImage = (id: string) => {
    setSelectedImages(prev => prev.filter(img => img.id !== id));
  };

  // 重试单个图片
  const handleRetrySingle = async (imageId: string) => {
    const image = selectedImages.find(img => img.id === imageId);
    if (!image) return;

    setIsLoading(true);
    setError('');

    setSelectedImages(prev => prev.map(img => (img.id === image.id ? { ...img, recognizeStatus: 'processing' } : img)));

    try {
      const results: { label: string; value: string }[] = [];

      for (const box of currentTemplate!.boxes) {
        const normalizedLabel = normalizeLabel(box.label);
        const croppedImage = normalizedLabel === 'cardNumber' ? image.croppedCardNumberImage : image.croppedPasswordImage;

        if (!croppedImage) continue;

        const result = await recognizeBox(box, croppedImage);
        if (result) {
          results.push(result);
        }
      }

      const cardNumberResult = results.find(r => normalizeLabel(r.label) === 'cardNumber');
      const passwordResult = results.find(r => normalizeLabel(r.label) === 'password');

      if (cardNumberResult || passwordResult) {
        setSelectedImages(prev =>
          prev.map(img =>
            img.id === image.id
              ? {
                  ...img,
                  cardNumber: cardNumberResult?.value || '',
                  password: passwordResult?.value || '',
                  recognizeStatus: 'success',
                }
              : img
          )
        );
        setError('');
      } else {
        setSelectedImages(prev => prev.map(img => (img.id === image.id ? { ...img, recognizeStatus: 'failed' } : img)));
        setError(`图片 ${image.name} 未识别到卡片信息`);
      }
    } catch (error) {
      logger.error(`图片 ${image.name} 识别出错`, error);
      setSelectedImages(prev => prev.map(img => (img.id === image.id ? { ...img, recognizeStatus: 'failed' } : img)));
      setError(`图片 ${image.name} 识别出错`);
    } finally {
      setIsLoading(false);
    }
  };

  // 更新字段值
  const handleFieldChange = (imageId: string, field: 'cardNumber' | 'password', value: string) => {
    setSelectedImages(prev => prev.map(img => (img.id === imageId ? { ...img, [field]: value } : img)));
  };

  // 复制单个
  const handleCopy = (index: number) => {
    const card = selectedImages[index];
    if (!card) return;

    const cardNumberText = card.cardNumber || '未识别';
    const passwordText = card.password ? `\n密码: ${card.password}` : '';
    const text = `卡片 ${index + 1}:\n卡号: ${cardNumberText}${passwordText}`;

    navigator.clipboard.writeText(text).then(() => {
      setCopiedIndex(index);
      setTimeout(() => setCopiedIndex(null), 2000);
    });
  };

  // 复制全部
  const handleCopyAll = () => {
    const allText = selectedImages
      .map((card, i) => {
        const cardNumberText = card.cardNumber || '未识别';
        const passwordText = card.password ? `\n密码: ${card.password}` : '';
        return `卡片 ${i + 1}:\n卡号: ${cardNumberText}${passwordText}\n`;
      })
      .join('\n');

    navigator.clipboard.writeText(allText).then(() => {
      setCopiedIndex(-1);
      setTimeout(() => setCopiedIndex(null), 2000);
    });
  };

  // 导出Excel
  const handleDownloadExcel = async () => {
    try {
      if (selectedImages.length === 0) {
        setError('没有可导出的数据');
        return;
      }

      const allCards = selectedImages.map((img, index) => ({
        index: index + 1,
        cardNumber: img.cardNumber || '',
        password: img.password || '',
        croppedPasswordImage: img.croppedPasswordImage || '',  // 添加密码截图
      }));

      const response = await fetch('/api/excel', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ cards: allCards }),
      });

      if (!response.ok) {
        throw new Error('下载Excel失败');
      }

      const blob = await response.blob();
      downloadBlob(blob, `卡片信息_${formatDateForFilename()}.xlsx`);
    } catch (err) {
      setError(err instanceof Error ? err.message : '下载Excel失败');
    }
  };

  // 重置
  const handleReset = () => {
    setSelectedImages([]);
    setError('');
    setProcessingIndex(-1);
    if (fileInputRef.current) {
      fileInputRef.current.value = '';
    }
  };

  // 清除模板
  const handleClearTemplate = () => {
    setCurrentTemplate(null);
    sessionStorage.removeItem('current-template');
  };

  return (
    <div className="min-h-screen bg-gray-50 p-6">
      <div className="max-w-7xl mx-auto">
        {/* 头部 */}
        <div className="mb-8">
          <h1 className="text-4xl font-bold text-gray-900 mb-2">购物卡/加油卡 OCR 识别</h1>
          <p className="text-gray-600">
            {currentTemplate 
              ? '✨ 已启用模板识别模式，识别速度更快、准确率更高'
              : '上传卡片图片，自动提取卡号和密码信息'}
          </p>
        </div>

        {/* 模板提示 */}
        {currentTemplate && (
          <div className="mb-6 rounded-xl p-4 bg-gradient-to-r from-blue-50 to-purple-50 border border-blue-200 flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-full flex items-center justify-center bg-gradient-to-r from-blue-500 to-purple-500">
                <svg className="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
              <div>
                <p className="font-semibold text-gray-800">
                  已启用模板识别
                  {currentTemplate.name && (
                    <span className="ml-2 text-sm px-2 py-1 rounded bg-white text-blue-700 border border-blue-200">
                      {currentTemplate.name}
                    </span>
                  )}
                </p>
                <p className="text-sm text-gray-600">
                  包含 {currentTemplate.boxes.length} 个识别区域，混合使用 OCR 和条码识别
                </p>
                <div className="mt-1 flex gap-2">
                  {currentTemplate.boxes.map(box => (
                    <span
                      key={box.label}
                      className={`text-xs px-2 py-1 rounded ${
                        box.recognizeMode === 'barcode'
                          ? 'bg-purple-100 text-purple-700'
                          : 'bg-blue-100 text-blue-700'
                      }`}
                    >
                      {box.label} ({box.recognizeMode === 'barcode' ? '条码' : 'OCR'})
                    </span>
                  ))}
                </div>
              </div>
            </div>
            <button
              onClick={handleClearTemplate}
              className="px-4 py-2 bg-white border-gray-300 text-gray-700 rounded-lg hover:bg-gray-100 transition-colors"
            >
              清除模板
            </button>
          </div>
        )}

        {/* 操作按钮 */}
        <div className="mb-6 flex gap-4">
          {!currentTemplate && (
            <Link
              href="/template"
              className="px-6 py-3 bg-purple-500 text-white rounded-xl hover:bg-purple-600 transition-colors flex items-center gap-2"
            >
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 5a1 1 0 011-1h14a1 1 0 011 1v2a1 1 0 01-1 1H5a1 1 0 01-1-1V5zM4 13a1 1 0 011-1h6a1 1 0 011 1v6a1 1 0 01-1 1H5a1 1 0 01-1-1v-6zM16 13a1 1 0 011-1h2a1 1 0 011 1v6a1 1 0 01-1 1h-2a1 1 0 01-1-1v-6z" />
              </svg>
              设置识别模板
            </Link>
          )}
          <button
            onClick={() => fileInputRef.current?.click()}
            className="px-6 py-3 bg-blue-500 text-white rounded-xl hover:bg-blue-600 transition-colors flex items-center gap-2"
          >
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v16m8-8H4" />
            </svg>
            {selectedImages.length > 0 ? '继续添加' : '上传图片'}
          </button>

          <input
            ref={fileInputRef}
            type="file"
            accept="image/*"
            multiple
            onChange={handleImageSelect}
            className="hidden"
          />
        </div>

        {/* 错误提示 */}
        {error && (
          <div className="mb-6 bg-red-50 border border-red-200 rounded-xl p-4 flex items-center gap-3">
            <svg className="w-6 h-6 text-red-500 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <p className="text-red-700">{error}</p>
          </div>
        )}

        {/* 已上传图片 */}
        {selectedImages.length > 0 && (
          <div className="mb-6 bg-white rounded-xl shadow-lg p-6">
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-xl font-semibold text-gray-800">已上传图片 ({selectedImages.length})</h2>
              <div className="flex gap-2">
                <button
                  onClick={handleExtract}
                  disabled={isLoading}
                  className="px-6 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 disabled:bg-blue-300 disabled:cursor-not-allowed transition-colors flex items-center gap-2"
                >
                  {isLoading ? (
                    <>
                      <svg className="w-5 h-5 animate-spin" fill="none" viewBox="0 0 24 24">
                        <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                        <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                      </svg>
                      识别中... ({processingIndex + 1}/{selectedImages.length})
                    </>
                  ) : (
                    <>
                      <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                      </svg>
                      开始识别
                    </>
                  )}
                </button>
                <button
                  onClick={handleReset}
                  disabled={isLoading}
                  className="px-6 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 disabled:bg-gray-100 disabled:cursor-not-allowed transition-colors"
                >
                  清空
                </button>
              </div>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {selectedImages.map((image, index) => (
                <div key={image.id} className="relative bg-gray-50 rounded-lg overflow-hidden border-2 border-gray-200">
                  <div className="flex justify-between items-start p-2 bg-white border-b border-gray-200">
                    <div className="flex items-center gap-2 flex-1 min-w-0">
                      <span className="flex-shrink-0 w-6 h-6 flex items-center justify-center bg-blue-500 text-white text-xs font-bold rounded-full">
                        {index + 1}
                      </span>
                      <span className="text-sm font-medium text-gray-700 truncate">{image.name}</span>
                    </div>
                    <button
                      onClick={() => handleRemoveImage(image.id)}
                      className="p-1 text-red-500 hover:bg-red-50 rounded"
                    >
                      <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                      </svg>
                    </button>
                  </div>

                  <div className="p-2">
                    {/* 图片预览 */}
                    <div className="relative mb-2 bg-white rounded border border-gray-300 overflow-hidden">
                      {currentTemplate && image.croppedCardNumberImage && image.croppedPasswordImage ? (
                        <div className="grid grid-cols-2 gap-0.5">
                          <div className="p-1">
                            <img
                              src={image.croppedCardNumberImage}
                              alt="卡号"
                              className="w-full h-16 object-contain cursor-pointer"
                              onClick={(e) => {
                                e.stopPropagation();
                                showImageModal(image.croppedCardNumberImage!, '裁剪后的卡号区域（条码识别使用）');
                              }}
                            />
                          </div>
                          <div className="p-1">
                            <img
                              src={image.croppedPasswordImage}
                              alt="密码"
                              className="w-full h-16 object-contain"
                            />
                          </div>
                        </div>
                      ) : (
                        <img src={image.data} alt={image.name} className="w-full h-24 object-contain" />
                      )}

                      {/* 处理中状态 */}
                      {image.recognizeStatus === 'processing' && (
                        <div className="absolute inset-0 flex items-center justify-center" style={{ backgroundColor: 'rgba(59, 130, 246, 0.2)' }}>
                          <svg className="w-6 h-6 text-blue-600 animate-spin" fill="none" viewBox="0 0 24 24">
                            <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                            <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                          </svg>
                        </div>
                      )}
                    </div>

                    {/* 识别结果 */}
                    {image.recognizeStatus === 'success' && image.cardNumber ? (
                      <div className="space-y-1.5">
                        <div className="flex items-center gap-1.5">
                          <span className="text-xs font-medium text-gray-500 w-10">卡号</span>
                          <p className="text-sm font-mono text-gray-800 flex-1 break-all">{image.cardNumber}</p>
                        </div>
                        {image.password && (
                          <div className="flex items-center gap-1.5">
                            <span className="text-xs font-medium text-gray-500 w-10">密码</span>
                            <p className="text-sm font-mono text-gray-800 flex-1 break-all">{image.password}</p>
                          </div>
                        )}
                      </div>
                    ) : image.recognizeStatus === 'failed' ? (
                      <div className="bg-red-50 border border-red-200 rounded p-2 text-center">
                        <p className="text-xs text-red-600 mb-1">识别失败</p>
                        <button
                          onClick={() => handleRetrySingle(image.id)}
                          disabled={isLoading}
                          className="text-xs bg-red-100 text-red-700 px-2 py-1 rounded hover:bg-red-200 disabled:opacity-50 disabled:cursor-not-allowed"
                        >
                          重试
                        </button>
                      </div>
                    ) : null}
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* 识别结果 */}
        {selectedImages.length > 0 && (selectedImages.some(img => img.recognizeStatus === 'success') || selectedImages.some(img => img.recognizeStatus === 'failed' || img.recognizeStatus === 'pending')) && (
          <div className="bg-white rounded-xl shadow-lg p-6">
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-xl font-semibold text-gray-800">
                识别结果 ({selectedImages.filter(img => img.recognizeStatus === 'success' && img.cardNumber).length}/{selectedImages.length})
              </h2>
              <div className="flex gap-2">
                <button
                  onClick={handleCopyAll}
                  className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors"
                >
                  复制全部
                </button>
                <button
                  onClick={handleDownloadExcel}
                  className="px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600 transition-colors"
                >
                  导出Excel
                </button>
              </div>
            </div>
            <div className="space-y-4">
              {selectedImages.map((card) => {
                const originalIndex = selectedImages.findIndex(img => img.id === card.id);
                const isFailed = card.recognizeStatus === 'failed' || !card.cardNumber;
                return (
                  <div key={card.id} className={`border rounded-lg p-4 hover:shadow-md transition-shadow ${isFailed ? 'border-red-400 bg-red-50' : 'border-gray-200'}`}>
                    <div className="flex items-start gap-4">
                      {/* 序号 */}
                      <div className={`flex-shrink-0 w-10 h-10 flex items-center justify-center text-white font-bold rounded-lg ${isFailed ? 'bg-red-500' : 'bg-blue-500'}`}>
                        {originalIndex + 1}
                      </div>

                      <div className="flex-1 space-y-3">
                        {/* 卡号 */}
                        <div>
                          <div className="flex items-center gap-2">
                            {card.croppedCardNumberImage && (
                              <img
                                src={card.croppedCardNumberImage}
                                alt="卡号截图"
                                className="h-8 border border-gray-300 rounded cursor-pointer hover:shadow-lg transition-shrink-0"
                                onClick={(e) => {
                                  e.stopPropagation();
                                  showImageModal(card.croppedCardNumberImage!);
                                }}
                              />
                            )}
                            <div className="flex-1 min-w-0">
                              <input
                                type="text"
                                value={card.cardNumber || ''}
                                onChange={(e) => handleFieldChange(card.id, 'cardNumber', e.target.value)}
                                onFocus={() => setEditingField({ index: originalIndex, field: 'cardNumber' })}
                                onBlur={() => setEditingField(null)}
                                onClick={(e) => e.stopPropagation()}
                                className={`w-full px-3 py-2 text-base font-mono border rounded-lg focus:ring-2 focus:border-transparent hover:border-blue-300 transition-colors ${isFailed ? 'bg-white border-red-400 focus:ring-red-500' : 'bg-white border-gray-300 focus:ring-blue-500'}`}
                                placeholder={isFailed ? '识别失败，请手动输入卡号' : '点击编辑卡号'}
                              />
                            </div>
                          </div>
                        </div>
                        
                        {/* 密码 */}
                        {(card.password || card.croppedPasswordImage || isFailed) && (
                          <div className="space-y-2">
                            {/* 密码图片 */}
                            {card.croppedPasswordImage && (
                              <div>
                                <img
                                  src={card.croppedPasswordImage}
                                  alt="密码截图"
                                  className="h-12 border border-gray-300 rounded cursor-pointer hover:shadow-lg transition-shrink-0 object-contain bg-white"
                                  onClick={(e) => {
                                    e.stopPropagation();
                                    showImageModal(card.croppedPasswordImage!);
                                  }}
                                />
                              </div>
                            )}
                            {/* 密码输入框 */}
                            <div className="flex-1 min-w-0">
                              <input
                                type="text"
                                value={card.password || ''}
                                onChange={(e) => handleFieldChange(card.id, 'password', e.target.value)}
                                onFocus={() => setEditingField({ index: originalIndex, field: 'password' })}
                                onBlur={() => setEditingField(null)}
                                onClick={(e) => e.stopPropagation()}
                                className="w-full px-3 py-2 text-base font-mono bg-white border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent hover:border-blue-300 transition-colors"
                                placeholder={card.croppedPasswordImage ? '点击编辑密码' : '手动输入密码（可选）'}
                              />
                            </div>
                          </div>
                        )}
                        
                        {/* 失败提示 */}
                        {isFailed && !card.croppedCardNumberImage && (
                          <p className="text-xs text-red-600 flex items-center gap-1">
                            <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                            识别失败，请手动填写卡号
                          </p>
                        )}
                      </div>
                      
                      {/* 操作按钮 */}
                      <div className="flex gap-2">
                        <button
                          onClick={() => handleCopy(originalIndex)}
                          className="px-3 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors"
                          title="复制"
                        >
                          {copiedIndex === originalIndex ? (
                            <svg className="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                            </svg>
                          ) : (
                            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                            </svg>
                          )}
                        </button>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        )}

        {/* 空状态 */}
        {selectedImages.length === 0 && (
          <div className="text-center py-16">
            <div className="mx-auto w-32 h-32 bg-gray-100 rounded-full flex items-center justify-center mb-6">
              <svg className="w-16 h-16 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
            </div>
            <h3 className="text-xl font-semibold text-gray-700 mb-2">开始识别卡片信息</h3>
            <p className="text-gray-500 mb-6">
              {currentTemplate 
                ? '模板已设置，上传卡片图片开始快速识别'
                : '建议先设置识别模板，可大幅提升识别速度和准确率'}
            </p>
            <div className="flex gap-4 justify-center">
              {!currentTemplate && (
                <Link
                  href="/template"
                  className="px-8 py-3 bg-purple-500 text-white rounded-xl hover:bg-purple-600 transition-colors"
                >
                  设置识别模板
                </Link>
              )}
              <button
                onClick={() => fileInputRef.current?.click()}
                className="px-8 py-3 bg-blue-500 text-white rounded-xl hover:bg-blue-600 transition-colors"
              >
                上传卡片图片
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
