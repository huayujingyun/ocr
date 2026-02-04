import { S3Storage } from "coze-coding-dev-sdk";
import { readFileSync } from "fs";
import * as path from "path";

async function uploadProject() {
  const storage = new S3Storage({
    endpointUrl: process.env.COZE_BUCKET_ENDPOINT_URL,
    accessKey: "",
    secretKey: "",
    bucketName: process.env.COZE_BUCKET_NAME,
    region: "cn-beijing",
  });

  // 读取压缩包
  const filePath = path.join("/tmp", "card-ocr-app.tar.gz");
  const fileContent = readFileSync(filePath);

  console.log("正在上传项目压缩包...");

  // 上传文件
  const key = await storage.uploadFile({
    fileContent: fileContent,
    fileName: "card-ocr-app.tar.gz",
    contentType: "application/gzip",
  });

  console.log("上传成功，Key:", key);

  // 生成下载链接（7天有效期）
  const downloadUrl = await storage.generatePresignedUrl({
    key: key,
    expireTime: 604800, // 7天
  });

  console.log("\n========================================");
  console.log("下载地址:");
  console.log(downloadUrl);
  console.log("========================================\n");
}

uploadProject().catch(console.error);
