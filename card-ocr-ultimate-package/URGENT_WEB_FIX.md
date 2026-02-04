# 🔥 紧急修复：网页无法打开问题

## 🚀 立即行动（3 步解决）

### 步骤 1：停止所有服务

运行 `stop-services.bat`

或者手动：
```cmd
taskkill /F /IM python.exe
taskkill /F /IM node.exe
```

---

### 步骤 2：使用修复版启动脚本

运行 `start-services-fixed.bat`

这个脚本会：
- ✅ 检查 Python 和 Node.js
- ✅ 逐个启动后端和前端
- ✅ 等待服务初始化
- ✅ 显示详细状态
- ✅ 自动打开浏览器

---

### 步骤 3：如果还是不行，运行诊断

运行 `diagnose-no-docker.bat`

查看输出，找到具体问题。

---

## 🎯 常见原因和快速修复

### 原因 1：服务实际上没启动

**症状**：脚本显示成功，但没有窗口

**修复**：使用 `start-services-fixed.bat`，它会打开两个窗口：
- "PaddleOCR Backend" 窗口（后端）
- "Frontend" 窗口（前端）

**重要**：两个窗口都必须保持打开！

---

### 原因 2：后端启动失败

**症状**：后端窗口显示错误

**修复**：
1. 查看 backend 窗口的错误信息
2. 常见错误：
   - `ModuleNotFoundError`：运行 `cd backend && pip install -r requirements.txt`
   - `Port 8001 in use`：运行 `stop-services.bat`
   - `Python version error`：必须是 Python 3.12

---

### 原因 3：前端启动失败

**症状**：前端窗口显示错误

**修复**：
1. 查看 frontend 窗口的错误信息
2. 常见错误：
   - `Cannot find module`：运行 `pnpm install`
   - `Port 5000 in use`：运行 `stop-services.bat`
   - `Build failed`：运行 `pnpm run build`

---

### 原因 4：浏览器缓存问题

**症状**：服务正常运行，但页面空白或错误

**修复**：
1. 按 `Ctrl + F5` 强制刷新
2. 或清除浏览器缓存
3. 或使用无痕模式打开

---

### 原因 5：防火墙阻止

**症状**：本地 curl 可以访问，但浏览器不行

**修复**：
1. 打开 Windows Defender 防火墙
2. 允许应用通过防火墙
3. 添加 Python 和 Node.js 的例外

---

## 📋 完整的手动启动步骤

### 选项 A：使用修复脚本（推荐）

```cmd
1. stop-services.bat
2. start-services-fixed.bat
```

### 选项 B：完全手动

**窗口 1 - 启动后端**：
```cmd
cd backend
python main.py
```

**保持窗口 1 打开！**

**窗口 2 - 启动前端**：
```cmd
cd ..
pnpm run start
```

**保持窗口 2 打开！**

**浏览器 - 访问**：
```
http://localhost:5000
```

---

## 🔍 验证服务是否运行

### 检查后端

打开新的命令提示符：
```cmd
curl http://localhost:8001/health
```

应该看到：
```json
{"status":"ok"}
```

### 检查前端

打开新的命令提示符：
```cmd
curl http://localhost:5000
```

应该看到 HTML 内容。

### 检查进程

```cmd
tasklist | findstr python
tasklist | findstr node
```

应该看到 Python 和 Node.js 进程。

### 检查端口

```cmd
netstat -ano | findstr :5000
netstat -ano | findstr :8001
```

应该看到两个端口都有 `LISTENING` 状态。

---

## 🆘 还是不行？

### 收集信息

运行以下命令并截图：
```cmd
1. diagnose-no-docker.bat
2. python --version
3. node --version
4. pnpm --version
5. cd backend && pip list
```

### 常见最终解决方案

**如果所有方法都失败**：

1. **重新安装依赖**
   ```cmd
   cd backend
   pip uninstall -r requirements.txt -y
   pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
   cd ..
   pnpm install
   pnpm run build
   ```

2. **使用全新环境**
   - 卸载 Python 和 Node.js
   - 重新安装 Python 3.12（记得勾选 Add to PATH）
   - 重新安装 Node.js LTS
   - 重新运行 `install-no-docker.bat`
   - 重新运行 `start-services-fixed.bat`

3. **检查系统资源**
   - 至少 8GB RAM
   - 至少 10GB 可用磁盘空间
   - 关闭其他占用资源的程序

---

## ✅ 成功标志

当一切正常时：

**后端窗口**应该显示：
```
INFO:     Started server process [xxxx]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     Uvicorn running on http://0.0.0.0:8001
```

**前端窗口**应该显示：
```
ready - started server on 0.0.0.0:5000, url: http://localhost:5000
```

**浏览器**应该自动打开并显示：
- 购物卡 OCR 识别系统界面
- 上传按钮
- 识别功能可用

---

## 🎯 推荐流程

```
网页无法打开
    ↓
1. stop-services.bat
    ↓
2. start-services-fixed.bat
    ↓
    成功？→ 完成！
    ↓ 失败
3. diagnose-no-docker.bat
    ↓
    查看输出，找到具体问题
    ↓
4. 根据错误信息修复
    ↓
    成功？→ 完成！
    ↓ 失败
5. 完全手动启动（2个窗口）
    ↓
    成功？→ 完成！
    ↓ 失败
6. 重新安装依赖
    ↓
    成功？→ 完成！
    ↓ 失败
7. 检查系统要求和资源
```

---

## 📞 快速参考

| 问题 | 命令 |
|------|------|
| 停止所有服务 | `stop-services.bat` |
| 启动服务（修复版） | `start-services-fixed.bat` |
| 诊断问题 | `diagnose-no-docker.bat` |
| 检查 Python 版本 | `python --version` |
| 检查 Node.js 版本 | `node --version` |
| 检查后端 | `curl http://localhost:8001/health` |
| 检查前端 | `curl http://localhost:5000` |

---

**最后更新**：2025-02-04
**推荐脚本**：`start-services-fixed.bat`
**诊断工具**：`diagnose-no-docker.bat`

**记住：两个服务窗口都必须保持打开！**
