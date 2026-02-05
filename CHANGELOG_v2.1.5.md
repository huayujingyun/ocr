# 更新日志 v2.1.5

## 📅 发布日期
2026-02-05

## 🎯 主要更新

### 修复 Windows 平台 OCR 识别失败问题

#### 问题描述
在 Windows 平台上，使用 PaddlePaddle 3.x + PaddleOCR 3.4.0 组合时，OCR 识别失败，出现以下错误：

1. **oneDNN 兼容性错误**
   ```
   ERROR: (Unimplemented) ConvertPirAttribute2RuntimeAttribute not support [pir::ArrayAttribute<pir::DoubleAttribute>]
   ```

2. **版本不兼容错误**
   ```
   ERROR: 'paddle.base.libpaddle.AnalysisConfig' object has no attribute 'set_optimization_level'
   ```

#### 根本原因
- PaddlePaddle 3.x 在 Windows 上的 oneDNN 实现有严重兼容性问题
- PaddleOCR 3.4.0 与 PaddlePaddle 2.6.2 API 不兼容
- 环境变量无法完全禁用 oneDNN 功能

#### 解决方案
降级到稳定的版本组合：
- PaddlePaddle: 2.6.2
- PaddleOCR: 2.8.0

## 🔧 具体修改

### 1. 后端依赖版本固定

**文件**: `backend/requirements.txt`

**修改前**:
```txt
paddlepaddle>=2.6.0
paddleocr>=2.8.0
```

**修改后**:
```txt
paddlepaddle==2.6.2
paddleocr==2.8.0
```

### 2. 添加安装脚本

**文件**: `backend/install.bat`

**功能**:
- 检查 Python 版本
- 从 requirements.txt 安装依赖
- 验证安装结果
- 提供友好的错误提示

### 3. 添加启动脚本

**文件**: `backend/start-backend-fixed.bat`

**功能**:
- 设置禁用 oneDNN 的环境变量
- 启动后端服务
- 提供详细的启动日志

**环境变量**:
```batch
set PADDLE_NO_QUANTIZE_KERNEL=1
set PADDLE_DISABLE_MKLDNN=1
set PADDLE_NO_BUILTIN_KERNEL=1
set FLAGS_use_mkldnn=0
```

### 4. 前端 API 端口配置

**文件**: `src/app/api/ocr/route.ts`

**修改**:
- 将默认端口从 8001 改回 8000
- 与后端实际运行端口保持一致

### 5. 更新文档

**文件**: `QUICKSTART_v2.1.5.md`

**新增内容**:
- 详细的版本兼容性说明
- 手动修复依赖的步骤
- 版本验证命令
- 常见问题解决方案

## 📦 版本兼容性

### Windows 平台推荐配置

| 组件 | 版本 | 状态 |
|------|------|------|
| Python | 3.12 | ✅ 测试通过 |
| PaddlePaddle | 2.6.2 | ✅ 稳定 |
| PaddleOCR | 2.8.0 | ✅ 稳定 |
| Node.js | 24 | ✅ 测试通过 |
| Windows | 10/11 | ✅ 测试通过 |

### 不兼容的组合

| PaddlePaddle | PaddleOCR | 状态 | 错误 |
|--------------|-----------|------|------|
| 3.3.0 | 3.4.0 | ❌ | oneDNN 兼容性问题 |
| 3.x | 2.8.0 | ❌ | API 不兼容 |
| 2.6.2 | 3.4.0 | ❌ | set_optimization_level |

## ✅ 测试结果

### 测试环境
- Windows 11
- Python 3.12
- PaddlePaddle 2.6.2
- PaddleOCR 2.8.0

### 测试功能
- ✅ 单张图片识别
- ✅ 批量图片识别
- ✅ 模板识别
- ✅ 条码识别
- ✅ Excel 导出

### 性能表现
- 首次初始化: ~5秒
- 单张识别: ~1-2秒
- 批量识别（10张）: ~10秒

## 🚀 升级指南

### 从 v2.1.4 升级到 v2.1.5

#### 已安装用户

1. **停止服务**
   ```cmd
   # 按 Ctrl+C 停止后端和前端
   ```

2. **更新依赖**
   ```cmd
   cd backend
   py -m pip uninstall paddlepaddle paddleocr -y
   py -m pip install "paddlepaddle==2.6.2"
   py -m pip install "paddleocr==2.8.0"
   ```

3. **使用新的启动脚本**
   ```cmd
   start-backend-fixed.bat
   ```

#### 新安装用户

按照 `QUICKSTART_v2.1.5.md` 中的步骤操作。

## 🆘 问题排查

### 仍出现 oneDNN 错误

**解决方案**:
1. 确认使用 `start-backend-fixed.bat` 启动
2. 检查 PaddlePaddle 版本是否为 2.6.2
3. 重启电脑（清除缓存的 DLL）

### 识别速度慢

**原因**:
- 禁用 oneDNN 后性能略有下降
- CPU 模式比 GPU 慢

**优化建议**:
- 使用批量识别（减少初始化次数）
- 减小图片尺寸
- 考虑使用 GPU（需要安装 PaddlePaddle-GPU）

## 📝 已知问题

1. **oneDNN 禁用导致性能下降**
   - 影响: 识别速度约慢 10-20%
   - 原因: 禁用 oneDNN 加速
   - 暂无解决方案（PaddlePaddle 3.x 兼容性问题）

2. **首次启动较慢**
   - 影响: 首次识别需等待 5-10 秒
   - 原因: 模型加载
   - 建议: 启动后保持服务运行

## 📞 技术支持

如遇到问题，请检查：
1. 依赖版本是否正确
2. 是否使用 `start-backend-fixed.bat` 启动
3. 后端服务是否正常运行
4. 查看快速开始文档：`QUICKSTART_v2.1.5.md`

---

**版本号**: v2.1.5
**状态**: ✅ Windows 平台稳定版
