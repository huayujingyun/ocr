# Windows Standard Deployment Package Builder
# Only includes files needed for standard deployment

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Standard Deployment Package Builder" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$deployDir = "deploy\windows"
$packageName = "ocr-card-recognizer-windows-standard"
$version = "v2.0.0"
$packageDir = "package-temp"

# Clean up temp directory
if (Test-Path $packageDir) {
    Remove-Item -Path $packageDir -Recurse -Force
}
New-Item -ItemType Directory -Path $packageDir -Force | Out-Null

Write-Host "[Step 1/4] Copying deployment files..." -ForegroundColor Yellow

# Copy batch files (standard deployment)
Copy-Item -Path "$deployDir\install.bat" -Destination "$packageDir\" -Force
Copy-Item -Path "$deployDir\start.bat" -Destination "$packageDir\" -Force
Copy-Item -Path "$deployDir\stop.bat" -Destination "$packageDir\" -Force
Copy-Item -Path "$deployDir\check.bat" -Destination "$packageDir\" -Force

# Copy documentation (simplified)
Copy-Item -Path "$deployDir\README.md" -Destination "$packageDir\" -Force
Copy-Item -Path "$deployDir\QUICKSTART.md" -Destination "$packageDir\" -Force

# Copy backend files
if (Test-Path "backend") {
    Copy-Item -Path "backend" -Destination "$packageDir\" -Recurse -Force
}

# Copy frontend source files
if (Test-Path "src") {
    Copy-Item -Path "src" -Destination "$packageDir\" -Recurse -Force
}

# Copy frontend config files
if (Test-Path "package.json") {
    Copy-Item -Path "package.json" -Destination "$packageDir\" -Force
}
if (Test-Path "pnpm-lock.yaml") {
    Copy-Item -Path "pnpm-lock.yaml" -Destination "$packageDir\" -Force
}
if (Test-Path "next.config.js") {
    Copy-Item -Path "next.config.js" -Destination "$packageDir\" -Force
}
if (Test-Path "tsconfig.json") {
    Copy-Item -Path "tsconfig.json" -Destination "$packageDir\" -Force
}

# Copy environment template
if (Test-Path ".env.example") {
    Copy-Item -Path ".env.example" -Destination "$packageDir\" -Force
}

Write-Host "[Step 2/4] Creating deployment directories..." -ForegroundColor Yellow

# Create required directories
New-Item -ItemType Directory -Path "$packageDir\logs" -Force | Out-Null
New-Item -ItemType Directory -Path "$packageDir\data\uploads" -Force | Out-Null
New-Item -ItemType Directory -Path "$packageDir\data\exports" -Force | Out-Null

Write-Host "[Step 3/4] Creating README.txt..." -ForegroundColor Yellow

$readmeContent = @"
========================================
OCR Card Recognizer - Standard Deployment
========================================

Version: $version

Quick Start:
-----------
1. Right-click install.bat and select "Run as administrator"
2. Wait for installation to complete (5-10 minutes)
3. Double-click start.bat
4. Open browser and visit: http://localhost:5000

Usage:
------
1. Upload card images
2. Click "Start Recognition"
3. Edit results if needed
4. Export to Excel

Management:
-----------
- Start service: Double-click start.bat
- Stop service: Double-click stop.bat
- Check status: Double-click check.bat

Documentation:
--------------
- README.md: Complete guide
- QUICKSTART.md: Quick start guide

Support:
--------
If you encounter issues, check logs/logs/backend.log

========================================
"@

$readmeContent | Out-File -FilePath "$packageDir\README.txt" -Encoding UTF8

Write-Host "[Step 4/4] Creating zip package..." -ForegroundColor Yellow

$zipFile = "${packageName}-${version}.zip"

# Remove existing zip if exists
if (Test-Path $zipFile) {
    Remove-Item -Path $zipFile -Force
}

# Create zip file
Compress-Archive -Path "$packageDir\*" -DestinationPath "$zipFile" -Force

# Get file size
$fileSize = (Get-Item $zipFile).Length / 1MB

# Clean up temp directory
Remove-Item -Path $packageDir -Recurse -Force

Write-Host ""
Write-Host "=====================================" -ForegroundColor Green
Write-Host "Package created successfully!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green
Write-Host ""
Write-Host "Package name: $zipFile" -ForegroundColor Cyan
Write-Host "File size: $([math]::Round($fileSize, 2)) MB" -ForegroundColor White
Write-Host ""
Write-Host "Instructions:" -ForegroundColor Yellow
Write-Host "1. Copy $zipFile to your Windows computer" -ForegroundColor White
Write-Host "2. Extract to any directory (e.g., C:\OCR\)" -ForegroundColor White
Write-Host "3. Right-click install.bat -> Run as administrator" -ForegroundColor White
Write-Host "4. Double-click start.bat" -ForegroundColor White
Write-Host "5. Visit: http://localhost:5000" -ForegroundColor White
Write-Host ""
Write-Host "=====================================" -ForegroundColor Green
