#!/bin/bash

# Windows Standard Deployment Package Builder (Linux Version with tar.gz)
# Only includes files needed for standard deployment

set -e

echo "====================================="
echo "Standard Deployment Package Builder"
echo "====================================="
echo ""

# Configuration
deployDir="deploy/windows"
packageName="ocr-card-recognizer-windows-standard"
version="v2.1.2"
packageDir="package-temp"

# Clean up temp directory
rm -rf "$packageDir"
mkdir -p "$packageDir"

echo "[Step 1/4] Copying deployment files..."

# Copy batch files (standard deployment)
cp "$deployDir/install.bat" "$packageDir/" 2>/dev/null || echo "Warning: install.bat not found"
cp "$deployDir/start.bat" "$packageDir/" 2>/dev/null || echo "Warning: start.bat not found"
cp "$deployDir/stop.bat" "$packageDir/" 2>/dev/null || echo "Warning: stop.bat not found"
cp "$deployDir/check.bat" "$packageDir/" 2>/dev/null || echo "Warning: check.bat not found"
cp "$deployDir/setup.bat" "$packageDir/" 2>/dev/null || echo "Warning: setup.bat not found"
cp "$deployDir/fix-deps.bat" "$packageDir/" 2>/dev/null || echo "Warning: fix-deps.bat not found"

# Copy documentation (simplified)
cp "$deployDir/README.md" "$packageDir/" 2>/dev/null || echo "Warning: README.md not found"
cp "$deployDir/QUICKSTART.md" "$packageDir/" 2>/dev/null || echo "Warning: QUICKSTART.md not found"

# Copy backend files
if [ -d "backend" ]; then
    cp -r backend "$packageDir/"
    echo "  ✓ Backend files copied"
else
    echo "  ⚠ Backend directory not found"
fi

# Copy frontend source files
if [ -d "src" ]; then
    cp -r src "$packageDir/"
    echo "  ✓ Frontend source copied"
else
    echo "  ⚠ Frontend source not found"
fi

# Copy frontend config files
cp package.json "$packageDir/" 2>/dev/null || echo "Warning: package.json not found"
cp pnpm-lock.yaml "$packageDir/" 2>/dev/null || echo "Warning: pnpm-lock.yaml not found"
cp tsconfig.json "$packageDir/" 2>/dev/null || echo "Warning: tsconfig.json not found"

# Copy environment template
cp .env.example "$packageDir/" 2>/dev/null || echo "Warning: .env.example not found"

echo "[Step 2/4] Creating deployment directories..."

# Create required directories
mkdir -p "$packageDir/logs"
mkdir -p "$packageDir/data/uploads"
mkdir -p "$packageDir/data/exports"

echo "  ✓ Directories created"

echo "[Step 3/4] Creating README.txt..."

cat > "$packageDir/README.txt" << 'EOF'
========================================
OCR Card Recognizer - Standard Deployment
========================================

Version: v2.1.0

Quick Start:
-----------
1. Right-click setup.bat and select "Run as administrator" (RECOMMENDED)
   OR Right-click install.bat and select "Run as administrator"
2. Wait for installation to complete (5-10 minutes)
3. Double-click start.bat
4. Open browser and visit: http://localhost:5000

Troubleshooting:
---------------
If backend fails to start with "ModuleNotFoundError":
  1. Double-click fix-deps.bat (Run as administrator)
  2. Wait for dependencies to install
  3. Double-click start.bat again

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
- Fix dependencies: Double-click fix-deps.bat

Documentation:
--------------
- README.md: Complete guide
- QUICKSTART.md: Quick start guide

Support:
--------
If you encounter issues, check logs/backend.log

========================================
EOF

echo "  ✓ README.txt created"

echo "[Step 4/4] Creating tar.gz package..."

tarFile="${packageName}-${version}.tar.gz"

# Remove existing tar if exists
rm -f "$tarFile"

# Create tar.gz file
tar -czf "$tarFile" -C "$packageDir" .

# Get file size
fileSize=$(du -h "$tarFile" | cut -f1)

# Clean up temp directory
rm -rf "$packageDir"

echo ""
echo "====================================="
echo "Package created successfully!"
echo "====================================="
echo ""
echo "Package name: $tarFile"
echo "File size: $fileSize"
echo ""
echo "Instructions:"
echo "1. Copy $tarFile to your Windows computer"
echo "2. Extract to any directory (e.g., C:\OCR\)"
echo "3. Right-click install.bat -> Run as administrator"
echo "4. Double-click start.bat"
echo "5. Visit: http://localhost:5000"
echo ""
echo "Note: Extract using 7-Zip or WinRAR"
echo ""
echo "====================================="
