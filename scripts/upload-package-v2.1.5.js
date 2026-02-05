/**
 * Upload deployment package to S3 storage - v2.1.5
 */

const { S3Storage } = require('coze-coding-dev-sdk');
const fs = require('fs');
const path = require('path');

async function uploadPackage() {
  try {
    console.log('Initializing S3 Storage...');
    const storage = new S3Storage({
      endpointUrl: process.env.COZE_BUCKET_ENDPOINT_URL,
      bucketName: process.env.COZE_BUCKET_NAME,
      region: 'cn-beijing',
    });

    console.log('Reading package file...');
    const packagePath = path.join(process.cwd(), 'ocr-card-recognizer-windows-v2.1.5.tar.gz');
    const fileContent = fs.readFileSync(packagePath);

    console.log('Uploading package to S3...');
    const fileKey = await storage.uploadFile({
      fileContent: fileContent,
      fileName: 'ocr-card-recognizer-windows-v2.1.5.tar.gz',
      contentType: 'application/gzip',
    });

    console.log('Package uploaded successfully!');
    console.log('File Key:', fileKey);

    console.log('Generating download URL...');
    const downloadUrl = await storage.generatePresignedUrl({
      key: fileKey,
      expireTime: 2592000, // 30 days
    });

    console.log('Download URL:', downloadUrl);

    // Save to JSON file
    const packageInfo = {
      version: 'v2.1.5',
      releaseDate: new Date().toISOString(),
      fileKey: fileKey,
      downloadUrl: downloadUrl,
      fileName: 'ocr-card-recognizer-windows-v2.1.5.tar.gz',
      fileSize: fs.statSync(packagePath).size,
      description: 'OCR Card Recognizer - Windows Deployment Package with PaddlePaddle/PaddleOCR version compatibility fix',
      changes: [
        'Fixed PaddlePaddle version compatibility (downgraded to 2.6.2)',
        'Fixed PaddleOCR version compatibility (downgraded to 2.8.0)',
        'Added install.bat script for easy dependency installation',
        'Added start-backend-fixed.bat script with oneDNN disabled',
        'Fixed frontend API port configuration (8000)',
        'Updated documentation with version compatibility guide',
        'All previous fixes (Python env, Tailwind CSS, env vars, API routes)'
      ],
      requirements: {
        python: '3.12',
        nodejs: '18+',
        paddlepaddle: '2.6.2',
        paddleocr: '2.8.0',
        pnpm: '8+'
      }
    };

    fs.writeFileSync(
      path.join(process.cwd(), 'DOWNLOAD_v2.1.5.json'),
      JSON.stringify(packageInfo, null, 2)
    );

    console.log('Package info saved to DOWNLOAD_v2.1.5.json');

    return { fileKey, downloadUrl };
  } catch (error) {
    console.error('Error uploading package:', error);
    throw error;
  }
}

// Run upload
uploadPackage()
  .then(({ downloadUrl }) => {
    console.log('\n========================================');
    console.log('  Upload Successful!');
    console.log('========================================');
    console.log('Download URL:', downloadUrl);
    console.log('========================================\n');
  })
  .catch(err => {
    console.error('Failed to upload package:', err);
    process.exit(1);
  });
