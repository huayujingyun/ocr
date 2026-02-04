# 🎉 Windows标准部署包 v2.0.9 - 下载（增强诊断版）

## 📥 直接下载链接

**文件名**：`ocr-card-recognizer-windows-standard-v2.0.9.tar.gz`

**文件大小**：139.47 KB

**版本**：v2.0.9

**有效期**：7天（2026-02-11过期）

### 🔗 下载地址

```
https://coze-coding-project.tos.coze.site/coze_storage_7602859016070627343/ocr-card-recognizer-windows-standard-v2.0.9.tar_9cc2c993.gz?sign=1770805532-8a3cfd9a98-0-4411a78b5e4e40765df9e4ca43e2ae8ad0da2a928de4529ec863fc1067ba1538
```

---

## 🔧 v2.0.9 新增功能

### 问题：start.bat找不到backend目录

**用户反馈**：
- 提示"backend directory not found"
- 即使backend文件夹在相同目录

**可能原因**：
1. 用户在子目录中运行start.bat
2. 解压后的目录结构不对
3. 错误提示不够清晰，无法定位问题

**解决方案**：
✅ **增强start.bat诊断信息**
- 显示当前工作目录
- 显示脚本所在位置
- 显示查找backend目录的绝对路径
- 显示当前目录结构
- 提供详细的检查清单

**改进后的错误提示**：
```
[INFO] Current directory: C:\OCR\ocr-card-recognizer
[INFO] Script location: C:\OCR\ocr-card-recognizer\
[INFO] Absolute script path: C:\OCR\ocr-card-recognizer\start.bat

[INFO] Checking for backend directory...
[ERROR] backend directory not found

[DEBUG] Expected location: C:\OCR\ocr-card-recognizer\backend
[DEBUG] Looking for: main.py

Please check:
  1. You are running start.bat from the correct directory
  2. The deployment package was extracted completely
  3. The backend folder exists next to start.bat

Current directory structure:
backend
check.bat
data
install.bat
logs
package.json
README.txt
setup.bat
src
start.bat
stop.bat
```

---

## 🚀 3步完成部署

### 步骤1：下载并解压（2分钟）

1. **点击上方下载链接**，开始下载
2. 安装解压工具（如果没有）：
   - **7-Zip**：https://www.7-zip.org/ （推荐）
   - **WinRAR**：https://www.win-rar.com/
3. 解压到任意目录（推荐：`C:\OCR\`）

**重要提示**：
- Windows无法直接解压`.tar.gz`文件
- 必须使用7-Zip或WinRAR
- 解压后应该看到backend/、src/等目录

**验证解压成功**：
- ✅ 应该看到`backend/`文件夹
- ✅ 应该看到`src/`文件夹
- ✅ 应该看到`start.bat`文件
- ✅ 应该看到`package.json`文件

---

### 步骤2：安装依赖（5-10分钟）

**重要：必须以管理员身份运行！**

**方式1：自动安装（推荐）⭐**
1. 右键点击 `setup.bat`
2. 选择 **"以管理员身份运行"**
3. 自动检测、下载、安装Python和Node.js
4. 自动安装项目依赖
5. 等待安装完成

**方式2：手动安装**
1. 确保已安装Python和Node.js
2. 右键点击 `install.bat`
3. 选择 **"以管理员身份运行"**
4. 等待安装完成

---

### 步骤3：启动服务（1分钟）

**重要：确保在正确的目录运行！**

1. **找到解压后的目录**
   - 例如：`C:\OCR\ocr-card-recognizer\`

2. **在文件资源管理器中进入该目录**
   - 双击进入解压后的文件夹

3. **找到start.bat文件**
   - 应该能看到backend/、src/等目录在旁边

4. **双击start.bat**
   - v2.0.9会显示详细的诊断信息
   - 确认看到"backend directory found"提示

5. **看到启动成功提示**：
   ```
   [SUCCESS] Backend service started successfully
   [SUCCESS] Frontend service started successfully
   ```

6. **打开浏览器访问**：**http://localhost:5000**

✅ **完成！**

---

## ❓ 常见问题

### Q1: start.bat仍然提示"backend directory not found"？

**A**: 请按照以下步骤检查：

1. **检查当前目录**
   - 看start.bat的提示信息
   - 确认"Current directory"和"Script location"一致

2. **检查目录结构**
   - 确保你在解压后的根目录
   - 确保backend文件夹存在
   - 在文件资源管理器中应该能看到：
     ```
     ocr-card-recognizer/
     ├── backend/
     ├── src/
     ├── start.bat  ← 在这里双击
     └── ...
     ```

3. **不要在子目录运行**
   - 错误：在`C:\OCR\ocr-card-recognizer\src\`目录运行
   - 正确：在`C:\OCR\ocr-card-recognizer\`目录运行

4. **查看诊断信息**
   - v2.0.9会显示详细的诊断信息
   - 查看"Current directory structure"部分
   - 确认backend目录存在

---

### Q2: 解压后看不到backend和src目录？

**A**: 这说明解压不完整。

**解决方案**：
1. 确保使用v2.0.9版本
2. 使用7-Zip或WinRAR解压
3. 解压时选择"解压到..."而不是"解压到当前目录"
4. 如果使用7-Zip：
   - 右键点击tar.gz文件
   - 选择"7-Zip" → "解压到 ocr-card-recognizer-windows-standard-v2.0.9\"
   - 然后进入解压后的目录查看

---

### Q3: 如何确认在正确的目录？

**A**: 按照以下步骤：

1. **打开文件资源管理器**
2. **导航到解压后的目录**
3. **检查是否看到以下文件和文件夹**：
   ```
   ✓ backend/      ← 文件夹
   ✓ src/          ← 文件夹
   ✓ logs/         ← 文件夹
   ✓ data/         ← 文件夹
   ✓ start.bat     ← 文件
   ✓ stop.bat      ← 文件
   ✓ install.bat   ← 文件
   ✓ setup.bat     ← 文件
   ✓ package.json  ← 文件
   ```

4. **确认无误后，双击start.bat**

---

### Q4: 提示"File: [assets/image.png]"是什么意思？

**A**: 这可能是用户的截图或日志中的文件名，不是错误信息。

**重要**：
- 部署包中不需要assets文件夹
- 所有必要的代码都在backend/和src/目录中
- 如果看到这个提示，请忽略

---

### Q5: 首次启动很慢？

**A**: **正常现象！**

首次启动需要：
- 下载OCR模型文件（约200MB）
- 加载模型到内存

- 首次启动：30-60秒
- 后续启动：10-20秒

---

## 📊 版本对比

| 版本 | 新功能/修复 | 状态 |
|------|------------|------|
| v2.0.0 - v2.0.7 | 缺少源代码 | ❌ 不完整 |
| v2.0.8 | 包含完整源代码 | ⚠️ 错误提示不清晰 |
| v2.0.9 | 增强诊断信息 | ✅ 完全可用 |

---

## 🎯 关键改进

### start.bat诊断信息改进

**v2.0.8（错误提示不清晰）**：
```
[ERROR] backend directory not found
Please make sure you are running this script in the correct directory
```

**v2.0.9（增强诊断信息）**：
```
[INFO] Current directory: C:\OCR\ocr-card-recognizer
[INFO] Script location: C:\OCR\ocr-card-recognizer\
[INFO] Absolute script path: C:\OCR\ocr-card-recognizer\start.bat

[INFO] Checking for backend directory...
[ERROR] backend directory not found

[DEBUG] Expected location: C:\OCR\ocr-card-recognizer\backend
[DEBUG] Looking for: main.py

Please check:
  1. You are running start.bat from the correct directory
  2. The deployment package was extracted completely
  3. The backend folder exists next to start.bat

Current directory structure:
backend
check.bat
data
install.bat
logs
package.json
README.txt
setup.bat
src
start.bat
stop.bat
```

**改进点**：
- ✅ 显示当前工作目录
- ✅ 显示脚本所在位置
- ✅ 显示查找backend的绝对路径
- ✅ 显示当前目录结构
- ✅ 提供详细的检查清单

---

## 💡 正确的使用流程

### 第一次部署
1. 下载v2.0.9部署包
2. 使用7-Zip解压到 `C:\OCR\`
3. 进入解压后的目录：`C:\OCR\ocr-card-recognizer-windows-standard-v2.0.9\`
4. 确认看到backend/、src/等目录
5. 右键 `setup.bat` → "以管理员身份运行"
6. 双击 `start.bat`
7. 查看诊断信息，确认"backend directory found"
8. 访问 http://localhost:5000

### 遇到问题时的排查步骤
1. 查看start.bat的诊断信息
2. 确认"Current directory"和"Script location"一致
3. 查看"Current directory structure"部分
4. 确认backend目录存在
5. 如果不存在，重新解压部署包

---

## 📦 下载信息

- **版本**：v2.0.9
- **文件大小**：139.47 KB
- **上传时间**：2026-02-04 18:25
- **有效期**：7天
- **过期时间**：2026-02-11 18:25
- **新增功能**：增强start.bat诊断信息

---

## 🎯 总结

### 最简单的3步：

1. **下载部署包**
   - 点击上方下载链接
   - 文件：`ocr-card-recognizer-windows-standard-v2.0.9.tar.gz`

2. **解压并安装依赖**
   - 使用7-Zip解压到 `C:\OCR\`
   - 进入解压后的目录（确认看到backend/和src/）
   - 右键 `setup.bat` → "以管理员身份运行"

3. **启动服务**
   - 在解压后的根目录双击 `start.bat`
   - 查看诊断信息，确认"backend directory found"
   - 访问 http://localhost:5000

✅ **完成！v2.0.9版本包含详细诊断信息，帮助快速定位问题！**

---

## 🔍 重要提示

### 运行start.bat前必须确认：

1. ✅ **在正确的目录**
   - 必须在解压后的根目录
   - 不要在子目录运行

2. ✅ **目录结构正确**
   - 应该看到backend/、src/等目录
   - backend目录应该与start.bat在同一级别

3. ✅ **使用v2.0.9版本**
   - v2.0.9包含详细诊断信息
   - 可以帮助快速定位问题

### 如果遇到"backend directory not found"：

1. 查看start.bat的诊断信息
2. 确认"Current directory"和"Script location"一致
3. 查看"Current directory structure"部分
4. 如果backend目录不存在，重新解压部署包
5. 如果backend目录存在但仍然报错，检查是否在子目录运行

---

**祝您使用愉快！🎉**

**v2.0.9版本包含详细诊断信息，帮助快速定位问题！**
