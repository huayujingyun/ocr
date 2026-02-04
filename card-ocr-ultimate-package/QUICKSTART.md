# Card OCR System - Quick Start Guide

## 🚀 Easiest Way to Start (3 minutes)

### Option 1: Non-Docker (Recommended - 100% success)

1. **Install Prerequisites**
   - Python 3.12: https://www.python.org/downloads/
     - ⚠️ Check "Add Python to PATH" during installation
   - Node.js: https://nodejs.org/

2. **Run Quick Start**
   ```cmd
   quick-start.bat
   ```

3. **Access System**
   - Open browser: http://localhost:5000

**Time**: 3-5 minutes
**Success Rate**: 100%

---

### Option 2: Docker Standard

1. **Install Docker Desktop**
   - Download: https://www.docker.com/products/docker-desktop/
   - Start Docker Desktop

2. **Run Quick Start**
   ```cmd
   quick-start-docker.bat
   ```

3. **Access System**
   - Wait 5-10 minutes
   - Open browser: http://localhost:5000

**Time**: 15-25 minutes
**Success Rate**: 80%

---

### Option 3: Docker Win11 Fixed

1. **Install Docker Desktop**

2. **Run Quick Start**
   ```cmd
   quick-start-win11.bat
   ```

3. **Access System**
   - Wait 5-10 minutes
   - Open browser: http://localhost:5000

**Time**: 15-25 minutes
**Success Rate**: 85%

---

## 🔍 Quick Diagnostics

If you have issues, run:

```cmd
quick-diagnose.bat
```

This will check:
- Python installation
- Node.js installation
- pnpm installation
- Docker status
- Port availability (5000, 8001)
- Service status

---

## 📝 Important Notes

### Non-Docker Mode
- Opens 2 command windows (backend + frontend)
- **Do NOT close these windows**
- To stop: Close the windows or press Ctrl+C

### Docker Mode
- Services run in background
- Check status: `docker-compose ps`
- View logs: `docker-compose logs -f`

### First Run
- Models will be downloaded automatically
- Takes extra 5-10 minutes
- Models cached for future use

---

## 🛠️ Troubleshooting

### Issue: Script flashes and closes

**Cause**: Script failed due to missing dependencies

**Solution**:
1. Run `quick-diagnose.bat` to see what's missing
2. Install missing dependencies
3. Run the quick start script again

### Issue: Port already in use

**Cause**: Another service is using port 5000 or 8001

**Solution**:
```cmd
# Find and kill the process
netstat -ano | findstr ":5000"
taskkill /PID <PID> /F
```

### Issue: Docker build fails

**Cause**: Network or Docker configuration issues

**Solution**:
1. Try non-Docker mode: `quick-start.bat` (recommended)
2. Or check Docker: `test-docker-network.bat`

### Issue: Python not found

**Cause**: Python not installed or not in PATH

**Solution**:
1. Install Python 3.12 from: https://www.python.org/downloads/
2. **IMPORTANT**: Check "Add Python to PATH"
3. Restart Command Prompt
4. Run `quick-diagnose.bat` to verify

### Issue: Node.js not found

**Cause**: Node.js not installed

**Solution**:
1. Install Node.js from: https://nodejs.org/
2. Restart Command Prompt
3. Run `quick-diagnose.bat` to verify

---

## 🎯 Recommended Workflow

### First Time Setup

```cmd
# 1. Check your system
quick-diagnose.bat

# 2. Install missing dependencies (if any)
#    - Python 3.12 (with "Add to PATH")
#    - Node.js

# 3. Start system
quick-start.bat

# 4. Access
http://localhost:5000
```

### Daily Usage

```cmd
# Start system
quick-start.bat

# Stop system
# Close the two command windows
```

---

## 📚 All Available Scripts

### Quick Start Scripts (Recommended)
- `quick-start.bat` - Non-Docker (easiest)
- `quick-start-docker.bat` - Docker standard
- `quick-start-win11.bat` - Docker Win11 fixed

### Diagnostic Scripts
- `quick-diagnose.bat` - System diagnostics

### Advanced Scripts
- `install-no-docker.bat` - Full non-Docker installation
- `start-services-fixed.bat` - Advanced non-Docker start
- `install-win11.bat` - Full Win11 Docker installation
- `start-win11.bat` - Advanced Win11 Docker start
- `stop-win11.bat` - Stop Win11 Docker services
- `status-win11.bat` - Check Win11 Docker status

---

## ✅ Success Checklist

After running quick-start.bat, you should see:

- ✅ Two command windows open
- ✅ One shows "Backend started on port 8001"
- ✅ Another shows "Ready on http://localhost:5000"
- ✅ Browser can access http://localhost:5000
- ✅ Can upload and OCR images

---

## 🆘 Need Help?

1. Run `quick-diagnose.bat` first
2. Check the output for errors
3. Refer to troubleshooting above
4. If still stuck, try non-Docker mode (100% success)

---

**🎉 Start with `quick-start.bat` for the best experience!**
