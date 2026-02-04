const fs = require('fs');
const path = require('path');

// 模拟S3Storage上传（需要实际SDK）
async function uploadDeploymentPackage() {
  const filePath = path.join(__dirname, 'ocr-card-recognizer-windows-standard-v2.0.0.tar.gz');
  const fileName = 'ocr-card-recognizer-windows-standard-v2.0.0.tar.gz';

  console.log('Reading file:', filePath);
  const fileContent = fs.readFileSync(filePath);
  console.log('File size:', fileContent.length, 'bytes');

  console.log('\nTo upload to S3 storage, use the S3Storage SDK:');
  console.log('```typescript');
  console.log('import { S3Storage } from "coze-coding-dev-sdk";');
  console.log('');
  console.log('const storage = new S3Storage({');
  console.log('  endpointUrl: process.env.COZE_BUCKET_ENDPOINT_URL,');
  console.log('  accessKey: "",');
  console.log('  secretKey: "",');
  console.log('  bucketName: process.env.COZE_BUCKET_NAME,');
  console.log('  region: "cn-beijing",');
  console.log('});');
  console.log('');
  console.log('const key = await storage.uploadFile({');
  console.log('  fileContent: Buffer.from(fileContent),');
  console.log('  fileName: "' + fileName + '",');
  console.log('  contentType: "application/gzip",');
  console.log('});');
  console.log('');
  console.log('const url = await storage.generatePresignedUrl({');
  console.log('  key: key,');
  console.log('  expireTime: 86400 * 7, // 7 days');
  console.log('});');
  console.log('```');
}

uploadDeploymentPackage().catch(console.error);
