# Git认证问题解决方案

## ❌ 错误信息

```
remote: Invalid username or token. Password authentication is not supported for Git operations.
fatal: Authentication failed for 'https://github.com/huayujingyun/ocr-card-recognizer.git/'
```

### 原因
GitHub已停止支持密码认证，现在需要使用：
1. Personal Access Token (PAT) - 推荐（简单）
2. SSH密钥 - 推荐（安全）

---

## 🚀 解决方案

### 方案1：使用Personal Access Token (PAT) 【推荐 - 最简单】

#### 步骤1：创建Personal Access Token

1. 访问：https://github.com/settings/tokens
2. 点击 "Generate new token" → "Generate new token (classic)"
3. 填写信息：
   - **Note**: `OCR Card Recognizer`（或任意名称）
   - **Expiration**: 选择过期时间（推荐90天或更久）
   - **Scopes**: 勾选以下权限：
     - ✅ `repo`（完整仓库权限）
     - ✅ `workflow`（如果需要CI/CD）
4. 点击 "Generate token"
5. **重要**：复制生成的token（只显示一次！）

#### 步骤2：使用Token推送代码

**方法A：在URL中包含token（不推荐，不安全）**
```bash
git remote set-url origin https://<TOKEN>@github.com/huayujingyun/ocr-card-recognizer.git
git push -u origin main
```

**方法B：使用Credential Helper（推荐）**
```bash
# 移除旧的远程仓库配置
git remote remove origin

# 重新添加（不包含token）
git remote add origin https://github.com/huayujingyun/ocr-card-recognizer.git

# 推送时，会提示输入用户名和密码
# 用户名：输入您的GitHub用户名
# 密码：粘贴刚才创建的Personal Access Token
git push -u origin main
```

#### 步骤3：保存凭证（可选）

```bash
# 配置Git凭证存储
git config --global credential.helper store

# 下次推送时输入一次token，之后会自动保存
git push origin main
```

---

### 方案2：使用SSH密钥 【推荐 - 最安全】

#### 步骤1：生成SSH密钥

**Windows (Git Bash / PowerShell):**
```bash
# 检查是否已有SSH密钥
ls ~/.ssh/id_rsa.pub

# 如果没有，生成新密钥
ssh-keygen -t ed25519 -C "your_email@example.com"

# 或使用RSA算法（更兼容）
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

**参数说明**：
- `-t`: 密钥类型（ed25519推荐，或rsa）
- `-b`: 密钥位数（仅RSA需要，推荐4096）
- `-C`: 注释（通常是您的邮箱）

**注意**：
- 按Enter使用默认路径（`~/.ssh/id_ed25519`）
- 按Enter跳过密码（或设置密码增强安全性）

#### 步骤2：复制公钥

**Windows (Git Bash):**
```bash
cat ~/.ssh/id_ed25519.pub | clip
```

**或手动复制**：
```bash
cat ~/.ssh/id_ed25519.pub
```

#### 步骤3：添加SSH密钥到GitHub

1. 访问：https://github.com/settings/keys
2. 点击 "New SSH key"
3. 填写信息：
   - **Title**: `OCR Card Recognizer`（或任意名称）
   - **Key**: 粘贴刚才复制的公钥内容（从`ssh-rsa`开始到结束）
4. 点击 "Add SSH key"

#### 步骤4：测试SSH连接

```bash
ssh -T git@github.com
```

**预期输出**：
```
Hi huayujingyun! You've successfully authenticated, but GitHub does not provide shell access.
```

#### 步骤5：切换到SSH远程URL

```bash
# 移除HTTPS远程URL
git remote remove origin

# 添加SSH远程URL
git remote add origin git@github.com:huayujingyun/ocr-card-recognizer.git

# 推送代码
git push -u origin main
```

---

### 方案3：使用GitHub CLI（gh）【最便捷】

#### 步骤1：安装GitHub CLI

**Windows:**
- 下载：https://cli.github.com/
- 运行安装程序

**Linux:**
```bash
sudo apt install gh  # Ubuntu/Debian
sudo yum install gh  # CentOS/RHEL
```

#### 步骤2：登录GitHub

```bash
gh auth login
```

按提示选择：
1. What account do you want to log into? → `GitHub.com`
2. What is your preferred protocol for Git operations? → `HTTPS` 或 `SSH`
3. Authenticate with a GitHub.com device? → `Yes`
4. 在浏览器中输入显示的代码

#### 步骤3：推送代码

```bash
# 添加远程仓库
git remote add origin https://github.com/huayujingyun/ocr-card-recognizer.git

# 使用gh CLI推送
gh repo set-default huayujingyun/ocr-card-recognizer
git push -u origin main
```

---

## 📊 三种方案对比

| 方案 | 优点 | 缺点 | 适用场景 |
|------|------|------|----------|
| **PAT** | 简单快速，无需额外配置 | Token会过期，需定期更新 | 临时使用，快速测试 |
| **SSH** | 安全稳定，无需密码 | 配置稍复杂，需生成密钥 | 长期使用，推荐方案 |
| **GitHub CLI** | 功能强大，管理便捷 | 需安装额外工具 | GitHub重度用户 |

---

## ✅ 推荐操作流程

### 如果您是GitHub新手

**推荐使用方案1（Personal Access Token）**：

1. 访问 https://github.com/settings/tokens
2. 创建新token（勾选`repo`权限）
3. 复制token
4. 运行：
   ```bash
   git push -u origin main
   # 用户名：您的GitHub用户名
   # 密码：粘贴token
   ```

### 如果您需要长期使用

**推荐使用方案2（SSH密钥）**：

1. 生成SSH密钥：`ssh-keygen -t ed25519 -C "your_email@example.com"`
2. 复制公钥：`cat ~/.ssh/id_ed25519.pub`
3. 添加到GitHub：https://github.com/settings/keys
4. 切换远程URL：`git remote set-url origin git@github.com:huayujingyun/ocr-card-recognizer.git`
5. 推送代码：`git push -u origin main`

---

## 🔧 常见问题

### Q1: Token过期后怎么办？

**答**：生成新token并更新：
```bash
# 移除旧凭证
git credential-osxkeychain erase  # macOS
git config --global --unset credential.helper  # 通用

# 重新推送，使用新token
git push origin main
```

### Q2: SSH连接失败？

**答**：检查SSH配置：
```bash
# 测试SSH连接
ssh -T git@github.com

# 查看SSH密钥
ls ~/.ssh/id_*

# 查看SSH配置
cat ~/.ssh/config
```

### Q3: 如何查看当前远程URL？

**答**：
```bash
git remote -v
```

### Q4: 如何切换认证方式？

**答**：
```bash
# HTTPS → SSH
git remote set-url origin git@github.com:huayujingyun/ocr-card-recognizer.git

# SSH → HTTPS
git remote set-url origin https://github.com/huayujingyun/ocr-card-recognizer.git
```

---

## 📞 需要帮助？

如果遇到问题：

1. **查看详细错误**：`GIT_TRACE=1 git push -u origin main`
2. **检查网络连接**：`ping github.com`
3. **验证用户名**：确认是 `huayujingyun`
4. **验证仓库名**：确认是 `ocr-card-recognizer`

---

## 🎯 快速命令参考

```bash
# 查看远程仓库
git remote -v

# 移除远程仓库
git remote remove origin

# 添加HTTPS远程仓库
git remote add origin https://github.com/huayujingyun/ocr-card-recognizer.git

# 添加SSH远程仓库
git remote add origin git@github.com:huayujingyun/ocr-card-recognizer.git

# 推送到远程仓库
git push -u origin main

# 测试SSH连接
ssh -T git@github.com

# 配置凭证存储
git config --global credential.helper store
```
