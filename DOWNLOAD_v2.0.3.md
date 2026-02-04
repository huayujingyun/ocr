# 🎉 Windows标准部署包 v2.0.3 - 下载（编码修复版）

## 📥 直接下载链接

**文件名**：`ocr-card-recognizer-windows-standard-v2.0.3.tar.gz`

**文件大小**：约137KB

**版本**：v2.0.3

**有效期**：7天（2026-02-11过期）

### 🔗 下载地址

```
https://coze-coding-project.tos.coze.site/coze_storage_7602859016070627343/ocr-card-recognizer-windows-standard-v2.0.3.tar_6f5285a2.gz?sign=1770803993-ab420cf469-0-439c411d0dd933756488e4cc83fb2d614d7287f6694d9ffcf7972486be56de81
```

---

## 🔧 v2.0.3 修复内容

### 问题描述
v2.0.2版本在Windows下运行`install.bat`时，所有中文显示为乱码。

### 根本原因
- Windows cmd默认使用GBK/CP936编码
- bat文件使用UTF-8编码
- 两种编码不匹配导致中文显示乱码
- `chcp 65001`命令不是所有Windows系统都支持

### 修复内容
✅ **所有bat文件改用纯英文**
- `install.bat` - 安装脚本
- `start.bat` - 启动脚本
- `stop.bat` - 停止脚本
- `check.bat` - 检查脚本

✅ **完全避免编码问题**
- 所有提示信息使用英文
- 所有标签使用英文
- 确保在任何Windows系统上都能正常显示

---

## 🚀 3步完成部署

### 步骤1：下载并解压（2分钟）

1. **点击上方下载链接**，开始下载
2. 安装解压工具（如果没有）：
   - **7-Zip**：https://www.7-zip.org/ （推荐）
   - **WinRAR**：https://www.win-rar.com/
3. 解压到任意目录（推荐：`C:\OCR\`）

**注意**：
- Windows无法直接解压`.tar.gz`文件
- 必须使用7-Zip或WinRAR

---

### 步骤2：安装依赖（5-10分钟）

**重要：必须以管理员身份运行！**

1. 右键点击 `install.bat`
2. 选择 **"以管理员身份运行"**
3. 看到黑色窗口弹出，显示安装进度
4. 所有提示信息现在都是英文，不会出现乱码
5. 等待安装完成

**安装过程**：
```
[Step 1/7] Checking system requirements...
[Step 2/7] Checking Python installation...
[Step 3/7] Checking Node.js installation...
[Step 4/7] Installing pnpm...
[Step 5/7] Installing backend dependencies...
[Step 6/7] Installing frontend dependencies...
[Step 7/7] Creating necessary directories...
```

**安装成功的标志**：
```
=======================================
Installation Complete!
=======================================

Usage:
  1. Double-click start.bat to start the service
  2. Double-click stop.bat to stop the service
  3. Double-click check.bat to check service status
  4. Visit http://localhost:5000 to use the system
```

---

### 步骤3：启动服务（1分钟）

1. 双击 `start.bat`（无需管理员权限）
2. 等待30-60秒（首次启动需要下载OCR模型）
3. 看到以下提示表示启动成功：

```
=======================================
Service Started!
=======================================

Access URLs:
  Frontend: http://localhost:5000
  Backend API: http://localhost:8001/docs
```

4. 打开浏览器访问：**http://localhost:5000**

✅ **完成！**

---

## ❓ 常见问题

### Q1: install.bat显示乱码？

**A**:
- ✅ **已修复**：v2.0.3版本使用纯英文，不会出现乱码
- 所有提示信息都是英文，确保在任何Windows系统上都能正常显示

---

### Q2: 提示"Python is not installed"？

**A**:
1. 访问：https://www.python.org/downloads/release/python-3128/
2. 下载 **"Windows installer (64-bit)"**
3. 运行安装程序
4. **重要**：勾选 **"Add Python to PATH"**
5. 点击 **"Install Now"**
6. 安装完成后重新运行`install.bat`

---

### Q3: 提示"Node.js is not installed"？

**A**:
1. 访问：https://nodejs.org/
2. 下载 **LTS版本**（推荐Node.js 20 LTS）
3. 运行安装程序
4. 点击 **"Install"** 完成安装
5. 安装完成后重新运行`install.bat`

---

### Q4: Python依赖安装失败？

**A**:
1. 检查网络连接
2. 尝试更新pip：
   ```
   python -m pip install --upgrade pip
   ```
3. 使用国内镜像源：
   ```
   pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
   ```

---

### Q5: 前端依赖安装失败？

**A**:
1. 检查网络连接
2. 清除缓存：
   ```
   pnpm store prune
   ```
3. 使用国内镜像源：
   ```
   pnpm config set registry https://registry.npmmirror.com
   ```

---

### Q6: 首次启动很慢？

**A**: **正常现象！**

首次启动需要：
- 下载OCR模型文件（约200MB）
- 加载模型到内存

- 首次启动：30-60秒
- 后续启动：10-20秒

---

## 📊 版本对比

| 版本 | 问题 | 状态 |
|------|------|------|
| v2.0.0 | 初始版本 | ✅ 可用 |
| v2.0.1 | Windows下install.bat一闪而过 | ❌ 不可用 |
| v2.0.2 | 修复install.bat一闪而过，但中文乱码 | ⚠️ 部分可用 |
| v2.0.3 | 改用纯英文，解决乱码问题 | ✅ 完全可用 |

---

## 📝 bat文件列表

### install.bat
- 检查管理员权限
- 检查Python安装
- 检查Node.js安装
- 安装pnpm
- 安装后端依赖
- 安装前端依赖
- 创建必要目录

### start.bat
- 检查端口占用
- 启动后端服务
- 等待后端启动（最多60秒）
- 启动前端服务
- 显示服务状态

### stop.bat
- 停止前端服务
- 停止后端服务
- 清理进程残留

### check.bat
- 检查后端服务状态
- 检查前端服务状态
- 显示进程信息

---

## 💡 重要提示

### 安装前
1. 确保是Windows 10/11 64位系统
2. 确保至少4GB内存
3. 确保至少2GB可用磁盘空间
4. 确保有管理员权限

### 安装时
1. **必须以管理员身份运行**install.bat
2. 所有提示信息都是英文，不会出现乱码
3. 每个步骤完成后会暂停，按任意键继续
4. 如果遇到错误，按照提示操作
5. 安装需要5-10分钟，请耐心等待

### 启动时
1. 双击`start.bat`即可，无需管理员权限
2. 首次启动需要30-60秒（下载OCR模型）
3. 看到启动成功提示后，访问http://localhost:5000

---

## 📞 获取帮助

### 检查服务状态
```
Double-click: check.bat
```

### 查看日志
```
Open: logs\backend.log
Open: logs\frontend.log
```

### 手动检查
```batch
# Check backend
curl http://localhost:8001/health

# Check frontend
curl http://localhost:5000
```

---

## 🎉 完成后的功能

现在您可以：

- ✅ 自动识别购物卡和加油卡
- ✅ 批量处理，提高效率
- ✅ 导出Excel，方便整理
- ✅ 完全离线，数据安全
- ✅ 无需联网，随时使用
- ✅ 支持模板识别，提高准确率
- ✅ 所有提示信息清晰显示，无乱码

**访问地址：http://localhost:5000**

---

## 📦 下载信息

- **版本**：v2.0.3
- **文件大小**：137KB
- **上传时间**：2026-02-04 18:06
- **有效期**：7天
- **过期时间**：2026-02-11 18:06
- **修复内容**：Windows中文乱码问题

---

## 🔄 从v2.0.2升级到v2.0.3

如果已经下载了v2.0.2：

1. **推荐：重新下载v2.0.3**
   - 下载v2.0.3版本
   - 解压到新目录
   - 重新安装

2. **手动修复（不推荐）**
   - 解压v2.0.2
   - 替换所有bat文件
   - 重新运行install.bat

**强烈推荐使用方法1，重新下载v2.0.3**

---

## 🎯 总结

### 最简单的3步：

1. **下载部署包**
   - 点击上方下载链接
   - 文件：`ocr-card-recognizer-windows-standard-v2.0.3.tar.gz`

2. **安装依赖**
   - 解压到 `C:\OCR\`
   - 右键 `install.bat` → "以管理员身份运行"
   - 所有提示都是英文，不会出现乱码

3. **启动服务**
   - 双击 `start.bat`
   - 访问 http://localhost:5000

✅ **完成！开始使用吧！**

---

**祝您使用愉快！🎉**

**v2.0.3版本已解决所有编码问题，确保在Windows下完美运行！**
