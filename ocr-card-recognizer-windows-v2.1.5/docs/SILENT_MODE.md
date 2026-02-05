# 后台运行模式使用指南

## 🚀 为什么使用后台运行模式？

前台运行模式（默认）会在控制台窗口中输出大量日志，导致：
- ❌ 终端卡顿
- ❌ CPU 占用增加
- ❌ 长时间使用电脑变慢

后台运行模式可以解决这些问题：
- ✅ 后端在后台运行，不占用终端
- ✅ 日志输出到文件，不影响性能
- ✅ 可以随时查看日志
- ✅ 适合长时间使用

---

## 📦 包含的脚本

### 1. start-silent.bat（一键启动脚本）

提供两种启动模式选择：
- **Silent Mode**（推荐）：后端后台运行，日志输出到文件
- **Verbose Mode**：前台运行，显示所有日志

### 2. backend/start-backend-silent.bat

后端后台运行脚本：
- 后台运行后端服务
- 日志输出到 `backend.log`
- 自动测试后端健康状态

### 3. backend/stop-backend.bat

停止后端服务脚本：
- 自动查找并停止后端进程
- 清理占用端口的进程
- 提供友好的停止提示

---

## 🚀 快速开始

### 方式一：使用一键启动脚本（推荐）

1. 双击运行 `start-silent.bat`
2. 选择模式：
   - 输入 `1`：Silent Mode（推荐）
   - 输入 `2`：Verbose Mode
3. 等待服务启动
4. 浏览器自动打开

### 方式二：分别启动

**启动后端（后台模式）**：
```cmd
cd backend
start-backend-silent.bat
```

**启动前端**：
```cmd
cd ..
pnpm run start
```

### 停止后端

当您需要停止后端服务时：
```cmd
cd backend
stop-backend.bat
```

---

## 📝 日志查看

### 后端日志

后端日志保存在 `backend\backend.log` 文件中。

**查看最新日志**：
```cmd
type backend\backend.log | more
```

**搜索错误**：
```cmd
findstr /I "ERROR" backend\backend.log
```

**清空日志**：
```cmd
echo. > backend\backend.log
```

### 前端日志

前端日志在浏览器的开发者工具中查看：
- 按 `F12` 打开开发者工具
- 选择 "Console" 标签
- 查看前端日志和错误

---

## 🔧 日志输出优化

### 后端日志优化

已优化后端日志输出，减少不必要的日志：

**批量识别**：
- 之前：每张图片都输出日志
- 现在：只输出总数和成功数

**识别失败**：
- 只在真正失败时输出错误日志
- 不再输出调试信息

### 前端日志

前端日志保持在浏览器控制台中，不影响系统性能。

---

## 📊 性能对比

| 模式 | CPU 占用 | 终端卡顿 | 日志查看 | 推荐场景 |
|------|---------|---------|---------|---------|
| Silent Mode | 低 | 无 | 文件 | 长时间使用 ✅ |
| Verbose Mode | 高 | 有 | 实时 | 调试问题 |

---

## ⚠️ 注意事项

### 1. 端口占用

如果端口 8000 被占用，请先停止已有的后端服务：
```cmd
cd backend
stop-backend.bat
```

### 2. 日志文件大小

长时间使用后，`backend.log` 文件可能会变大。建议定期清理：
```cmd
echo. > backend\backend.log
```

### 3. 停止服务

使用 `stop-backend.bat` 脚本停止后端服务，不要直接关闭进程窗口。

---

## 🆘 常见问题

### 1. 后端启动后没有响应

**检查日志**：
```cmd
type backend\backend.log
```

**手动测试后端**：
```cmd
curl http://localhost:8000/health
```

### 2. 日志文件不存在

确保使用 `start-backend-silent.bat` 启动后端服务。

### 3. 停止失败

手动停止进程：
```cmd
taskkill /F /IM python.exe
```

### 4. 前端无法连接后端

检查后端是否正常运行：
```cmd
curl http://localhost:8000/health
```

如果返回错误，重新启动后端：
```cmd
cd backend
stop-backend.bat
start-backend-silent.bat
```

---

## 🎯 推荐使用场景

### 使用 Silent Mode（后台模式）
- ✅ 日常使用
- ✅ 批量识别多张图片
- ✅ 长时间运行
- ✅ 不需要实时查看日志

### 使用 Verbose Mode（前台模式）
- ⚠️ 调试问题
- ⚠️ 查看实时日志
- ⚠️ 开发和测试
- ⚠️ 短时间使用

---

## 📞 获取帮助

如果遇到问题，请：
1. 查看 `backend\backend.log` 日志文件
2. 检查浏览器控制台
3. 参考 `README.md` 主文档

---

**版本**: v2.1.5
**更新**: 2026-02-05
**状态**: ✅ 可用
