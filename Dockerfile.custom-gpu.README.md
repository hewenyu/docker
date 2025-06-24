# 自定义 ChatTTS-ui GPU 版本 Dockerfile

这个自定义的Dockerfile是为ChatTTS-ui项目设计的GPU版本。它基于NVIDIA CUDA 12.9.0并使用Python 3.11环境。

## 特点

- 基于 NVIDIA CUDA 12.9.0 和 Ubuntu 22.04
- Python 3.11 环境
- 包含常用机器学习和音频处理依赖
- 针对GPU加速优化

## 自定义内容

相比原始版本，此Dockerfile添加/修改了以下内容：

1. 使用更新的CUDA 12.9.0版本
2. 使用Python 3.11
3. 添加了更多的系统依赖，包括OpenBLAS、LAPACK等
4. 优化了构建过程

## 使用方法

从DockerHub拉取镜像：

```bash
docker pull hewenyulucky/chattts-ui:custom-gpu-latest
```

运行容器：

```bash
docker run -d --gpus all -p 8080:8080 --name chattts-ui hewenyulucky/chattts-ui:custom-gpu-latest
```

## 环境变量

您可以通过环境变量自定义容器行为：

```bash
docker run -d --gpus all -p 8080:8080 -e VARIABLE_NAME=value --name chattts-ui hewenyulucky/chattts-ui:custom-gpu-latest
```

## 持久化数据

挂载卷以持久化数据：

```bash
docker run -d --gpus all -p 8080:8080 -v /your/local/path:/app/data --name chattts-ui hewenyulucky/chattts-ui:custom-gpu-latest
```
