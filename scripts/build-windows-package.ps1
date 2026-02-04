# Windows部署包打包脚本（PowerShell）

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Windows部署包打包脚本" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# 配置
$deployDir = "deploy\windows"
$packageName = "ocr-card-recognizer-windows"
$version = "v2.0.0"

# 步骤1：创建部署目录
Write-Host "[步骤 1/5] 创建部署目录..." -ForegroundColor Yellow

if (!(Test-Path "$deployDir\logs")) {
    New-Item -ItemType Directory -Path "$deployDir\logs" -Force | Out-Null
}

if (!(Test-Path "$deployDir\data\uploads")) {
    New-Item -ItemType Directory -Path "$deployDir\data\uploads" -Force | Out-Null
}

if (!(Test-Path "$deployDir\data\exports")) {
    New-Item -ItemType Directory -Path "$deployDir\data\exports" -Force | Out-Null
}

# 步骤2：复制前端文件
Write-Host "[步骤 2/5] 复制前端文件..." -ForegroundColor Yellow

if (Test-Path "src") {
    Copy-Item -Path "src" -Destination "$deployDir\frontend\src" -Recurse -Force
}

if (Test-Path "package.json") {
    Copy-Item -Path "package.json" -Destination "$deployDir\frontend\" -Force
}

if (Test-Path "pnpm-lock.yaml") {
    Copy-Item -Path "pnpm-lock.yaml" -Destination "$deployDir\frontend\" -Force
}

if (Test-Path "next.config.js") {
    Copy-Item -Path "next.config.js" -Destination "$deployDir\frontend\" -Force
}

if (Test-Path "tsconfig.json") {
    Copy-Item -Path "tsconfig.json" -Destination "$deployDir\frontend\" -Force
}

# 步骤3：复制后端文件
Write-Host "[步骤 3/5] 复制后端文件..." -ForegroundColor Yellow

if (Test-Path "backend") {
    Copy-Item -Path "backend\*.py" -Destination "$deployDir\backend\" -Force -ErrorAction SilentlyContinue
    Copy-Item -Path "backend\requirements.txt" -Destination "$deployDir\backend\" -Force -ErrorAction SilentlyContinue
}

# 步骤4：复制配置文件
Write-Host "[步骤 4/5] 复制配置文件..." -ForegroundColor Yellow

if (Test-Path ".env.example") {
    Copy-Item -Path ".env.example" -Destination "$deployDir\.env" -Force
}

# 复制文档
if (Test-Path "README.md") {
    Copy-Item -Path "README.md" -Destination "$deployDir\" -Force
}

if (Test-Path "PADDLEOCR_DEPLOY.md") {
    Copy-Item -Path "PADDLEOCR_DEPLOY.md" -Destination "$deployDir\" -Force
}

if (Test-Path "MIGRATION_GUIDE.md") {
    Copy-Item -Path "MIGRATION_GUIDE.md" -Destination "$deployDir\" -Force
}

# 步骤5：创建压缩包
Write-Host "[步骤 5/5] 创建压缩包..." -ForegroundColor Yellow

$zipFile = "${packageName}-${version}.zip"

# 使用PowerShell 5.1+的Compress-Archive
Compress-Archive -Path "$deployDir\*" -DestinationPath "$zipFile" -Force

# 获取文件大小
$fileSize = (Get-Item $zipFile).Length / 1MB

Write-Host ""
Write-Host "=====================================" -ForegroundColor Green
Write-Host "打包完成！" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green
Write-Host ""
Write-Host "部署包位置：$zipFile" -ForegroundColor White
Write-Host "文件大小：$([math]::Round($fileSize, 2)) MB" -ForegroundColor White
Write-Host ""
Write-Host "使用说明：" -ForegroundColor Yellow
Write-Host "1. 将 $zipFile 复制到Windows电脑" -ForegroundColor White
Write-Host "2. 解压到任意目录" -ForegroundColor White
Write-Host "3. 双击 install.bat 开始安装" -ForegroundColor White
Write-Host "4. 双击 start.bat 启动服务" -ForegroundColor White
Write-Host ""
Write-Host "访问地址：http://localhost:5000" -ForegroundColor Cyan
Write-Host ""
