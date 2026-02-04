/**
 * Upload deployment package to S3 storage
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
    const packagePath = path.join(process.cwd(), 'ocr-card-recognizer-windows-v2.1.3.tar.gz');
    const fileContent = fs.readFileSync(packagePath);

    console.log('Uploading package to S3...');
    const fileKey = await storage.uploadFile({
      fileContent: fileContent,
      fileName: 'ocr-card-recognizer-windows-v2.1.3.tar.gz',
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
      version: 'v2.1.3',
      releaseDate: new Date().toISOString(),
      fileKey: fileKey,
      downloadUrl: downloadUrl,
      fileName: 'ocr-card-recognizer-windows-v2.1.3.tar.gz',
      fileSize: fs.statSync(packagePath).size,
      description: 'OCR Card Recognizer - Windows Deployment Package with all fixes',
      changes: [
        'Fixed Python environment conflict on Windows',
        'Fixed Tailwind CSS styling issues (downgraded to 3.4.19)',
        'Fixed Windows environment variable syntax',
        'All dependencies updated and tested'
      ]
    };

    fs.writeFileSync(
      path.join(process.cwd(), 'DOWNLOAD_v2.1.3.json'),
      JSON.stringify(packageInfo, null, 2)
    );

    console.log('Package info saved to DOWNLOAD_v2.1.3.json');

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
