import { S3Storage } from "coze-coding-dev-sdk";
import { readFileSync, statSync } from "fs";

// 初始化对象存储
const storage = new S3Storage({
  endpointUrl: process.env.COZE_BUCKET_ENDPOINT_URL,
  accessKey: "",
  secretKey: "",
  bucketName: process.env.COZE_BUCKET_NAME,
  region: "cn-beijing",
});

async function uploadV102Package() {
  console.log("========================================");
  console.log("开始上传 v1.0.2 部署包");
  console.log("========================================\n");

  try {
    // 文件路径
    const tarFilePath = "/workspace/projects/card-ocr-deployment-v1.0.2.tar.gz";

    // 检查文件是否存在
    const stats = statSync(tarFilePath);
    console.log(`文件大小: ${(stats.size / 1024).toFixed(2)} KB`);

    // 读取文件内容
    console.log("正在读取文件...");
    const fileContent = readFileSync(tarFilePath);

    // 上传文件
    console.log("正在上传文件...");
    const fileKey = await storage.uploadFile({
      fileContent: fileContent,
      fileName: "card-ocr-deployment-v1.0.2.tar.gz",
      contentType: "application/gzip",
    });

    console.log(`✓ 文件上传成功！`);
    console.log(`  File Key: ${fileKey}\n`);

    // 生成签名URL（有效期30天）
    console.log("正在生成下载链接...");
    const signedUrl = await storage.generatePresignedUrl({
      key: fileKey,
      expireTime: 2592000, // 30天
    });

    console.log("========================================");
    console.log("✓ 上传完成！");
    console.log("========================================\n");

    console.log("📥 v1.0.2 下载链接：");
    console.log(signedUrl);
    console.log("\n");

    console.log("📋 文件信息：");
    console.log(`  文件名: card-ocr-deployment-v1.0.2.tar.gz`);
    console.log(`  大小: ${(stats.size / 1024).toFixed(2)} KB`);
    console.log(`  类型: 压缩包 (tar.gz)`);
    console.log(`  有效期: 30天`);
    console.log("\n");

    console.log("🔧 v1.0.2 修复内容：");
    console.log("  ✓ 修复批处理文件编码问题");
    console.log("  ✓ 修复脚本目录路径问题");
    console.log("  ✓ 添加 docker-compose.yml 存在性检查");
    console.log("  ✓ 确保脚本在正确目录执行");
    console.log("\n");

    console.log("🚀 使用方法：");
    console.log("1. 点击上面的下载链接");
    console.log("2. 下载文件到本地");
    console.log("3. 使用7-Zip或WinRAR解压");
    console.log("4. 右键运行install.bat（管理员）");
    console.log("5. 运行start.bat启动服务");
    console.log("\n");

    console.log("========================================\n");

    // 保存下载链接到文件
    const linkFile = "/workspace/projects/download-link-v1.0.2.txt";
    const linkContent = `购物卡OCR识别系统 - Windows一键部署包 v1.0.2

版本：1.0.2
下载链接（30天有效）：
${signedUrl}

文件信息：
- 文件名：card-ocr-deployment-v1.0.2.tar.gz
- 大小：${(stats.size / 1024).toFixed(2)} KB
- 类型：压缩包 (tar.gz)

v1.0.2 修复内容：
✓ 修复批处理文件编码问题（v1.0.1）
✓ 修复脚本目录路径问题（v1.0.2）
✓ 添加 docker-compose.yml 存在性检查（v1.0.2）
✓ 确保脚本在正确目录执行（v1.0.2）

快速开始：
1. 下载文件
2. 使用7-Zip解压
3. 右键运行install.bat（管理员）
4. 运行start.bat启动服务
5. 访问 http://localhost:5000

详细文档请查看解压后的文件。
`;
    const fs = require('fs');
    fs.writeFileSync(linkFile, linkContent, 'utf8');
    console.log("✓ 下载链接已保存到: download-link-v1.0.2.txt");

  } catch (error) {
    console.error("✗ 上传失败:", error);
    throw error;
  }
}

// 执行上传
uploadV102Package()
  .then(() => {
    console.log("\n✓ 所有任务完成！");
    process.exit(0);
  })
  .catch((error) => {
    console.error("\n✗ 上传失败:", error);
    process.exit(1);
  });
