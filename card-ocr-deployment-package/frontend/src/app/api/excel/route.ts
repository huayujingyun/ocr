import { NextRequest, NextResponse } from 'next/server';
import * as XLSX from 'xlsx';
import ExcelJS from 'exceljs';

interface CardData {
  index?: number;  // 序号
  cardNumber: string;
  password: string;
  croppedPasswordImage?: string;  // 密码截图（base64）
}

// 将base64图片转换为Uint8Array
function base64ToBuffer(base64: string): Uint8Array {
  const base64Data = base64.replace(/^data:image\/\w+;base64,/, '');
  return new Uint8Array(Buffer.from(base64Data, 'base64'));
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { cards } = body;

    if (!cards || !Array.isArray(cards) || cards.length === 0) {
      return NextResponse.json({ error: '缺少卡片数据' }, { status: 400 });
    }

    // 使用 ExcelJS 创建工作簿
    const workbook = new ExcelJS.Workbook();
    const worksheet = workbook.addWorksheet('卡片信息');

    // 添加表头
    worksheet.columns = [
      { header: '序号', key: 'index', width: 8 },
      { header: '卡号', key: 'cardNumber', width: 30 },
      { header: '密码', key: 'password', width: 20 },
      { header: '密码图片', key: 'passwordImage', width: 15 },
    ];

    // 先添加所有数据
    const rows: any[] = [];
    const imageHeight = 60;  // 图片高度
    const imageWidth = 150;  // 图片宽度

    cards.forEach((card: CardData, rowIndex: number) => {
      const row = worksheet.addRow({
        index: card.index || rowIndex + 1,
        cardNumber: card.cardNumber,
        password: card.password,
        passwordImage: '',  // 图片会单独插入
      });
      rows.push(row);
      // 设置行高与图片高度一致
      row.height = imageHeight;
    });

    // 统一添加图片到对应的单元格
    cards.forEach((card: CardData, rowIndex: number) => {
      if (card.croppedPasswordImage) {
        try {
          const imageBuffer = base64ToBuffer(card.croppedPasswordImage);
          // @ts-ignore - exceljs类型定义问题，实际运行正常
          const imageId = workbook.addImage({
            buffer: imageBuffer as any,
            extension: 'jpeg',
          });

          // 使用实际行号
          const row = rows[rowIndex];
          const excelRowNumber = row.number;

          // 插入图片到 D 列（第4列，索引为3）
          worksheet.addImage(imageId, {
            tl: { col: 3, row: excelRowNumber - 1 },
            ext: { width: imageWidth, height: imageHeight },
            editAs: 'oneCell',
          });

          console.log(`[${rowIndex + 1}] 卡号: ${card.cardNumber}, 图片插入到: D${excelRowNumber}, 尺寸: ${imageWidth}x${imageHeight}`);
        } catch (error) {
          console.error(`插入图片失败，行 ${rowIndex + 1}:`, error);
        }
      }
    });

    // 生成Excel文件
    const excelBuffer = await workbook.xlsx.writeBuffer();

    // 生成当前时间戳作为文件名
    const now = new Date();
    const timestamp = `${now.getFullYear()}${String(now.getMonth() + 1).padStart(2, '0')}${String(now.getDate()).padStart(2, '0')}_${String(now.getHours()).padStart(2, '0')}${String(now.getMinutes()).padStart(2, '0')}`;
    const filename = `卡片信息_${timestamp}.xlsx`;

    return new NextResponse(Buffer.from(excelBuffer) as any, {
      status: 200,
      headers: {
        'Content-Type': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        'Content-Disposition': `attachment; filename="${encodeURIComponent(filename)}"`,
      },
    });
  } catch (error) {
    console.error('生成Excel错误:', error);
    return NextResponse.json({ error: '生成Excel失败' }, { status: 500 });
  }
}
