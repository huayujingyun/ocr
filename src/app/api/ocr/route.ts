import { NextRequest, NextResponse } from 'next/server';

// PaddleOCR本地服务配置
const PADDLEOCR_API_URL = process.env.PADDLEOCR_API_URL || 'http://localhost:8001';

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
    console.log(`【模板识别】开始识别，共 ${croppedImages.length} 个区域`);

    const startTime = Date.now();

    // 使用批量识别API，提高效率
    const imageList = croppedImages.map(item => item.imageData);
    const results = await recognizeBatch(imageList, 'grayscale');

    const elapsed = Date.now() - startTime;
    console.log(`【模板识别】批量识别完成，耗时: ${elapsed}ms`);

    // 构建结果字典
    const resultsMap: { [key: string]: string } = {};
    let successCount = 0;

    croppedImages.forEach((item, index) => {
      const text = results[index] || '';
      if (text) {
        resultsMap[item.label] = text;
        successCount++;
        console.log(`  📝 识别区域 "${item.label}": "${text}"`);
      } else {
        console.log(`  ❌ 识别区域 "${item.label}" 失败或结果为空`);
      }
    });

    console.log(`【模板识别】成功识别 ${successCount}/${croppedImages.length} 个区域`);
    console.log(`【识别结果】卡号="${resultsMap['卡号'] || resultsMap['cardNumber'] || ''}", 密码="${resultsMap['密码'] || resultsMap['password'] || ''}"`);

    // 构建卡片数据
    const cardData: CardData = {
      cardNumber: resultsMap['卡号'] || resultsMap['cardNumber'] || '',
      password: resultsMap['密码'] || resultsMap['password'] || '',
      cardNumberImage: croppedImages.find(img => img.label === '卡号' || img.label === 'cardNumber')?.imageData,
      passwordImage: croppedImages.find(img => img.label === '密码' || img.label === 'password')?.imageData,
    };

    // 检查是否有有效结果
    if (!cardData.cardNumber && !cardData.password) {
      console.log('【模板识别】所有区域识别失败或结果为空');
      return null;
    }

    console.log(`【模板识别】完成: 卡号="${cardData.cardNumber}", 密码="${cardData.password}"`);
    return cardData;
  } catch (error) {
    console.error('【模板识别失败】', error);
    return null;
  }
}

// 传统OCR识别（不使用模板）- 使用PaddleOCR识别整张图片，然后用正则提取卡号和密码
async function recognizeTraditional(image: string): Promise<CardData[] | null> {
  try {
    console.log('【传统OCR】开始识别整张图片...');

    const startTime = Date.now();

    // 使用PaddleOCR识别整张图片
    const fullText = await recognizeText(image, 'grayscale');

    const elapsed = Date.now() - startTime;
    console.log(`【传统OCR】耗时: ${elapsed}ms`);
    console.log('【识别到的文字】', fullText);

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

    console.log(`【提取结果】卡号数量: ${cardNumbers.length}, 密码数量: ${filteredPasswords.length}`);
    console.log('【提取的卡号】', cardNumbers);
    console.log('【提取的密码】', filteredPasswords);

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

    console.log(`【传统OCR】完成，识别到 ${cards.length} 张卡片`);
    return cards;

  } catch (error) {
    console.error('【传统OCR失败】', error);
    return null;
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { image, useTemplate, croppedImages } = body;

    console.log('【开始识别】');
    console.log(`  - useTemplate: ${useTemplate}`);
    console.log(`  - croppedImages: ${croppedImages?.length || 0} 个区域`);

    let result: CardData | CardData[] | null = null;

    // 如果使用模板且有裁剪后的图片
    if (useTemplate && croppedImages && Array.isArray(croppedImages) && croppedImages.length > 0) {
      console.log(`【使用模板识别】模板包含 ${croppedImages.length} 个区域`);
      result = await recognizeWithCroppedImages(croppedImages);

      if (result) {
        console.log(`【识别完成】成功: 1张卡片`);
        return NextResponse.json({ cards: [result] });
      }
    } else if (image) {
      // 否则使用传统OCR识别（需要完整图片）
      console.log('【使用传统OCR识别】');
      result = await recognizeTraditional(image);

      if (result && result.length > 0) {
        console.log(`【识别完成】成功: ${result.length}张卡片`);
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
