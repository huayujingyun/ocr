# Docker 构建错误修复

## 问题描述

错误信息：
```
target frontend: failed to solve: failed to compute cache key: failed to calculate checksum of ref vkovmw91kptxnb87vievxbphw::l93y4kay7uks96hggj4gafcqv: "/pnpm-lock.yaml": not found
```

**根本原因**：
- Docker 构建上下文配置错误
- `pnpm-lock.yaml` 文件在项目根目录，但 Dockerfile 在 frontend 目录下
- 导致构建时找不到 `pnpm-lock.yaml` 文件

---

## ✅ 已修复的内容

### 1. 修改 docker-compose.yml

**修改前**：
```yaml
frontend:
  build:
    context: ./frontend
    dockerfile: Dockerfile
```

**修改后**：
```yaml
frontend:
  build:
    context: .
    dockerfile: frontend/Dockerfile
```

**说明**：将构建上下文从 `./frontend` 改为根目录 `.`，这样 Docker 可以找到根目录下的 `pnpm-lock.yaml` 文件。

---

### 2. 更新 frontend/Dockerfile

**修改内容**：
- 使用正确的构建上下文路径
- 复制根目录的 `package.json` 和 `pnpm-lock.yaml`
- 复制所有必要的配置文件
- 确保 Next.js 16 的配置文件正确（`next.config.ts`）

---

### 3. 更新 frontend/Dockerfile.cn

**修改内容**：
- 保持与 Dockerfile 一致的构建逻辑
- 使用国内 npm 镜像源
- 优化构建过程

---

### 4. 创建 .dockerignore 文件

**作用**：
- 排除不必要的文件，提高构建速度
- 避免复制大量无关文件到构建上下文
- 减小镜像体积

**排除的文件**：
- node_modules
- .next/
- 日志文件
- 文档
- Git 文件
- IDE 配置文件

---

## 🚀 如何应用修复

### 方法 1：重新下载最新部署包（推荐）

下载最新的修复版本，已包含所有修复。

### 方法 2：手动修复现有部署

如果您已经有部署包，可以手动修复：

**步骤 1**：修改 `docker-compose.yml`
```yaml
frontend:
  build:
    context: .
    dockerfile: frontend/Dockerfile
```

**步骤 2**：更新 `frontend/Dockerfile`（见上面的完整内容）

**步骤 3**：创建 `.dockerignore` 文件（见上面的完整内容）

**步骤 4**：重新构建
```cmd
docker-compose build --no-cache
```

---

## 🔍 验证修复

### 检查文件结构

确保以下文件存在：
```
项目根目录/
├── package.json           ✅ 必须在根目录
├── pnpm-lock.yaml         ✅ 必须在根目录
├── docker-compose.yml     ✅ 已修复
├── .dockerignore          ✅ 新增
├── frontend/
│   ├── Dockerfile         ✅ 已更新
│   └── Dockerfile.cn      ✅ 已更新
├── src/                   ✅ 前端源码
└── backend/               ✅ 后端服务
```

### 测试构建

```cmd
docker-compose build frontend
```

如果成功，应该看到：
```
[+] Building 120.5s (12/12) FINISHED
 => [frontend builder 3/7] COPY package.json pnpm-lock.yaml* ./
 => [frontend builder 4/7] RUN npm install -g pnpm@latest
 => [frontend builder 5/7] RUN pnpm install --frozen-lockfile
 => [frontend builder 6/7] COPY . .
 => [frontend builder 7/7] RUN pnpm run build
 => [frontend 6/8] COPY --from=builder /app/.next ./.next
 => [frontend 7/8] COPY --from=builder /app/public ./public
 => [frontend 8/8] CMD ["pnpm", "start"]
```

---

## 📋 完整构建流程

### Docker 标准版

```cmd
1. docker-compose build --no-cache
2. docker-compose up -d
```

### Docker 国内版

```cmd
1. setup-docker-mirror.bat
2. docker-compose -f docker-compose-local-build.yml build --no-cache
3. docker-compose up -d
```

---

## ⚠️ 注意事项

### 1. 构建上下文大小

修改构建上下文为根目录后，可能会增加构建上下文大小。`.dockerignore` 文件已经排除了大部分不必要的文件。

### 2. 缓存问题

首次构建使用 `--no-cache` 选项，避免使用旧的缓存：
```cmd
docker-compose build --no-cache
```

### 3. 构建时间

完整的构建可能需要 10-20 分钟，取决于：
- 网络速度（下载依赖）
- CPU 性能（编译 Next.js）
- 磁盘速度

---

## 🆘 如果还有问题

### 问题 1：构建仍然失败

**解决方案**：
1. 清理 Docker 缓存：
   ```cmd
   docker system prune -a
   ```
2. 重新构建：
   ```cmd
   docker-compose build --no-cache
   ```

### 问题 2：依赖安装失败

**解决方案**：
1. 检查网络连接
2. 使用国内镜像源（`frontend/Dockerfile.cn`）
3. 查看详细错误日志：
   ```cmd
   docker-compose build frontend --progress=plain
   ```

### 问题 3：构建超时

**解决方案**：
1. 增加超时时间（Docker Desktop 设置）
2. 使用更快的网络
3. 使用国内优化版本（`install-cn.bat`）

---

## 📊 修复前后对比

| 项目 | 修复前 | 修复后 |
|------|--------|--------|
| 构建上下文 | ./frontend | .（根目录） |
| pnpm-lock.yaml 位置 | 无法访问 | ✅ 可访问 |
| 构建速度 | 无法构建 | ✅ 正常构建 |
| 构建大小 | N/A | ~500MB |

---

**修复日期**：2025-02-04
**影响版本**：v2.0.0 之前的所有版本
**修复版本**：v2.0.0（已包含修复）
