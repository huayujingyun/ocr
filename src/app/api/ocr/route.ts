import { NextRequest, NextResponse } from 'next/server';
import { LLMClient, Config } from 'coze-coding-dev-sdk';

// 懒加载客户端，避免在构建时初始化
let client: LLMClient | null = null;

function getClient(): LLMClient {
  if (!client) {
    const config = new Config();
    client = new LLMClient(config);
  }
  return client;
}

interface CardData {
  cardNumber: string;
  password: string;
  cardNumberImage?: string;
  passwordImage?: string;
}

// 辅助函数：确保base64字符串带前缀
function ensureImagePrefix(base64Data: string): string {
  if (!base64Data.startsWith('data:image/')) {
    return `data:image/jpeg;base64,${base64Data}`;
  }
  return base64Data;
}

// OCR识别函数 - 专门识别小图中的文字
async function recognizeText(image: string): Promise<string> {
  const systemPrompt = `请精确识别图片中的文字内容。
只返回识别到的文字，不要包含任何说明、解释或其他内容。
如果是数字，请确保0和9、1和7、3和9、5和6等易混淆数字的准确性。
不要在数字之间添加任何空格。`;

  const imageWithPrefix = ensureImagePrefix(image);

  const messages: any[] = [
    { role: 'system', content: systemPrompt },
    {
      role: 'user',
      content: [
        { type: 'text', text: '识别图片中的文字' },
        {
          type: 'image_url',
          image_url: { url: imageWithPrefix, detail: 'low' },
        },
      ],
    },
  ];

  // 添加超时控制
  const timeoutPromise = new Promise<never>((_, reject) => {
    setTimeout(() => reject(new Error('识别超时')), 15000); // 15秒超时
  });

  try {
    const response = await Promise.race([
      getClient().invoke(messages, {
        model: 'doubao-seed-1-6-vision-250815',
        temperature: 0.1,
      }),
      timeoutPromise
    ]) as any;

    const content = response.content.trim();

    // 去除可能的markdown代码块标记
    const cleaned = content.replace(/^```[\s\S]*?\n/, '').replace(/```$/, '').trim();

    // 去除所有空格（包括中间的空格）
    const noSpaces = cleaned.replace(/\s+/g, '');

    return noSpaces;
  } catch (error) {
    console.error('【文字识别失败】', error);
    throw error; // 抛出错误，让调用者处理
  }
}

// 使用裁剪后的图片进行识别
async function recognizeWithCroppedImages(
  croppedImages: Array<{ label: string; imageData: string }>
): Promise<CardData | null> {
  try {
    console.log(`【模板识别】开始识别，共 ${croppedImages.length} 个区域（并行处理）`);

    // 并行识别所有区域，使用 allSettled 处理部分失败
    const recognitionPromises = croppedImages.map(async (item) => {
      const startTime = Date.now();
      try {
        const text = await recognizeText(item.imageData);
        const elapsed = Date.now() - startTime;
        console.log(`  📝 识别区域 "${item.label}": "${text}" (耗时: ${elapsed}ms)`);
        return { label: item.label, text, success: true };
      } catch (error) {
        const elapsed = Date.now() - startTime;
        console.error(`  ❌ 识别区域 "${item.label}" 失败:`, error);
        return { label: item.label, text: '', success: false };
      }
    });

    const results = await Promise.allSettled(recognitionPromises);

    // 构建结果字典
    const resultsMap: { [key: string]: string } = {};
    let successCount = 0;

    results.forEach((result) => {
      if (result.status === 'fulfilled' && result.value.success) {
        const text = result.value.text.trim();
        if (text) {  // 只保存非空结果
          resultsMap[result.value.label] = text;
          successCount++;
        }
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

// 传统OCR识别（不使用模板）
async function recognizeTraditional(image: string): Promise<CardData[] | null> {
  try {
    const systemPrompt = `提取图片中的卡号和密码。

卡号：10-19位数字
密码：4-12位数字或字母

重要：卡号和密码不要包含任何空格！

严格按照以下JSON格式输出（不要其他文字）：
{
  "cards": [{
    "cardNumber": "卡号",
    "password": "密码"
  }]
}`;

    const imageWithPrefix = ensureImagePrefix(image);

    const messages: any[] = [
      { role: 'system', content: systemPrompt },
      {
        role: 'user',
        content: [
          { type: 'text', text: '识别这张图片' },
          {
            type: 'image_url',
            image_url: { url: imageWithPrefix, detail: 'low' },
          },
        ],
      },
    ];

    // 添加超时控制
    const timeoutPromise = new Promise<never>((_, reject) => {
      setTimeout(() => reject(new Error('识别超时')), 25000); // 25秒超时，传统OCR时间更长
    });

    const startTime = Date.now();
    const response = await Promise.race([
      getClient().invoke(messages, {
        model: 'doubao-seed-1-6-vision-250815',
        temperature: 0.1,
      }),
      timeoutPromise
    ]) as any;
    const elapsed = Date.now() - startTime;
    console.log(`【传统OCR】耗时: ${elapsed}ms`);

    const content = response.content.trim();
    console.log('【AI返回内容】', content);

    // 尝试解析JSON
    let jsonMatch = content.match(/```json\s*([\s\S]*?)\s*```/);

    if (!jsonMatch) {
      // 尝试直接匹配JSON
      jsonMatch = content.match(/\{[\s\S]*\}/);
    }

    if (!jsonMatch) {
      console.error('【AI返回格式错误】无法解析JSON，原始内容:', content);
      return null;
    }

    const jsonString = jsonMatch[1] || jsonMatch[0];
    console.log('【解析后的JSON字符串】', jsonString);

    let parsed: any;
    try {
      parsed = JSON.parse(jsonString);
    } catch (parseError) {
      console.error('【JSON解析失败】', parseError);
      return null;
    }

    if (!parsed.cards || !Array.isArray(parsed.cards)) {
      console.error('【数据格式错误】缺少cards数组，解析结果:', parsed);
      return null;
    }

    if (parsed.cards.length === 0) {
      console.warn('【数据为空】cards数组为空');
      return null;
    }

    const cards: CardData[] = parsed.cards.map((card: any) => {
      const cardNumber = (card.cardNumber || '').replace(/\s+/g, '');
      const password = (card.password || '').replace(/\s+/g, '');

      console.log(`  卡片: 卡号="${cardNumber}", 密码="${password}"`);

      return {
        cardNumber,
        password,
        cardNumberImage: imageWithPrefix,
        passwordImage: imageWithPrefix,
      };
    });

    console.log(`【传统OCR】成功识别 ${cards.length} 张卡片`);
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
