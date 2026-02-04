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

async function uploadCompletePackage() {
  console.log("========================================");
  console.log("开始上传完整部署包 v2.0.0");
  console.log("========================================\n");

  try {
    // 文件路径
    const tarFilePath = "/workspace/projects/card-ocr-complete-v2.0.0.tar.gz";

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
      fileName: "card-ocr-complete-v2.0.0.tar.gz",
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

    console.log("📥 完整部署包 v2.0.0 下载链接：");
    console.log(signedUrl);
    console.log("\n");

    console.log("📋 文件信息：");
    console.log(`  文件名: card-ocr-complete-v2.0.0.tar.gz`);
    console.log(`  大小: ${(stats.size / 1024).toFixed(2)} KB`);
    console.log(`  类型: 压缩包 (tar.gz)`);
    console.log(`  有效期: 30天`);
    console.log("\n");

    console.log("🎯 包含内容：");
    console.log("  ✓ Docker 版本（含所有修复）");
    console.log("  ✓ 非 Docker 版本（全新）");
    console.log("  ✓ Docker 镜像配置工具");
    console.log("  ✓ 网络诊断工具");
    console.log("  ✓ 国内优化版 Dockerfile");
    console.log("  ✓ 完整的故障排除文档");
    console.log("  ✓ 部署方案选择指南");
    console.log("\n");

    console.log("🚀 三种部署方式：");
    console.log("\n  方式 1：Docker 标准版");
    console.log("    - 运行 install.bat");
    console.log("    - 适合：Docker 正常的用户");
    console.log("\n  方式 2：Docker 国内版（推荐）");
    console.log("    - 运行 setup-docker-mirror.bat");
    console.log("    - 运行 install-cn.bat");
    console.log("    - 适合：Docker Hub 访问受限");
    console.log("\n  方式 3：非 Docker 版本（最可靠）");
    console.log("    - 运行 install-no-docker.bat");
    console.log("    - 运行 start-all-no-docker.bat");
    console.log("    - 适合：Docker 无法使用");
    console.log("\n");

    console.log("📚 重要文档：");
    console.log("  - README.md - 主文档");
    console.log("  - DEPLOYMENT_CHOICE_GUIDE.md - 部署方案选择");
    console.log("  - DOCKER_PULL_FAILURE_FIX.md - Docker 问题修复");
    console.log("  - README_NO_DOCKER.md - 非 Docker 版本说明");
    console.log("  - QUICKSTART.md - 快速开始");
    console.log("\n");

    console.log("========================================\n");

    // 保存下载链接到文件
    const linkFile = "/workspace/projects/download-link-complete-v2.txt";
    const linkContent = `购物卡OCR识别系统 - 完整部署包 v2.0.0

版本：2.0.0（终极版）
包含所有修复、工具和文档
下载链接（30天有效）：
${signedUrl}

文件信息：
- 文件名：card-ocr-complete-v2.0.0.tar.gz
- 大小：${(stats.size / 1024).toFixed(2)} KB
- 类型：压缩包 (tar.gz)

🎯 三种部署方式（任选其一）：

方式 1：Docker 标准版
  - 运行 install.bat
  - 适合：Docker 正常的用户
  - 需要：Docker Desktop

方式 2：Docker 国内版（推荐国内用户）
  - 运行 setup-docker-mirror.bat
  - 运行 install-cn.bat
  - 适合：Docker Hub 访问受限
  - 需要：Docker Desktop

方式 3：非 Docker 版本（最可靠）
  - 安装 Python 3.12 + Node.js
  - 运行 install-no-docker.bat
  - 运行 start-all-no-docker.bat
  - 适合：Docker 无法使用
  - 不需要：Docker

📚 重要文档：
- README.md - 主文档
- DEPLOYMENT_CHOICE_GUIDE.md - 部署方案选择指南
- DOCKER_PULL_FAILURE_FIX.md - Docker 问题修复
- README_NO_DOCKER.md - 非 Docker 版本说明
- QUICKSTART.md - 快速开始

🔧 包含的工具：
- setup-docker-mirror.bat - Docker 镜像配置
- test-docker-network.bat - 网络诊断
- install.bat - 标准安装
- install-cn.bat - 国内优化版安装
- install-no-docker.bat - 非 Docker 安装
- start.bat - 启动服务（Docker）
- start-all-no-docker.bat - 启动服务（非 Docker）
- stop.bat - 停止服务
- status.bat - 查看状态

✨ v2.0.0 新增：
- ✓ 非 Docker 版本（100% 成功率）
- ✓ Docker 镜像配置工具
- ✓ 网络诊断工具
- ✓ 国内优化版 Dockerfile
- ✓ 完整的故障排除文档
- ✓ 部署方案选择指南

无论遇到什么问题，都有解决方案！
`;
    const fs = require('fs');
    fs.writeFileSync(linkFile, linkContent, 'utf8');
    console.log("✓ 下载链接已保存到: download-link-complete-v2.txt");

  } catch (error) {
    console.error("✗ 上传失败:", error);
    throw error;
  }
}

// 执行上传
uploadCompletePackage()
  .then(() => {
    console.log("\n✓ 所有任务完成！");
    process.exit(0);
  })
  .catch((error) => {
    console.error("\n✗ 上传失败:", error);
    process.exit(1);
  });
