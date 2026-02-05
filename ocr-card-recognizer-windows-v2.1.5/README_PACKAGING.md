# OCR Card Recognizer - Windows Deployment Package vv2.1.5

## Package Contents

This package contains the complete source code for OCR Card Recognizer, optimized for Windows deployment.

### Directory Structure

```
ocr-card-recognizer-windows-vv2.1.5/
├── src/                      # Frontend source code
│   ├── app/                  # Next.js app directory
│   ├── components/           # React components
│   └── lib/                  # Utility functions
├── backend/                  # Backend source code
│   ├── main.py              # FastAPI application
│   ├── ocr_service.py       # OCR service
│   ├── install.bat          # Installation script
│   ├── start-backend-fixed.bat  # Startup script
│   └── requirements.txt     # Python dependencies
├── docs/                     # Documentation
│   ├── QUICKSTART_v2.1.5.md # Quick start guide
│   └── CHANGELOG_v2.1.5.md  # Update changelog
├── package.json             # Node.js dependencies
├── tsconfig.json            # TypeScript config
├── tailwind.config.ts       # Tailwind CSS config
├── .coze                    # Coze CLI config
└── VERSION.txt              # Version information
```

## Quick Installation

### Prerequisites

1. **Python 3.12**: Download from https://www.python.org/downloads/
   - During installation, check "Add Python to PATH"
   - Verify installation: `py --version`

2. **Node.js 18+**: Download from https://nodejs.org/
   - Install pnpm: `npm install -g pnpm`

### Installation Steps

1. **Extract the package**
   ```
   Right-click the .tar.gz file and "Extract Here"
   ```

2. **Install backend dependencies**
   ```
   cd backend
   install.bat
   ```

3. **Install frontend dependencies**
   ```
   cd ..
   pnpm install
   ```

4. **Build the frontend**
   ```
   pnpm run build
   ```

### Running the Application

**Terminal 1 - Start Backend:**
```
cd backend
start-backend-fixed.bat
```

**Terminal 2 - Start Frontend:**
```
cd ..
pnpm run start
```

**Open Browser:**
```
http://localhost:5000
```

## Features

- ✅ Offline OCR recognition using PaddleOCR
- ✅ Template-based recognition for faster processing
- ✅ Support for both OCR and barcode recognition
- ✅ Batch image upload and processing
- ✅ Excel export with password screenshots
- ✅ Real-time preview and editing
- ✅ Fixed Windows compatibility issues
- ✅ Fixed PaddlePaddle/PaddleOCR version compatibility
- ✅ Fixed backend API route compatibility

## What's Fixed in vv2.1.5

### Critical Version Compatibility Fix

**Problem**: PaddlePaddle 3.x and PaddleOCR 3.4.0 had severe compatibility issues on Windows
- oneDNN errors causing OCR recognition failures
- API incompatibility between versions

**Solution**: Downgraded to stable version combination
- PaddlePaddle: 3.3.0 → **2.6.2**
- PaddleOCR: 3.4.0 → **2.8.0**

### New Scripts

1. **install.bat**
   - Automated dependency installation
   - Version checking and validation
   - Error handling and user-friendly messages

2. **start-backend-fixed.bat**
   - Disables oneDNN features to prevent errors
   - Sets required environment variables
   - Provides detailed startup logs

### Frontend API Port Fix

- Changed default port from 8001 to 8000
- Now correctly connects to backend service

### Documentation Updates

- QUICKSTART_v2.1.5.md: Complete installation guide
- CHANGELOG_v2.1.5.md: Detailed changelog
- Version compatibility matrix
- Troubleshooting guide

## Version Compatibility

### Windows Platform (Recommended)

| Component | Version | Status |
|-----------|---------|--------|
| Python | 3.12 | ✅ Tested |
| PaddlePaddle | 2.6.2 | ✅ Stable |
| PaddleOCR | 2.8.0 | ✅ Stable |
| Node.js | 18+ | ✅ Tested |
| Windows | 10/11 | ✅ Tested |

### Known Incompatible Combinations

| PaddlePaddle | PaddleOCR | Status |
|--------------|-----------|--------|
| 3.3.0 | 3.4.0 | ❌ oneDNN errors |
| 3.x | 2.8.0 | ❌ API incompatible |
| 2.6.2 | 3.4.0 | ❌ set_optimization_level |

## Troubleshooting

### OCR Recognition Fails

**Symptom**: `ERROR: ConvertPirAttribute2RuntimeAttribute not support`

**Solution**:
1. Check versions:
   ```
   py -c "import paddle; print(f'PaddlePaddle: {paddle.__version__}')"
   py -c "import paddleocr; print(f'PaddleOCR: {paddleocr.__version__}')"
   ```
2. Ensure versions are 2.6.2 and 2.8.0
3. Reinstall if needed:
   ```
   py -m pip uninstall paddlepaddle paddleocr -y
   py -m pip install "paddlepaddle==2.6.2"
   py -m pip install "paddleocr==2.8.0"
   ```
4. Use `start-backend-fixed.bat` to start backend

### Installation Fails

**Symptom**: `ERROR: Failed to install dependencies`

**Solution**:
1. Use `install.bat` script:
   ```
   cd backend
   install.bat
   ```
2. Or manually install:
   ```
   py -m pip install -r requirements.txt
   ```

## Performance Tips

- Use batch recognition for multiple images
- Keep backend service running to avoid reinitialization
- Disable oneDNN may slightly reduce performance (~10-20%)
- Consider GPU acceleration if needed (requires PaddlePaddle-GPU)

## Support

For issues and questions, refer to:
- README.md: Main documentation
- docs/QUICKSTART_v2.1.5.md: Quick start guide
- docs/CHANGELOG_v2.1.5.md: Detailed changelog

## License

See LICENSE file for details.

---
Version: v2.1.5
Release Date: 2026-02-05
Generated by: Coze Coding Expert
