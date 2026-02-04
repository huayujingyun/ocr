# 同步代码到GitHub - 操作指南

## 📋 当前状态

### Git仓库状态
- ✅ 工作树：干净（无待提交更改）
- ✅ 当前分支：main
- ✅ 待推送提交：5个
- ✅ 远程仓库：`https://github.com/huayujingyun/ocr.git`

### 待推送的提交

```
27d6e00 fix: 修复PowerShell脚本编码问题，将所有中文替换为英文
548b635 docs: 添加Git认证问题解决方案
3c5d9a2 docs: 添加Git仓库状态报告和配置指南
8911e5d docs: 添加打包指南和下载链接说明文档
e3924ea feat: 创建Windows本地部署方案，提供完整的部署包和管理脚本
```

---

## 🚀 同步步骤

### 方法1：使用Personal Access Token（推荐）

#### 步骤1：获取Personal Access Token

1. 访问：https://github.com/settings/tokens/new
2. 填写：
   - **Note**: `OCR Card Recognizer`
   - **Expiration**: `90 days`（或自定义）
   - **Scopes**: 勾选 ✅ `repo`
3. 点击 `Generate token`
4. **立即复制token**（只显示一次！）

#### 步骤2：推送代码

```bash
git push -u origin main
```

**输入信息**：
- Username: `huayujingyun`
- Password: `粘贴刚才复制的token`

---

### 方法2：使用SSH密钥（更安全）

#### 步骤1：生成SSH密钥

```bash
# 生成SSH密钥
ssh-keygen -t ed25519 -C "your_email@example.com"

# 按Enter使用默认设置
```

#### 步骤2：复制公钥

```bash
# 查看公钥
cat ~/.ssh/id_ed25519.pub

# 复制输出内容（从 ssh-rsa 开始）
```

#### 步骤3：添加到GitHub

1. 访问：https://github.com/settings/keys
2. 点击 "New SSH key"
3. 粘贴公钥内容
4. 点击 "Add SSH key"

#### 步骤4：切换到SSH URL

```bash
# 切换远程仓库URL为SSH
git remote set-url origin git@github.com:huayujingyun/ocr.git

# 推送代码
git push -u origin main
```

---

### 方法3：使用GitHub CLI（最便捷）

```bash
# 安装GitHub CLI（如果未安装）
# https://cli.github.com/

# 登录GitHub
gh auth login

# 推送代码
git push -u origin main
```

---

## 📊 推送命令对比

| 方法 | 命令 | 优点 | 缺点 |
|------|------|------|------|
| **PAT** | `git push -u origin main` | 简单快速 | Token会过期 |
| **SSH** | `git remote set-url origin git@github.com:huayujingyun/ocr.git` | 安全稳定 | 配置稍复杂 |
| **GitHub CLI** | `gh auth login && git push -u origin main` | 功能强大 | 需安装工具 |

---

## 🔧 验证推送

推送成功后，验证代码是否已同步：

```bash
# 查看远程分支
git branch -r

# 查看远程提交
git log origin/main --oneline -5

# 或者访问GitHub仓库
# https://github.com/huayujingyun/ocr
```

---

## ❌ 常见错误处理

### 错误1：认证失败

```
remote: Invalid username or token.
fatal: Authentication failed
```

**解决方案**：
- 确保使用的是Personal Access Token，不是GitHub密码
- 重新生成token并更新

### 错误2：权限被拒绝

```
remote: Permission to huayujingyun/ocr.git denied
fatal: unable to access
```

**解决方案**：
- 确认token有`repo`权限
- 确认仓库存在且您有写入权限

### 错误3：仓库不存在

```
fatal: repository 'https://github.com/huayujingyun/ocr.git/' not found
```

**解决方案**：
- 访问 https://github.com/new 创建仓库
- 或更新远程仓库URL

### 错误4：连接超时

```
fatal: unable to access 'https://github.com/...': Connection timed out
```

**解决方案**：
- 检查网络连接
- 尝试使用代理
- 或使用SSH URL

---

## 💡 最佳实践

### 推荐工作流

1. **使用Personal Access Token**（简单）
   ```bash
   git push -u origin main
   # 输入用户名和token
   ```

2. **使用SSH密钥**（长期项目）
   ```bash
   # 一次性配置SSH密钥
   git remote set-url origin git@github.com:huayujingyun/ocr.git
   git push -u origin main
   ```

3. **保存凭证**（避免重复输入）
   ```bash
   git config --global credential.helper store
   ```

---

## 📞 需要帮助？

如果遇到问题，请提供：

1. 完整的错误信息
2. 使用的认证方法（PAT/SSH/CLI）
3. Git版本：`git --version`

---

## 🎯 快速参考

```bash
# 查看远程仓库
git remote -v

# 查看待推送的提交
git log origin/main..HEAD --oneline

# 推送到远程仓库
git push -u origin main

# 强制推送（谨慎使用）
git push -f origin main

# 查看远程分支
git branch -r

# 拉取远程更改
git pull origin main

# 同步远程分支
git fetch --all
```
