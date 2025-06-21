# Docker镜像自动构建

本仓库包含多个开源项目的Docker镜像自动构建工作流。所有镜像均会自动发布到DockerHub。

## 目前支持的项目

### 1. F5-TTS

F5-TTS 是一个高质量的文本转语音工具。

- **源代码仓库**: [SWivid/F5-TTS](https://github.com/SWivid/F5-TTS)
- **DockerHub镜像**: `hewenyulucky/f5-tts`
- **标签**:
  - `latest`: 最新版本
  - `<tag>`: 对应源代码仓库的特定版本标签

**使用方法**:

```bash
docker pull hewenyulucky/f5-tts:latest
```

### 2. ChatTTS-ui

ChatTTS-ui 是一个聊天语音合成用户界面，提供CPU和GPU两种版本。

- **源代码仓库**: [jianchang512/ChatTTS-ui](https://github.com/jianchang512/ChatTTS-ui)
- **DockerHub镜像**: `hewenyulucky/chattts-ui`
- **标签**:
  - `cpu-latest`: CPU版本最新构建
  - `cpu-<tag>`: CPU版本对应源代码特定版本
  - `gpu-latest`: GPU版本最新构建
  - `gpu-<tag>`: GPU版本对应源代码特定版本

**使用方法**:

```bash
# CPU版本
docker pull hewenyulucky/chattts-ui:cpu-latest

# GPU版本
docker pull hewenyulucky/chattts-ui:gpu-latest
```

## 自动化构建

所有镜像每月自动从源代码仓库的最新标签构建并推送到DockerHub。也可以通过GitHub Actions手动触发构建。
