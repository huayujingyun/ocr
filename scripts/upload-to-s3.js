const { S3Storage } = require("coze-coding-dev-sdk");
const fs = require("fs");
const path = require("path");

async function uploadDeploymentPackage() {
  try {
    console.log("=====================================");
    console.log("Uploading Deployment Package to S3");
    console.log("=====================================");

    // 初始化 S3Storage
    const storage = new S3Storage({
      endpointUrl: process.env.COZE_BUCKET_ENDPOINT_URL,
      accessKey: "",
      secretKey: "",
      bucketName: process.env.COZE_BUCKET_NAME,
      region: "cn-beijing",
    });

    // 读取部署包文件
    const filePath = path.join(__dirname, "../ocr-card-recognizer-windows-standard-v2.0.2.tar.gz");
    const fileName = "ocr-card-recognizer-windows-standard-v2.0.2.tar.gz";

    console.log(`Reading file: ${filePath}`);
    const fileContent = fs.readFileSync(filePath);
    console.log(`File size: ${(fileContent.length / 1024).toFixed(2)} KB`);

    // 上传文件
    console.log("\nUploading to S3 storage...");
    const fileKey = await storage.uploadFile({
      fileContent: fileContent,
      fileName: fileName,
      contentType: "application/gzip",
    });

    console.log(`✓ File uploaded successfully!`);
    console.log(`File key: ${fileKey}`);

    // 生成下载链接（有效期7天）
    console.log("\nGenerating download URL...");
    const downloadUrl = await storage.generatePresignedUrl({
      key: fileKey,
      expireTime: 86400 * 7, // 7 days
    });

    console.log("\n=====================================");
    console.log("Upload Complete!");
    console.log("=====================================");
    console.log(`Download URL: ${downloadUrl}`);
    console.log(`File key: ${fileKey}`);
    console.log(`Expires in: 7 days`);
    console.log("=====================================");

    // 保存下载链接到文件
    const downloadInfo = {
      version: "v2.0.2",
      fileName: fileName,
      fileKey: fileKey,
      downloadUrl: downloadUrl,
      uploadTime: new Date().toISOString(),
      expiresAt: new Date(Date.now() + 86400 * 7 * 1000).toISOString(),
    };

    fs.writeFileSync(
      path.join(__dirname, "../DOWNLOAD_LINK.json"),
      JSON.stringify(downloadInfo, null, 2)
    );
    console.log(`\n✓ Download info saved to: DOWNLOAD_LINK.json`);

    return downloadUrl;

  } catch (error) {
    console.error("Error uploading file:", error);
    throw error;
  }
}

// 执行上传
uploadDeploymentPackage()
  .then((url) => {
    console.log("\n✓ Success! Deployment package is ready for download.");
    process.exit(0);
  })
  .catch((error) => {
    console.error("\n✗ Failed to upload deployment package:", error.message);
    process.exit(1);
  });
