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

async function uploadFixedV201() {
  console.log("========================================");
  console.log("开始上传修复后的部署包 v2.0.1");
  console.log("========================================\n");

  try {
    // 文件路径
    const tarFilePath = "/workspace/projects/card-ocr-v2.0.1-fixed.tar.gz";

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
      fileName: "card-ocr-v2.0.1-fixed.tar.gz",
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

    console.log("📥 修复版 v2.0.1 下载链接：");
    console.log(signedUrl);
    console.log("\n");

    console.log("📋 文件信息：");
    console.log(`  文件名: card-ocr-v2.0.1-fixed.tar.gz`);
    console.log(`  大小: ${(stats.size / 1024).toFixed(2)} KB`);
    console.log(`  类型: 压缩包 (tar.gz)`);
    console.log(`  有效期: 30天`);
    console.log("\n");

    console.log("🔧 v2.0.1 修复内容：");
    console.log("  ✓ 修复 Docker 构建上下文问题");
    console.log("  ✓ 修复 pnpm-lock.yaml 找不到的错误");
    console.log("  ✓ 更新 frontend/Dockerfile");
    console.log("  ✓ 更新 frontend/Dockerfile.cn");
    console.log("  ✓ 创建 .dockerignore 文件");
    console.log("  ✓ 修改 docker-compose.yml 构建配置");
    console.log("\n");

    console.log("🚀 使用方法：");
    console.log("1. 下载上面的链接");
    console.log("2. 使用7-Zip解压");
    console.log("3. 选择部署方式：");
    console.log("   - Docker 标准版：install.bat");
    console.log("   - Docker 国内版：setup-docker-mirror.bat + install-cn.bat");
    console.log("   - 非 Docker 版本：install-no-docker.bat");
    console.log("\n");

    console.log("========================================\n");

    // 保存下载链接到文件
    const linkFile = "/workspace/projects/download-link-v2.0.1.txt";
    const linkContent = `购物卡OCR识别系统 - 修复版 v2.0.1

修复日期：2025-02-04
下载链接（30天有效）：
${signedUrl}

文件信息：
- 文件名：card-ocr-v2.0.1-fixed.tar.gz
- 大小：${(stats.size / 1024).toFixed(2)} KB
- 类型：压缩包 (tar.gz)

🔧 v2.0.1 修复内容：
✓ 修复 Docker 构建上下文问题
✓ 修复 "pnpm-lock.yaml not found" 错误
✓ 更新 frontend/Dockerfile
✓ 更新 frontend/Dockerfile.cn
✓ 创建 .dockerignore 文件
✓ 修改 docker-compose.yml 构建配置

🚀 三种部署方式：

方式 1：Docker 标准版
  - 运行 install.bat
  - 适合：Docker 正常的用户

方式 2：Docker 国内版（推荐国内用户）
  - 运行 setup-docker-mirror.bat
  - 运行 install-cn.bat
  - 适合：Docker Hub 访问受限

方式 3：非 Docker 版本（最可靠）
  - 安装 Python 3.12 + Node.js
  - 运行 install-no-docker.bat
  - 适合：Docker 无法使用

📚 重要文档：
- DOCKER_BUILD_FIX.md - 构建错误修复说明
- README.md - 主文档
- DEPLOYMENT_CHOICE_GUIDE.md - 部署方案选择
- README_NO_DOCKER.md - 非 Docker 版本说明

修复后构建应该能正常完成！
`;
    const fs = require('fs');
    fs.writeFileSync(linkFile, linkContent, 'utf8');
    console.log("✓ 下载链接已保存到: download-link-v2.0.1.txt");

  } catch (error) {
    console.error("✗ 上传失败:", error);
    throw error;
  }
}

// 执行上传
uploadFixedV201()
  .then(() => {
    console.log("\n✓ 所有任务完成！");
    process.exit(0);
  })
  .catch((error) => {
    console.error("\n✗ 上传失败:", error);
    process.exit(1);
  });
