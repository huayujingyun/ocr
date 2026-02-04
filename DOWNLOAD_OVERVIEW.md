# 📦 OCR Card Recognizer - 部署包下载总览

## ✅ 最新版本：v2.1.3

**发布日期**：2026-02-04  
**文件大小**：132 KB  
**有效期**：30 天

---

## 🚀 一键下载

### 方式1：直接点击下载

```
https://coze-coding-project.tos.coze.site/coze_storage_7602859016070627343/ocr-card-recognizer-windows-v2.1.3.tar_fbb696ab.gz?sign=1772796261-df39060e4b-0-7dfb925b121db795a26be418a40b56212de668b11cbeda9c68b5864afa690b8c
```

### 方式2：PowerShell 命令

```powershell
$url = "https://coze-coding-project.tos.coze.site/coze_storage_7602859016070627343/ocr-card-recognizer-windows-v2.1.3.tar_fbb696ab.gz?sign=1772796261-df39060e4b-0-7dfb925b121db795a26be418a40b56212de668b11cbeda9c68b5864afa690b8c"
$output = "ocr-card-recognizer-windows-v2.1.3.tar.gz"
Invoke-WebRequest -Uri $url -OutFile $output
```

---

## 📖 文档导航

| 文档 | 用途 | 适用人群 |
|------|------|----------|
| **[快速启动指南](QUICKSTART_v2.1.3.md)** | 5分钟快速上手 | 所有用户 |
| **[详细安装指南](DOWNLOAD_v2.1.3.md)** | 完整安装说明 | 新手用户 |
| **[版本信息](VERSION.txt)** | 版本更新历史 | 开发者 |

---

## 🆕 v2.1.3 更新内容

### 修复的问题

1. ✅ **Windows Python 环境冲突**
   - 优先使用 `py` 命令调用 Python 3.12
   - 解决 Windows Store Python 冲突

2. ✅ **Tailwind CSS 样式问题**
   - 降级到稳定的 Tailwind CSS 3.4.19
   - 修复样式不显示问题

3. ✅ **环境变量语法错误**
   - 修复 Windows 下 `PORT` 变量语法
   - 改用命令行参数 `-p 5000`

4. ✅ **依赖安装优化**
   - 使用官方 PyPI 源
   - 所有依赖已测试验证

---

## ⚡ 快速开始

### 1. 系统要求

- Windows 10/11 (64-bit)
- Python 3.12
- Node.js 18+ with pnpm
- 4GB RAM (推荐 8GB)

### 2. 安装步骤

```cmd
# 步骤1：解压文件
# 步骤2：安装后端依赖
cd backend
py -m pip install -r requirements.txt

# 步骤3：安装前端依赖
cd ..
pnpm install

# 步骤4：构建前端
pnpm run build
```

### 3. 启动服务

**窗口1 - 后端**：
```cmd
cd backend
py -m uvicorn main:app --host 0.0.0.0 --port 8000
```

**窗口2 - 前端**：
```cmd
pnpm run start
```

### 4. 访问应用

打开浏览器：http://localhost:5000

---

## 📚 包含功能

- ✅ 离线 OCR 识别（PaddleOCR）
- ✅ 模板识别（更快更准）
- ✅ 条码识别支持
- ✅ 批量上传处理
- ✅ Excel 导出（含截图）
- ✅ 实时预览编辑
- ✅ 完全离线运行

---

## 🎯 使用技巧

### 首次使用

1. 访问 http://localhost:5000
2. 点击 "设置识别模板" 创建模板
3. 或直接 "上传卡片图片" 开始识别

### 批量识别

- 支持一次上传多张图片
- 识别速度取决于图片数量
- 使用模板识别可大幅提升速度

### Excel 导出

- 包含序号、卡号、密码、密码截图
- 支持手动编辑后再导出
- 图片与数据行精确对应

---

## ⚠️ 常见问题

### Python 命令不存在

**问题**：`'python' 不是内部或外部命令`

**解决**：使用 `py` 代替 `python`

```cmd
py --version
py -m pip install ...
```

### 端口被占用

**问题**：`OSError: [WinError 10048]`

**解决**：更改端口号

```cmd
# 后端改为 8001
py -m uvicorn main:app --host 0.0.0.0 --port 8001

# 前端改为 5001（需修改 package.json）
pnpm run start -p 5001
```

### CSS 不显示

**问题**：界面显示混乱，图标很大

**解决**：

1. 清除浏览器缓存（Ctrl+Shift+Delete）
2. 强制刷新（Ctrl+Shift+R）
3. 重新构建前端

```cmd
pnpm run build
```

---

## 📊 版本历史

| 版本 | 发布日期 | 主要更新 | 状态 |
|------|----------|----------|------|
| v2.1.3 | 2026-02-04 | 修复Windows兼容性问题 | ✅ 稳定 |
| v2.1.2 | 2026-02-04 | 添加完整部署脚本 | ⚠️ 已弃用 |

---

## 🆘 获取帮助

1. 查看快速启动指南
2. 查看详细安装指南
3. 检查控制台错误信息（F12）
4. 验证依赖是否正确安装

---

## 📄 许可证

本项目由 Coze Coding Expert 开发，仅供学习和个人使用。

---

**最后更新**：2026-02-04  
**版本**：v2.1.3  
**状态**：✅ 已测试，可正常使用

---

## 🎉 开始使用

点击下载链接，按照快速启动指南操作，5分钟即可完成部署！

有问题？查看详细安装指南获取更多信息。
