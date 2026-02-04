# Windows部署包打包指南

## 📦 当前状态

**已创建**：
- ✅ 所有部署文档（6个）
- ✅ 所有管理脚本（5个）
- ✅ Docker配置文件（3个）
- ✅ 配置和版本文件（4个）
- ✅ 打包脚本（2个）

**待完成**：
- ⏳ 生成实际的可下载部署包
- ⏳ 上传到文件服务器
- ⏳ 提供下载链接

---

## 🚀 如何生成部署包

### 方法1：使用PowerShell打包脚本（推荐）

#### 步骤1：准备文件

创建以下目录结构：

```
ocr-card-recognizer-windows/
├── README.md
├── QUICKSTART.md
├── DOWNLOAD.md
├── PORTABLE_PYTHON.md
├── FILES.md
├── package.json
├── install.bat
├── start.bat
├── stop.bat
├── check.bat
├── docker-manager.bat
├── docker-compose.yml
├── Dockerfile.frontend
├── Dockerfile.backend
├── frontend/
│   ├── package.json
│   ├── pnpm-lock.yaml
│   ├── next.config.js
│   ├── tsconfig.json
│   └── src/
│       └── app/
│           ├── page.tsx
│           └── api/
│               └── ocr/
│                   └── route.ts
└── backend/
    ├── main.py
    ├── ocr_service.py
    └── requirements.txt
```

#### 步骤2：运行打包脚本

**PowerShell**：
```powershell
# 以管理员身份运行PowerShell
cd /path/to/project

# 运行打包脚本
.\scripts\build-windows-package.ps1
```

**输出**：
```
=====================================
Windows部署包打包脚本
=====================================

[步骤 1/5] 创建部署目录...
[步骤 2/5] 复制前端文件...
[步骤 3/5] 复制后端文件...
[步骤 4/5] 复制配置文件...
[步骤 5/5] 创建压缩包...

=====================================
打包完成！
=====================================

部署包位置：ocr-card-recognizer-windows-v2.0.0.zip
文件大小：50.2 MB

使用说明：
1. 将压缩包复制到Windows电脑
2. 解压到任意目录
3. 双击 install.bat 开始安装
4. 双击 start.bat 启动服务
```

---

### 方法2：手动打包

#### 步骤1：创建打包目录

```powershell
# 创建打包目录
mkdir ocr-card-recognizer-windows
mkdir ocr-card-recognizer-windows\logs
mkdir ocr-card-recognizer-windows\data\uploads
mkdir ocr-card-recognizer-windows\data\exports
mkdir ocr-card-recognizer-windows\frontend
mkdir ocr-card-recognizer-windows\backend
```

#### 步骤2：复制文件

```powershell
# 复制文档
copy deploy\windows\README.md ocr-card-recognizer-windows\
copy deploy\windows\QUICKSTART.md ocr-card-recognizer-windows\
copy deploy\windows\DOWNLOAD.md ocr-card-recognizer-windows\
copy deploy\windows\PORTABLE_PYTHON.md ocr-card-recognizer-windows\
copy deploy\windows\FILES.md ocr-card-recognizer-windows\
copy deploy\windows\package.json ocr-card-recognizer-windows\

# 复制脚本
copy deploy\windows\install.bat ocr-card-recognizer-windows\
copy deploy\windows\start.bat ocr-card-recognizer-windows\
copy deploy\windows\stop.bat ocr-card-recognizer-windows\
copy deploy\windows\check.bat ocr-card-recognizer-windows\
copy deploy\windows\docker-manager.bat ocr-card-recognizer-windows\

# 复制Docker文件
copy deploy\windows\docker-compose.yml ocr-card-recognizer-windows\
copy deploy\windows\Dockerfile.frontend ocr-card-recognizer-windows\
copy deploy\windows\Dockerfile.backend ocr-card-recognizer-windows\

# 复制前端文件
copy package.json ocr-card-recognizer-windows\frontend\
copy pnpm-lock.yaml ocr-card-recognizer-windows\frontend\
copy next.config.js ocr-card-recognizer-windows\frontend\
copy tsconfig.json ocr-card-recognizer-windows\frontend\
xcopy src ocr-card-recognizer-windows\frontend\src /E /I

# 复制后端文件
copy backend\main.py ocr-card-recognizer-windows\backend\
copy backend\ocr_service.py ocr-card-recognizer-windows\backend\
copy backend\requirements.txt ocr-card-recognizer-windows\backend\
```

#### 步骤3：压缩

**Windows PowerShell**：
```powershell
Compress-Archive -Path ocr-card-recognizer-windows\* -DestinationPath ocr-card-recognizer-windows-v2.0.0.zip -Force
```

**Windows资源管理器**：
1. 右键点击 `ocr-card-recognizer-windows` 文件夹
2. 选择"发送到" → "压缩(zipped)文件夹"
3. 重命名为 `ocr-card-recognizer-windows-v2.0.0.zip`

---

## 📦 在线安装包 vs 离线完整包

### 在线安装包（~50MB）

**包含内容**：
```
✅ 所有文档和脚本
✅ 前后端源码
❌ Node.js依赖（自动下载）
❌ Python依赖（自动下载）
❌ OCR模型（首次启动自动下载）
```

**特点**：
- 文件小，下载快
- 自动下载依赖
- 首次安装需要联网

**打包方法**：
```powershell
# 使用打包脚本
.\scripts\build-windows-package.ps1

# 或手动压缩（不包含node_modules和python）
```

---

### 离线完整包（~1.5GB）

**包含内容**：
```
✅ 在线安装包的所有内容
✅ Node.js依赖（~500MB）
✅ Python环境（~500MB）
✅ OCR模型（~200MB）
```

**特点**：
- 开箱即用
- 无需联网
- 适合无网络环境

**打包方法**：
```powershell
# 1. 先安装所有依赖
cd ocr-card-recognizer-windows\frontend
pnpm install
cd ..\backend
pip install -r requirements.txt

# 2. 预下载OCR模型
python -c "from paddleocr import PaddleOCR; PaddleOCR(use_angle_cls=True, lang='ch', use_gpu=False, show_log=False)"

# 3. 复制到打包目录
xcopy node_modules ..\ocr-card-recognizer-windows-full\frontend\node_modules /E /I
xcopy %USERPROFILE%\.paddleocr ..\ocr-card-recognizer-windows-full\backend\paddleocr /E /I

# 4. 压缩
Compress-Archive -Path ocr-card-recognizer-windows-full\* -DestinationPath ocr-card-recognizer-windows-full-v2.0.0.zip -Force
```

---

## 🌐 提供下载链接的方法

### 方法1：GitHub Releases（推荐）

#### 步骤1：创建GitHub仓库

```bash
# 创建仓库
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/your-username/ocr-card-recognizer.git
git push -u origin main
```

#### 步骤2：创建Release

1. 访问GitHub仓库
2. 点击"Releases" → "Create a new release"
3. 填写版本信息：
   - **Tag version**: `v2.0.0`
   - **Release title**: `Windows本地部署包 v2.0.0`
   - **Description**: 复制 `WINDOWS_DEPLOY_DELIVERY.md` 的内容

4. 上传部署包：
   - **Binary file**: 选择 `ocr-card-recognizer-windows-v2.0.0.zip`
   - （可选）上传完整包：`ocr-card-recognizer-windows-full-v2.0.0.zip`

5. 点击"Publish release"

#### 步骤3：获取下载链接

Release创建后，下载链接格式为：
```
在线安装包：
https://github.com/your-username/ocr-card-recognizer/releases/download/v2.0.0/ocr-card-recognizer-windows-v2.0.0.zip

离线完整包：
https://github.com/your-username/ocr-card-recognizer/releases/download/v2.0.0/ocr-card-recognizer-windows-full-v2.0.0.zip
```

---

### 方法2：云存储服务

#### 选项A：阿里云OSS

```python
# 使用Python上传到阿里云OSS
import oss2

# 配置OSS
auth = oss2.Auth('your-access-key-id', 'your-access-key-secret')
bucket = oss2.Bucket(auth, 'https://oss-cn-hangzhou.aliyuncs.com', 'your-bucket-name')

# 上传文件
bucket.put_object_from_file('ocr-card-recognizer-windows-v2.0.0.zip', 'ocr-card-recognizer-windows-v2.0.0.zip')

# 生成下载链接
download_url = bucket.sign_url('GET', 'ocr-card-recognizer-windows-v2.0.0.zip', 3600)
print(download_url)
```

**下载链接格式**：
```
https://your-bucket-name.oss-cn-hangzhou.aliyuncs.com/ocr-card-recognizer-windows-v2.0.0.zip
```

#### 选项B：腾讯云COS

```python
# 使用Python上传到腾讯云COS
from qcloud_cos import CosConfig
from qcloud_cos import CosS3Client

# 配置COS
config = CosConfig(Region='ap-guangzhou', SecretId='your-secret-id', SecretKey='your-secret-key')
client = CosS3Client(config)

# 上传文件
client.upload_file(
    Bucket='your-bucket-name',
    LocalFilePath='ocr-card-recognizer-windows-v2.0.0.zip',
    Key='ocr-card-recognizer-windows-v2.0.0.zip'
)

# 生成下载链接
download_url = client.get_presigned_download_url(
    Bucket='your-bucket-name',
    Key='ocr-card-recognizer-windows-v2.0.0.zip',
    Expired=3600
)
print(download_url)
```

#### 选项C：AWS S3

```python
# 使用Python上传到AWS S3
import boto3

# 配置S3
s3 = boto3.client('s3',
    aws_access_key_id='your-access-key-id',
    aws_secret_access_key='your-secret-access-key',
    region_name='us-east-1'
)

# 上传文件
s3.upload_file('ocr-card-recognizer-windows-v2.0.0.zip', 'your-bucket-name', 'ocr-card-recognizer-windows-v2.0.0.zip')

# 生成下载链接（公开访问）
download_url = f"https://your-bucket-name.s3.amazonaws.com/ocr-card-recognizer-windows-v2.0.0.zip"
print(download_url)
```

---

### 方法3：自建文件服务器

#### 使用Python创建简单的文件服务器

```python
# file_server.py
from http.server import HTTPServer, SimpleHTTPRequestHandler
import socketserver
import os

# 配置
PORT = 8000
DIRECTORY = "./downloads"

class CORSHTTPRequestHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        super().end_headers()

if __name__ == "__main__":
    os.chdir(DIRECTORY)
    with socketserver.TCPServer(("", PORT), CORSHTTPRequestHandler) as httpd:
        print(f"文件服务器运行在 http://localhost:{PORT}")
        print(f"下载目录: {DIRECTORY}")
        httpd.serve_forever()
```

**使用方法**：
```bash
# 1. 创建下载目录
mkdir downloads

# 2. 复制部署包到下载目录
cp ocr-card-recognizer-windows-v2.0.0.zip downloads/

# 3. 启动文件服务器
python file_server.py

# 4. 访问链接
http://your-server-ip:8000/ocr-card-recognizer-windows-v2.0.0.zip
```

---

## 📋 部署包信息模板

### 在线安装包

**文件信息**：
```
文件名：ocr-card-recognizer-windows-v2.0.0.zip
版本：v2.0.0
平台：Windows 10/11 64位
文件大小：~50MB
发布日期：2024-02-04
MD5：[打包后生成]
SHA256：[打包后生成]
```

**下载链接**：
```
[在此处填写实际下载链接]
```

### 离线完整包

**文件信息**：
```
文件名：ocr-card-recognizer-windows-full-v2.0.0.zip
版本：v2.0.0
平台：Windows 10/11 64位
文件大小：~1.5GB
发布日期：2024-02-04
MD5：[打包后生成]
SHA256：[打包后生成]
```

**下载链接**：
```
[在此处填写实际下载链接]
```

---

## 🔐 文件校验

### 生成校验和

```powershell
# 生成MD5
Get-FileHash ocr-card-recognizer-windows-v2.0.0.zip -Algorithm MD5

# 生成SHA256
Get-FileHash ocr-card-recognizer-windows-v2.0.0.zip -Algorithm SHA256
```

### 用户校验

```batch
# Windows命令提示符
certutil -hashfile ocr-card-recognizer-windows-v2.0.0.zip MD5
certutil -hashfile ocr-card-recognizer-windows-v2.0.0.zip SHA256
```

---

## 📝 更新DOWNLOAD.md文件

生成下载链接后，更新 `deploy/windows/DOWNLOAD.md` 文件：

```markdown
### 选项1：在线安装包

**文件名**：`ocr-card-recognizer-windows-v2.0.0.zip`

**文件大小**：约50MB

**下载地址**：
```
https://github.com/your-username/ocr-card-recognizer/releases/download/v2.0.0/ocr-card-recognizer-windows-v2.0.0.zip
```

**文件校验**：
```
MD5：[填写MD5值]
SHA256：[填写SHA256值]
```
```

---

## 🚀 下一步操作

1. **运行打包脚本**
   ```powershell
   .\scripts\build-windows-package.ps1
   ```

2. **上传到文件服务器**
   - GitHub Releases（推荐）
   - 阿里云OSS
   - 腾讯云COS
   - AWS S3
   - 自建服务器

3. **更新下载链接**
   - 更新 `DOWNLOAD.md`
   - 更新文档中的链接

4. **测试下载**
   - 测试下载速度
   - 校验文件完整性
   - 测试安装流程

---

## 📞 需要帮助？

如果需要帮助生成部署包或提供下载链接，请告诉我：

1. **是否需要我提供打包命令的详细说明？**
2. **是否需要我帮助设置GitHub Releases？**
3. **是否需要其他云存储服务的配置方法？**
