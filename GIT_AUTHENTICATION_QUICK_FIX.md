# Git认证问题 - 快速修复指南

## 🎯 问题原因

GitHub已停止支持密码认证，现在需要使用：
- Personal Access Token (PAT)
- SSH密钥

---

## ⚡ 最简单的解决方案（5分钟完成）

### 步骤1：创建Personal Access Token

1. 点击此链接：https://github.com/settings/tokens/new
2. 填写：
   - Note: `OCR Card Recognizer`
   - Expiration: `90 days`（或自定义）
   - Scopes: 勾选 ✅ `repo`
3. 点击页面底部的 `Generate token`
4. **立即复制token**（只显示一次！）

---

### 步骤2：使用Token推送代码

运行以下命令：

```bash
# 重新推送（会提示输入用户名和密码）
git push -u origin main
```

**输入信息**：
- Username: `huayujingyun`（您的GitHub用户名）
- Password: `粘贴刚才复制的token`

✅ 完成！

---

## 🔄 如果还是失败

### 方案A：清除旧凭证

```bash
# 移除远程仓库
git remote remove origin

# 重新添加
git remote add origin https://github.com/huayujingyun/ocr-card-recognizer.git

# 重新推送
git push -u origin main
```

### 方案B：使用SSH密钥（更安全）

1. 生成SSH密钥：
   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```
   （按3次Enter使用默认设置）

2. 复制公钥：
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```

3. 添加到GitHub：
   - 访问：https://github.com/settings/keys
   - 点击 "New SSH key"
   - 粘贴公钥内容

4. 切换到SSH：
   ```bash
   git remote set-url origin git@github.com:huayujingyun/ocr-card-recognizer.git
   git push -u origin main
   ```

---

## 📖 完整文档

详细说明请查看：`GIT_AUTHENTICATION_FIX.md`

---

## 💡 提示

- **Personal Access Token**：简单快速，但需要定期更新
- **SSH密钥**：一次配置，永久使用，推荐长期项目
- **Token只显示一次**：复制后保存到安全的地方

---

## 🆘 需要帮助？

如果遇到问题，请告诉我：
1. 您使用了哪种方案？
2. 遇到了什么错误信息？

我会提供进一步的帮助！
