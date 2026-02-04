# 🚀 快速开始指南

## 一键安装（5分钟内完成）

### 前置要求（必须）

1. ✅ **Docker Desktop**
   - 下载：https://www.docker.com/products/docker-desktop
   - 安装并启动

2. ✅ **Windows 10/11**

3. ✅ **管理员权限**

### 安装步骤

1. **解压文件**
   - 将 `card-ocr-deployment.zip` 解压到任意目录
   - 例如：`C:\card-ocr-deployment`

2. **运行安装脚本**
   ```
   右键点击 install.bat → 选择"以管理员身份运行"
   ```

3. **等待完成**
   - 首次安装需要10-20分钟（下载依赖）
   - 等待看到"安装完成"提示

4. **启动服务**
   ```
   双击运行 start.bat
   ```

5. **访问应用**
   ```
   浏览器打开：http://localhost:5000
   ```

---

## 常用命令

| 操作 | 命令 |
|------|------|
| 启动服务 | 双击 `start.bat` |
| 停止服务 | 双击 `stop.bat` |
| 查看状态 | 双击 `status.bat` |
| 检查依赖 | 双击 `check-deps.bat` |

---

## 首次使用

### 1. 设置识别模板（推荐）

1. 点击"设置识别模板"
2. 上传一张清晰的卡片图片
3. 框选卡号区域
4. 框选密码区域
5. 保存模板

### 2. 批量识别

1. 点击"上传图片"
2. 选择多张卡片图片
3. 点击"开始识别"
4. 等待识别完成

### 3. 导出结果

1. 检查识别结果
2. 编辑错误项
3. 点击"导出Excel"

---

## 故障排除

### 问题：Docker未启动

**解决**：启动Docker Desktop，等待图标变绿

### 问题：端口被占用

**解决**：
```cmd
netstat -ano | findstr :5000
taskkill /PID <进程ID> /F
```

### 问题：安装失败

**解决**：
1. 检查网络连接
2. 以管理员身份运行
3. 重启Docker Desktop

---

## 更多帮助

- 📖 **部署文档**：`docs/DEPLOYMENT_GUIDE.md`
- 📖 **用户手册**：`docs/USER_MANUAL.md`
- 🔧 **故障排除**：`docs/TROUBLESHOOTING.md`
- 📄 **完整说明**：`README.md`

---

## 系统要求

| 项目 | 要求 |
|------|------|
| 操作系统 | Windows 10/11 |
| 内存 | 4GB+（推荐8GB） |
| 磁盘空间 | 10GB+ |
| Docker Desktop | 4.15+ |

---

## 注意事项

⚠️ **首次启动**：
- 需要下载PaddleOCR模型（约200MB）
- 确保网络连接正常
- 模型下载后会缓存，无需重复下载

⚠️ **防火墙**：
- 确保Docker可以通过防火墙
- 允许端口5000和8001

⚠️ **杀毒软件**：
- 部分杀毒软件可能拦截Docker
- 请添加信任或临时关闭

---

## 快速测试

安装完成后，可以运行以下命令测试：

```cmd
# 测试后端
curl http://localhost:8001/health

# 测试前端
curl http://localhost:5000
```

预期输出：
```json
{"status":"healthy","ocr_ready":true}
```

---

**祝您使用愉快！** 🎉
