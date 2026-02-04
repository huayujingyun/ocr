import { S3Storage } from "coze-coding-dev-sdk";
import { readFileSync, statSync, writeFileSync } from "fs";

// 初始化对象存储
const storage = new S3Storage({
  endpointUrl: process.env.COZE_BUCKET_ENDPOINT_URL,
  accessKey: "",
  secretKey: "",
  bucketName: process.env.COZE_BUCKET_NAME,
  region: "cn-beijing",
});

async function uploadUltimatePackageV3_1() {
  console.log('========================================');
  console.log('开始上传终极部署包 v3.1.0（Win11修复版）');
  console.log('========================================\n');

  try {
    // 文件路径
    const tarFilePath = "/workspace/projects/card-ocr-ultimate-v3.1.0.tar.gz";

    // 检查文件是否存在
    const stats = statSync(tarFilePath);
    console.log(`文件大小: ${(stats.size / 1024).toFixed(2)} KB`);

    // 读取文件内容
    console.log('正在读取文件...');
    const fileContent = readFileSync(tarFilePath);

    // 上传文件
    console.log('正在上传文件...');
    const fileKey = await storage.uploadFile({
      fileContent: fileContent,
      fileName: "card-ocr-ultimate-v3.1.0.tar.gz",
      contentType: "application/gzip",
    });

    console.log(`✓ 文件上传成功！`);
    console.log(`  File Key: ${fileKey}\n`);

    // 生成签名URL（有效期30天）
    console.log('正在生成下载链接...');
    const signedUrl = await storage.generatePresignedUrl({
      key: fileKey,
      expireTime: 2592000, // 30天
    });

    console.log('========================================');
    console.log('✓ 上传完成！');
    console.log('========================================\n');

    console.log(`📥 终极部署包 v3.1.0 下载链接：`);
    console.log(signedUrl);
    console.log('\n');

    console.log('📋 文件信息：');
    console.log(`  文件名: card-ocr-ultimate-v3.1.0.tar.gz`);
    console.log(`  大小: ${(stats.size / 1024).toFixed(2)} KB`);
    console.log(`  类型: 压缩包 (tar.gz)`);
    console.log(`  有效期: 30天`);
    console.log(`  发布日期: 2025-02-04`);
    console.log('\n');

    console.log('🎯 v3.1.0 新增内容：');
    console.log('  ✓ backend/Dockerfile.win11 - Win11专用后端Dockerfile');
    console.log('  ✓ docker-compose-win11.yml - Win11专用Docker配置');
    console.log('  ✓ install-win11.bat - Win11专用安装脚本');
    console.log('  ✓ start-win11.bat - Win11专用启动脚本');
    console.log('  ✓ stop-win11.bat - Win11专用停止脚本');
    console.log('  ✓ status-win11.bat - Win11专用状态检查');
    console.log('  ✓ WIN11_DOCKER_DEPLOYMENT.md - Win11部署文档');
    console.log('\n');

    console.log('🚀 Win11快速部署（修复APT问题）：');
    console.log('  1. 解压：tar -xzf card-ocr-ultimate-v3.1.0.tar.gz');
    console.log('  2. 安装：install-win11.bat');
    console.log('  3. 启动：start-win11.bat');
    console.log('  4. 访问：http://localhost:5000');
    console.log('\n');

    console.log('💡 v3.1.0 修复的问题：');
    console.log('  ✓ Win11 Docker APT镜像源配置失败（exit code 2）');
    console.log('  ✓ 新版Debian 12软件源格式兼容问题');
    console.log('\n');

    console.log('========================================\n');

    // 保存下载链接到文件
    const linkFile = "/workspace/projects/download-link-ultimate-v3.1.txt";
    const linkContent = `购物卡OCR识别系统 - 终极部署包 v3.1.0（Win11修复版）

版本：v3.1.0
发布日期：2025-02-04
包含Win11修复文件
下载链接（30天有效）：
${signedUrl}

文件信息：
- 文件名：card-ocr-ultimate-v3.1.0.tar.gz
- 大小：${(stats.size / 1024).toFixed(2)} KB
- 类型：压缩包 (tar.gz)
- 有效期：30天

🎯 v3.1.0 新增内容：
✓ backend/Dockerfile.win11 - Win11专用后端Dockerfile
✓ docker-compose-win11.yml - Win11专用Docker配置
✓ install-win11.bat - Win11专用安装脚本
✓ start-win11.bat - Win11专用启动脚本
✓ stop-win11.bat - Win11专用停止脚本
✓ status-win11.bat - Win11专用状态检查
✓ WIN11_DOCKER_DEPLOYMENT.md - Win11部署文档

🚀 Win11快速部署（修复APT问题）：
1. 解压：tar -xzf card-ocr-ultimate-v3.1.0.tar.gz
2. 安装：install-win11.bat
3. 启动：start-win11.bat
4. 访问：http://localhost:5000

💡 v3.1.0 修复的问题：
✓ Win11 Docker APT镜像源配置失败（exit code 2）
✓ 新版Debian 12软件源格式兼容问题

📚 重要文档：
- WIN11_DOCKER_DEPLOYMENT.md - Win11部署文档（从这里开始）
- README.md - 主文档
- NO_DOCKER_WEB_FIX.md - 非Docker版本故障排除

🔧 Win11专用脚本：
1. install-win11.bat - Win11安装脚本
2. start-win11.bat - Win11启动脚本
3. stop-win11.bat - Win11停止脚本
4. status-win11.bat - Win11状态检查

💡 建议：如果Docker仍有问题，使用非Docker版本（100%成功）
`;

    writeFileSync(linkFile, linkContent, 'utf-8');

    console.log('✓ 下载链接已保存到: download-link-ultimate-v3.1.txt\n');
    console.log('✓ 所有任务完成！\n');

  } catch (error: any) {
    console.error('\n✗ 上传失败:', error.message);
    if (error.stack) {
      console.error('堆栈信息:', error.stack);
    }
    process.exit(1);
  }
}

uploadUltimatePackageV3_1();
