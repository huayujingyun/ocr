# 故障排除指南

## 目录

1. [启动问题](#启动问题)
2. [识别问题](#识别问题)
3. [性能问题](#性能问题)
4. [网络问题](#网络问题)
5. [数据问题](#数据问题)
6. [系统问题](#系统问题)

---

## 启动问题

### 问题1：Docker Desktop未启动

**错误信息**：
```
Cannot connect to the Docker daemon at unix:///var/run/docker.sock
```

**原因**：
- Docker Desktop未启动
- Docker服务异常

**解决方案**：

1. 启动Docker Desktop
2. 等待Docker服务启动完成（右下角Docker图标变为绿色）
3. 重新运行启动脚本

**检查命令**：
```cmd
docker --version
docker info
```

---

### 问题2：端口被占用

**错误信息**：
```
Error starting userland proxy: listen tcp 0.0.0.0:5000: bind: address already in use
```

**原因**：
- 端口5000或8001被其他程序占用

**解决方案**：

1. 查看端口占用：
```cmd
netstat -ano | findstr :5000
netstat -ano | findstr :8001
```

2. 结束占用进程：
```cmd
taskkill /PID <进程ID> /F
```

3. 或修改 `docker-compose.yml` 中的端口：
```yaml
services:
  paddleocr-service:
    ports:
      - "8100:8001"  # 修改外部端口
  frontend:
    ports:
      - "5100:5000"   # 修改外部端口
```

---

### 问题3：容器启动失败

**错误信息**：
```
Container exited with code 1
```

**原因**：
- 配置文件错误
- 依赖缺失
- 权限问题

**解决方案**：

1. 查看容器日志：
```cmd
docker-compose logs paddleocr-service
docker-compose logs frontend
```

2. 检查配置文件：
```cmd
type config\.env
type docker-compose.yml
```

3. 重新构建镜像：
```cmd
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

---

### 问题4：健康检查失败

**错误信息**：
```
Health check failed
```

**原因**：
- 服务未完全启动
- 网络连接问题

**解决方案**：

1. 等待更长时间（首次启动需要1-2分钟）
2. 查看详细日志：
```cmd
docker-compose logs -f
```

3. 手动检查服务：
```cmd
curl http://localhost:8001/health
curl http://localhost:5000
```

---

## 识别问题

### 问题1：识别准确率低

**症状**：
- 识别结果错误
- 卡号或密码识别不准确

**可能原因**：
- 图片质量差
- 模板设置不准确
- 预处理方式不当

**解决方案**：

1. 提高图片质量
   - 使用高分辨率图片
   - 确保光线充足
   - 避免模糊和反光

2. 重新设置模板
   - 上传清晰的参考图片
   - 精确框选识别区域
   - 预览裁剪结果

3. 尝试不同预处理
   - 灰度化
   - 二值化
   - 对比度增强

4. 手动编辑识别结果
   - 点击"编辑"按钮
   - 修正识别错误
   - 保存修改

---

### 问题2：无法识别某些卡片

**症状**：
- 某些卡片识别失败
- 识别结果为空

**可能原因**：
- 卡片格式不支持
- 图片过于模糊
- 字体特殊

**解决方案**：

1. 检查图片质量
   - 确保图片清晰
   - 检查是否有遮挡
   - 确保卡号和密码可见

2. 尝试不同识别模式
   - 切换到"传统OCR"
   - 切换到"条码识别"

3. 调整识别参数
   - 修改 `backend/ocr_service.py`
   - 调整检测阈值
   - 调整识别参数

4. 手动输入
   - 对于无法识别的卡片，手动输入

---

### 问题3：识别速度慢

**症状**：
- 单张识别时间长（>5秒）
- 批量识别慢

**可能原因**：
- 系统资源不足
- 图片分辨率过高
- 批量数量过多

**解决方案**：

1. 减小图片尺寸
   - 压缩图片大小
   - 降低分辨率

2. 减少批量数量
   - 每批最多20张
   - 分批识别

3. 增加系统资源
   - 在Docker Desktop中增加内存分配
   - 增加CPU核心数

4. 使用GPU加速（如果可用）
   - 修改 `backend/Dockerfile`
   - 使用GPU版本的PaddlePaddle

---

## 性能问题

### 问题1：内存占用过高

**症状**：
- 系统卡顿
- Docker占用大量内存

**可能原因**：
- 批量识别数量多
- Docker内存分配不足

**解决方案**：

1. 在Docker Desktop中增加内存分配
   - 设置 → Advanced → Memory
   - 建议设置为8GB+

2. 减小批处理数量
   - 修改 `backend/ocr_service.py`
   - 降低 `rec_batch_num` 值

3. 减小图片尺寸
   - 压缩图片
   - 降低分辨率

---

### 问题2：CPU占用高

**症状**：
- CPU占用率持续在100%
- 系统响应慢

**解决方案**：

1. 降低批处理数量
2. 使用GPU加速
3. 限制并发数量

---

### 问题3：磁盘空间不足

**症状**：
- Docker提示磁盘空间不足
- 构建失败

**解决方案**：

1. 清理Docker缓存
```cmd
docker system prune -a
```

2. 清理未使用的镜像
```cmd
docker image prune -a
```

3. 增加Docker磁盘空间
   - 设置 → Advanced → Disk image size
   - 设置为60GB+

---

## 网络问题

### 问题1：模型下载失败

**错误信息**：
```
Connection refused
Timeout
```

**原因**：
- 网络连接问题
- 模型下载源不可用

**解决方案**：

1. 检查网络连接
2. 重启服务
```cmd
docker-compose restart paddleocr-service
```

3. 手动下载模型（参考下面的详细步骤）

---

### 问题2：无法访问服务

**症状**：
- 浏览器无法打开 http://localhost:5000
- 提示"无法访问此网站"

**解决方案**：

1. 检查服务状态
```cmd
docker-compose ps
```

2. 检查防火墙设置
3. 检查端口映射
4. 尝试使用IP地址访问
   - 查看本机IP：`ipconfig`
   - 访问：`http://<本机IP>:5000`

---

## 数据问题

### 问题1：数据丢失

**症状**：
- 识别结果消失
- 配置重置

**解决方案**：

1. 检查Docker卷状态
```cmd
docker volume ls
docker volume inspect paddleocr-cache
```

2. 恢复备份（如果有）
3. 重新导入数据

---

### 问题2：导出失败

**症状**：
- 点击"导出Excel"无响应
- 导出文件损坏

**解决方案**：

1. 分批导出（每次不超过100张）
2. 使用Chrome浏览器
3. 清除浏览器缓存
4. 检查磁盘空间

---

## 系统问题

### 问题1：Windows更新后无法启动

**症状**：
- Windows更新后服务无法启动
- Docker Desktop异常

**解决方案**：

1. 重启Docker Desktop
2. 重新启动服务
```cmd
docker-compose down
docker-compose up -d
```

3. 如果仍然失败，重新安装Docker Desktop

---

### 问题2：WSL2问题

**错误信息**：
```
WSL 2 installation is incomplete
```

**解决方案**：

1. 更新WSL
```cmd
wsl --update
```

2. 重启计算机
3. 重新启动Docker Desktop

---

## 日志位置

### Docker日志

```cmd
# 查看所有日志
docker-compose logs -f

# 查看后端日志
docker-compose logs -f paddleocr-service

# 查看前端日志
docker-compose logs -f frontend

# 保存日志到文件
docker-compose logs > logs/docker.log
```

### 系统日志

Windows事件查看器：
- Windows日志 → 应用程序
- 搜索"Docker"或"docker"

---

## 联系支持

如果以上方案都无法解决问题：

1. 收集以下信息：
   - 错误截图
   - 完整的错误日志
   - 系统信息（Windows版本、Docker版本）

2. 提交Issue：
   - GitHub: https://github.com/your-repo/issues
   - 邮箱: support@example.com

3. 查看在线文档：
   - https://github.com/your-repo/docs

---

**希望这份文档能帮助您解决问题！**
