# Windows Deployment Package Builder (PowerShell)

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Windows Deployment Package Builder" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$deployDir = "deploy\windows"
$packageName = "ocr-card-recognizer-windows"
$version = "v2.0.0"

# Step 1: Create deployment directories
Write-Host "[Step 1/5] Creating deployment directories..." -ForegroundColor Yellow

if (!(Test-Path "$deployDir\logs")) {
    New-Item -ItemType Directory -Path "$deployDir\logs" -Force | Out-Null
}

if (!(Test-Path "$deployDir\data\uploads")) {
    New-Item -ItemType Directory -Path "$deployDir\data\uploads" -Force | Out-Null
}

if (!(Test-Path "$deployDir\data\exports")) {
    New-Item -ItemType Directory -Path "$deployDir\data\exports" -Force | Out-Null
}

# Step 2: Copy frontend files
Write-Host "[Step 2/5] Copying frontend files..." -ForegroundColor Yellow

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

# Step 3: Copy backend files
Write-Host "[Step 3/5] Copying backend files..." -ForegroundColor Yellow

if (Test-Path "backend") {
    Copy-Item -Path "backend\*.py" -Destination "$deployDir\backend\" -Force -ErrorAction SilentlyContinue
    Copy-Item -Path "backend\requirements.txt" -Destination "$deployDir\backend\" -Force -ErrorAction SilentlyContinue
}

# Step 4: Copy configuration files
Write-Host "[Step 4/5] Copying configuration files..." -ForegroundColor Yellow

if (Test-Path ".env.example") {
    Copy-Item -Path ".env.example" -Destination "$deployDir\.env" -Force
}

# Copy documentation
if (Test-Path "README.md") {
    Copy-Item -Path "README.md" -Destination "$deployDir\" -Force
}

if (Test-Path "PADDLEOCR_DEPLOY.md") {
    Copy-Item -Path "PADDLEOCR_DEPLOY.md" -Destination "$deployDir\" -Force
}

if (Test-Path "MIGRATION_GUIDE.md") {
    Copy-Item -Path "MIGRATION_GUIDE.md" -Destination "$deployDir\" -Force
}

# Step 5: Create zip package
Write-Host "[Step 5/5] Creating zip package..." -ForegroundColor Yellow

$zipFile = "${packageName}-${version}.zip"

# Use PowerShell 5.1+ Compress-Archive
Compress-Archive -Path "$deployDir\*" -DestinationPath "$zipFile" -Force

# Get file size
$fileSize = (Get-Item $zipFile).Length / 1MB

Write-Host ""
Write-Host "=====================================" -ForegroundColor Green
Write-Host "Package created successfully!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green
Write-Host ""
Write-Host "Package location: $zipFile" -ForegroundColor White
Write-Host "File size: $([math]::Round($fileSize, 2)) MB" -ForegroundColor White
Write-Host ""
Write-Host "Usage instructions:" -ForegroundColor Yellow
Write-Host "1. Copy $zipFile to your Windows computer" -ForegroundColor White
Write-Host "2. Extract to any directory" -ForegroundColor White
Write-Host "3. Double-click install.bat to start installation" -ForegroundColor White
Write-Host "4. Double-click start.bat to start the service" -ForegroundColor White
Write-Host ""
Write-Host "Access URL: http://localhost:5000" -ForegroundColor Cyan
Write-Host ""
