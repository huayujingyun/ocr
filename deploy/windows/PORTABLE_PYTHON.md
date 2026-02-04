# 便携式Windows部署方案（无需安装Python）

## 方案概述

使用便携式Python环境，无需在系统中安装Python，直接运行。

## 下载便携式Python

### 方法1：使用嵌入式Python（推荐）

1. 下载Python嵌入式版本（3.12）
   - 地址：https://www.python.org/downloads/windows/
   - 选择 "Windows embeddable package (64-bit)"
   - 文件：`python-3.12.x-embed-amd64.zip`

2. 解压到 `backend/python` 目录
   ```
   backend/
   └── python/
       ├── python.exe
       ├── python312.zip
       └── ...
   ```

3. 创建 `python312._pth` 文件（在 `python` 目录下）：
   ```
   python312.zip
   .
   lib/site-packages
   ```

4. 在 `backend/python` 目录下安装依赖：
   ```batch
   cd backend\python
   python.exe -m ensurepip
   python.exe -m pip install --upgrade pip
   python.exe -m pip install -r ..\requirements.txt
   ```

### 方法2：使用便携式发行版

1. 下载便携式Python（WinPython）
   - 地址：https://winpython.github.io/
   - 选择Python 3.12版本
   - 解压到 `backend/python` 目录

## 修改启动脚本

使用便携式Python启动后端：

```batch
@echo off
cd backend
set PATH=%PATH%;%~dp0python
python.exe main.py
cd ..
```

## 目录结构

```
ocr-card-recognizer/
├── start.bat
├── stop.bat
├── backend/
│   ├── main.py
│   ├── requirements.txt
│   └── python/              # 便携式Python环境
│       ├── python.exe
│       ├── python312.zip
│       ├── Lib/
│       └── Scripts/
│           ├── pip.exe
│           └── ...
└── frontend/
    └── ...
```

## 优点

- ✅ 无需管理员权限
- ✅ 不影响系统Python环境
- ✅ 可以随应用一起分发
- ✅ 可以卸载（直接删除文件夹）

## 注意事项

1. 便携式Python可能缺少某些系统依赖
2. 某些库可能需要额外的C运行时库
3. 首次启动可能需要下载模型文件（约200MB）

## 安装依赖

在便携式Python环境中安装依赖：

```batch
cd backend\python
python.exe -m pip install -r ..\requirements.txt
```

如果遇到SSL错误：

```batch
python.exe -m pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org -r ..\requirements.txt
```
