# Windows部署目录结构

## 目录规划
```
ocr-card-recognizer/
├── README.md                          # 部署说明
├── install.bat                        # 一键安装脚本
├── start.bat                          # 一键启动脚本
├── stop.bat                           # 一键停止脚本
├── check.bat                          # 服务状态检查
│
├── frontend/                          # 前端应用
│   ├── package.json
│   ├── pnpm-lock.yaml
│   ├── next.config.js
│   ├── .next/                         # 构建输出
│   └── node_modules/                  # 依赖
│
├── backend/                           # 后端应用
│   ├── main.py
│   ├── ocr_service.py
│   ├── requirements.txt
│   └── python/                        # 便携式Python环境（可选）
│       └── python.exe
│
├── models/                            # 预下载的OCR模型（可选）
│   ├── det/
│   ├── rec/
│   └── cls/
│
├── logs/                              # 日志目录
│   ├── backend.log
│   └── frontend.log
│
├── docker/                            # Docker部署文件
│   ├── Dockerfile
│   └── docker-compose.yml
│
└── data/                              # 数据目录
    ├── uploads/                       # 上传的图片
    └── exports/                       # 导出的文件
```
