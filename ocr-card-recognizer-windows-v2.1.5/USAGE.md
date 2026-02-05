# 快速使用指南

## 🚀 三种启动方式

### 1. 推荐方式：静默模式（不卡电脑）

双击运行 `start-silent.bat`，选择模式 `1`

**优点**：
- ✅ 后台运行，不占用终端
- ✅ 电脑不卡顿
- ✅ 适合长时间使用

**停止后端**：
```cmd
cd backend
stop-backend.bat
```

---

### 2. 传统方式：详细日志模式

双击运行 `start-silent.bat`，选择模式 `2`

**优点**：
- ✅ 可以实时查看日志
- ✅ 方便调试问题

**缺点**：
- ❌ 可能会卡顿
- ❌ 长时间使用电脑变慢

---

### 3. 一键启动（旧版）

双击运行 `start.bat`

**注意**：这种方式会在终端输出大量日志，可能导致卡顿。

---

## 📝 后台运行日志

后端日志保存在 `backend\backend.log` 文件中。

**查看日志**：
```cmd
type backend\backend.log | more
```

**搜索错误**：
```cmd
findstr /I "ERROR" backend\backend.log
```

---

## ⚡ 快速命令

### 启动后端（静默模式）
```cmd
cd backend
start-backend-silent.bat
```

### 停止后端
```cmd
cd backend
stop-backend.bat
```

### 启动前端
```cmd
pnpm run start
```

---

## 🎯 推荐配置

**日常使用**：使用 `start-silent.bat`，选择模式 `1`（静默模式）

**调试问题**：使用 `start-silent.bat`，选择模式 `2`（详细日志模式）

---

## 📚 详细文档

- `docs/SILENT_MODE.md` - 后台运行详细指南
- `README.md` - 完整使用说明
- `QUICKSTART_v2.1.5.md` - 快速开始

---

**推荐**：使用静默模式，电脑不卡顿！
