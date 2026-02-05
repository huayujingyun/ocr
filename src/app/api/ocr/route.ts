import { NextRequest, NextResponse } from 'next/server';

// PaddleOCR本地服务配置
const PADDLEOCR_API_URL = process.env.PADDLEOCR_API_URL || 'http://localhost:8000';

// OCR识别请求接口
interface RecognitionRequest {
  image: string;
  preprocess?: string;
}

// OCR识别响应接口
interface RecognitionResponse {
  success: boolean;
  text: string;
  message?: string;
}

// 批量识别请求接口
interface BatchRecognitionRequest {
  images: string[];
  preprocess?: string;
}

// 批量识别响应接口
interface BatchRecognitionResponse {
  success: boolean;
  results: string[];
  message?: string;
}

interface CardData {
  cardNumber: string;
  password: string;
  cardNumberImage?: string;
  passwordImage?: string;
}

// OCR识别函数 - 调用本地PaddleOCR服务
async function recognizeText(image: string, preprocess: string = 'grayscale'): Promise<string> {
  try {
    const requestBody: RecognitionRequest = {
      image: image,
      preprocess: preprocess
    };

    const response = await fetch(`${PADDLEOCR_API_URL}/api/ocr/recognize`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(requestBody),
      signal: AbortSignal.timeout(30000), // 30秒超时
    });

    if (!response.ok) {
      throw new Error(`OCR服务返回错误: ${response.status}`);
    }

    const result: RecognitionResponse = await response.json();

    if (!result.success) {
      throw new Error(result.message || '识别失败');
    }

    // PaddleOCR已经去除了空格，直接返回
    return result.text;

  } catch (error) {
    console.error('【PaddleOCR识别失败】', error);
    throw error;
  }
}

// 批量OCR识别函数
async function recognizeBatch(images: string[], preprocess: string = 'grayscale'): Promise<string[]> {
  try {
    const requestBody: BatchRecognitionRequest = {
      images: images,
      preprocess: preprocess
    };

    const response = await fetch(`${PADDLEOCR_API_URL}/api/ocr/batch`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(requestBody),
      signal: AbortSignal.timeout(60000), // 60秒超时
    });

    if (!response.ok) {
      throw new Error(`OCR服务返回错误: ${response.status}`);
    }

    const result: BatchRecognitionResponse = await response.json();

    if (!result.success) {
      throw new Error(result.message || '批量识别失败');
    }

    return result.results;

  } catch (error) {
    console.error('【批量识别失败】', error);
    throw error;
  }
}

// 使用裁剪后的图片进行识别
async function recognizeWithCroppedImages(
  croppedImages: Array<{ label: string; imageData: string }>
): Promise<CardData | null> {
  try {
    // 使用批量识别API，提高效率
    const imageList = croppedImages.map(item => item.imageData);
    const results = await recognizeBatch(imageList, 'grayscale');

    // 构建结果字典
    const resultsMap: { [key: string]: string } = {};
    let successCount = 0;

    croppedImages.forEach((item, index) => {
      const text = results[index] || '';
      if (text) {
        resultsMap[item.label] = text;
        successCount++;
      }
    });

    // 构建卡片数据
    const cardData: CardData = {
      cardNumber: resultsMap['卡号'] || resultsMap['cardNumber'] || '',
      password: resultsMap['密码'] || resultsMap['password'] || '',
      cardNumberImage: croppedImages.find(img => img.label === '卡号' || img.label === 'cardNumber')?.imageData,
      passwordImage: croppedImages.find(img => img.label === '密码' || img.label === 'password')?.imageData,
    };

    // 检查是否有有效结果
    if (!cardData.cardNumber && !cardData.password) {
      return null;
    }

    return cardData;
  } catch (error) {
    console.error('【模板识别失败】');
    return null;
  }
}

// 传统OCR识别（不使用模板）- 使用PaddleOCR识别整张图片，然后用正则提取卡号和密码
async function recognizeTraditional(image: string): Promise<CardData[] | null> {
  try {
    // 使用PaddleOCR识别整张图片
    const fullText = await recognizeText(image, 'grayscale');

    // 使用正则表达式提取卡号和密码
    // 卡号：10-19位连续数字
    const cardNumberPattern = /\b\d{10,19}\b/g;
    // 密码：4-12位连续数字或字母
    const passwordPattern = /\b[a-zA-Z0-9]{4,12}\b/g;

    const cardNumbers = fullText.match(cardNumberPattern) || [];
    const passwords = fullText.match(passwordPattern) || [];

    // 过滤掉可能是卡号的密码（密码通常是较短的数字字母组合）
    const filteredPasswords = passwords.filter(p => {
      // 排除纯数字且长度>=10的（可能是卡号）
      if (/^\d+$/.test(p) && p.length >= 10) {
        return false;
      }
      return true;
    });

    if (cardNumbers.length === 0 && filteredPasswords.length === 0) {
      console.warn('【传统OCR】未识别到卡号或密码');
      return null;
    }

    // 构建卡片数据（取第一个卡号和第一个密码）
    const cards: CardData[] = [];
    const cardNumber = cardNumbers[0] || '';
    const password = filteredPasswords[0] || '';

    if (cardNumber || password) {
      cards.push({
        cardNumber,
        password,
      });
    }

    return cards;

  } catch (error) {
    console.error('【传统OCR失败】');
    return null;
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { image, useTemplate, croppedImages } = body;

    let result: CardData | CardData[] | null = null;

    // 如果使用模板且有裁剪后的图片
    if (useTemplate && croppedImages && Array.isArray(croppedImages) && croppedImages.length > 0) {
      result = await recognizeWithCroppedImages(croppedImages);

      if (result) {
        return NextResponse.json({ cards: [result] });
      }
    } else if (image) {
      // 否则使用传统OCR识别（需要完整图片）
      result = await recognizeTraditional(image);

      if (result && result.length > 0) {
        return NextResponse.json({ cards: result });
      }
    } else {
      return NextResponse.json(
        { error: '缺少图片数据：请提供完整的图片或裁剪后的图片' },
        { status: 400 }
      );
    }

    console.log(`【识别失败】未能识别到任何卡片信息`);
    return NextResponse.json(
      { error: '识别失败，请确保图片清晰度足够', reason: 'no_cards_detected' },
      { status: 500 }
    );
  } catch (error) {
    console.error('【识别错误】', error);
    return NextResponse.json(
      { error: 'OCR识别失败，请重试' },
      { status: 500 }
    );
  }
}
