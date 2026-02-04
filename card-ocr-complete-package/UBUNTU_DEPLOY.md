# Ubuntu 系统部署指南

## 📋 系统要求

- **操作系统**: Ubuntu 20.04 / 22.04 / 24.04
- **CPU**: 2 核心及以上
- **内存**: 2GB 及以上
- **磁盘**: 5GB 可用空间
- **网络**: 可访问外网（用于下载依赖包）

---

## 🚀 方式一：Node.js 直接部署（推荐新手）

### 步骤 1: 更新系统并安装基础工具

```bash
# 更新软件包列表
sudo apt update

# 安装必要的系统工具
sudo apt install -y curl wget git build-essential
```

### 步骤 2: 安装 Node.js 24.x

```bash
# 使用 NodeSource 仓库安装 Node.js 24.x
curl -fsSL https://deb.nodesource.com/setup_24.x | sudo -E bash -

# 安装 Node.js
sudo apt install -y nodejs

# 验证安装
node --version  # 应该显示 v24.x.x
npm --version   # 应该显示 10.x.x
```

### 步骤 3: 安装 pnpm

```bash
# 使用 npm 安装 pnpm
npm install -g pnpm

# 验证安装
pnpm --version
```

### 步骤 4: 下载项目

```bash
# 创建项目目录
mkdir -p ~/card-ocr
cd ~/card-ocr

# 下载项目压缩包（使用之前提供的下载链接）
wget -O card-ocr-app.tar.gz "https://coze-coding-project.tos.coze.site/coze_storage_7591464861117481002/card-ocr-app.tar_b83867ca.gz?sign=1768399853-b45f1358ec-0-547603e7809ad0a85ecb8bb0afa87881d4e497676d08c25ecd4f497fb97d71b6"

# 解压
tar -xzf card-ocr-app.tar.gz

# 清理压缩包
rm card-ocr-app.tar.gz

# 查看项目文件
ls -la
```

### 步骤 5: 安装依赖

```bash
# 安装项目依赖
pnpm install

# 预计耗时：2-5 分钟（取决于网络速度）
```

### 步骤 6: 构建项目

```bash
# 构建生产版本
pnpm build

# 预计耗时：1-3 分钟
```

### 步骤 7: 配置环境变量（可选）

```bash
# 创建环境变量文件
cat > .env.local << 'EOF'
# 应用端口
PORT=5000

# 运行环境
NODE_ENV=production

# 如果需要配置其他环境变量，可以在这里添加
EOF
```

### 步骤 8: 测试启动

```bash
# 启动服务（测试）
pnpm start

# 服务将在 http://localhost:5000 启动
# 按 Ctrl+C 停止
```

### 步骤 9: 配置为系统服务（生产环境推荐）

```bash
# 创建 systemd 服务文件
sudo tee /etc/systemd/system/card-ocr.service > /dev/null << 'EOF'
[Unit]
Description=Card OCR Application
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/card-ocr
Environment="NODE_ENV=production"
ExecStart=/usr/local/bin/pnpm start
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# 重新加载 systemd
sudo systemctl daemon-reload

# 启动服务
sudo systemctl start card-ocr

# 设置开机自启
sudo systemctl enable card-ocr

# 查看服务状态
sudo systemctl status card-ocr

# 查看日志
sudo journalctl -u card-ocr -f
```

### 步骤 10: 配置防火墙（如果需要）

```bash
# 允许 5000 端口
sudo ufw allow 5000/tcp

# 启用防火墙（如果尚未启用）
sudo ufw enable

# 查看防火墙状态
sudo ufw status
```

### 步骤 11: 使用 Nginx 反向代理（生产环境推荐）

```bash
# 安装 Nginx
sudo apt install -y nginx

# 创建 Nginx 配置文件
sudo tee /etc/nginx/sites-available/card-ocr > /dev/null << 'EOF'
server {
    listen 80;
    server_name your-domain.com;  # 修改为您的域名或服务器 IP

    client_max_body_size 50M;

    location / {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
EOF

# 启用站点
sudo ln -s /etc/nginx/sites-available/card-ocr /etc/nginx/sites-enabled/

# 删除默认站点（可选）
sudo rm /etc/nginx/sites-enabled/default

# 测试 Nginx 配置
sudo nginx -t

# 重启 Nginx
sudo systemctl restart nginx
```

---

## 🐳 方式二：Docker 部署（推荐生产环境）

### 步骤 1: 安装 Docker

```bash
# 更新软件包列表
sudo apt update

# 安装 Docker 所需依赖
sudo apt install -y ca-certificates curl gnupg lsb-release

# 添加 Docker 官方 GPG 密钥
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# 添加 Docker 仓库
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 安装 Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 验证安装
docker --version
docker compose version

# 将当前用户添加到 docker 组（避免每次使用 sudo）
sudo usermod -aG docker $USER

# 重新登录以使更改生效（或执行以下命令）
newgrp docker
```

### 步骤 2: 下载并解压项目

```bash
# 创建项目目录
mkdir -p ~/card-ocr
cd ~/card-ocr

# 下载项目压缩包
wget -O card-ocr-app.tar.gz "https://coze-coding-project.tos.coze.site/coze_storage_7591464861117481002/card-ocr-app.tar_b83867ca.gz?sign=1768399853-b45f1358ec-0-547603e7809ad0a85ecb8bb0afa87881d4e497676d08c25ecd4f497fb97d71b6"

# 解压
tar -xzf card-ocr-app.tar.gz
rm card-ocr-app.tar.gz
```

### 步骤 3: 使用 Docker 构建

```bash
# 构建镜像
docker build -t card-ocr-app .

# 预计耗时：3-8 分钟
```

### 步骤 4: 运行容器

```bash
# 运行容器
docker run -d \
  --name card-ocr \
  -p 5000:5000 \
  --restart unless-stopped \
  card-ocr-app

# 查看容器状态
docker ps

# 查看容器日志
docker logs -f card-ocr
```

### 步骤 5: 使用 Docker Compose（推荐）

```bash
# 启动服务
docker compose up -d

# 查看日志
docker compose logs -f

# 停止服务
docker compose down

# 重启服务
docker compose restart
```

---

## 📝 常用管理命令

### Node.js 方式

```bash
# 查看服务状态
sudo systemctl status card-ocr

# 启动服务
sudo systemctl start card-ocr

# 停止服务
sudo systemctl stop card-ocr

# 重启服务
sudo systemctl restart card-ocr

# 查看日志
sudo journalctl -u card-ocr -f

# 更新代码
cd ~/card-ocr
git pull  # 或重新下载压缩包
pnpm install
pnpm build
sudo systemctl restart card-ocr
```

### Docker 方式

```bash
# 查看容器状态
docker ps

# 查看日志
docker logs -f card-ocr

# 停止容器
docker stop card-ocr

# 启动容器
docker start card-ocr

# 重启容器
docker restart card-ocr

# 删除容器
docker rm -f card-ocr

# 查看资源使用
docker stats card-ocr

# 进入容器
docker exec -it card-ocr /bin/sh
```

---

## 🔍 故障排查

### 问题 1: 端口被占用

```bash
# 查看端口占用
sudo lsof -i :5000

# 或使用 netstat
sudo netstat -tulpn | grep :5000

# 终止占用进程
sudo kill -9 <PID>
```

### 问题 2: 服务无法启动

```bash
# 查看详细日志
sudo journalctl -u card-ocr -n 100 --no-pager

# 检查 Node.js 版本
node --version

# 检查依赖安装
cd ~/card-ocr
pnpm list
```

### 问题 3: 内存不足

```bash
# 查看内存使用
free -h

# 查看进程内存使用
ps aux --sort=-%mem | head -10

# 添加 swap（如果需要）
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

### 问题 4: Docker 镜像构建失败

```bash
# 清理 Docker 缓存
docker system prune -a

# 查看详细构建日志
docker build --progress=plain -t card-ocr-app .

# 检查磁盘空间
df -h
```

---

## 🔐 安全加固建议

### 1. 配置 HTTPS（使用 Let's Encrypt）

```bash
# 安装 Certbot
sudo apt install -y certbot python3-certbot-nginx

# 获取证书
sudo certbot --nginx -d your-domain.com

# 自动续期
sudo certbot renew --dry-run
```

### 2. 配置防火墙

```bash
# 只允许必要端口
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS
sudo ufw enable
```

### 3. 限制访问（可选）

```bash
# 在 Nginx 配置中添加 IP 白名单
location / {
    allow 192.168.1.0/24;  # 允许的 IP 段
    deny all;
    proxy_pass http://localhost:5000;
    # ... 其他配置
}
```

---

## 📊 性能优化

### 1. 启用 Node.js 生产模式

```bash
# 确保设置了 NODE_ENV=production
echo "NODE_ENV=production" | sudo tee -a /etc/environment
```

### 2. 配置 PM2（可选）

```bash
# 安装 PM2
npm install -g pm2

# 使用 PM2 启动
cd ~/card-ocr
pm2 start "pnpm start" --name card-ocr

# 设置开机自启
pm2 startup
pm2 save

# 监控
pm2 monit

# 查看日志
pm2 logs card-ocr
```

### 3. 优化 Nginx 配置

```nginx
# 添加缓存和压缩
gzip on;
gzip_vary on;
gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss;

# 代理缓存
proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=my_cache:10m max_size=1g inactive=60m;

location / {
    proxy_cache my_cache;
    proxy_pass http://localhost:5000;
    # ... 其他配置
}
```

---

## ✅ 部署检查清单

- [ ] Node.js 24.x 已安装
- [ ] pnpm 已安装
- [ ] 项目代码已下载
- [ ] 依赖已安装（pnpm install）
- [ ] 项目已构建（pnpm build）
- [ ] 服务可正常启动（http://localhost:5000）
- [ ] 系统服务已配置（systemd）
- [ ] 防火墙规则已设置
- [ ] Nginx 反向代理已配置（可选）
- [ ] HTTPS 证书已配置（推荐）
- [ ] 日志监控已设置
- [ ] 备份策略已制定

---

## 📞 获取帮助

如遇到问题，请检查：
1. 系统日志：`sudo journalctl -xe`
2. 服务日志：`sudo journalctl -u card-ocr -f`
3. Nginx 日志：`sudo tail -f /var/log/nginx/error.log`
4. Docker 日志：`docker logs card-ocr`

---

## 🎉 完成部署

部署完成后，访问以下地址：

- **本地访问**: http://localhost:5000
- **服务器访问**: http://your-server-ip:5000
- **通过域名访问**: http://your-domain.com（如果配置了 Nginx）

开始使用您的 OCR 识别系统吧！🚀
