# 任务：优化 Dockerfile.cosyvoice-ui-gpu 减小镜像体积

## 计划

1.  **定义 `builder` 阶段**:
    *   基于 `nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04` 镜像，并将其命名为 `builder`。
    *   在一个 `RUN` 指令中完成 `apt-get update`、安装所有构建时依赖，并清理 `apt` 缓存。
    *   保留现有的 Conda 安装和配置逻辑。
    *   在一个 `RUN` 指令中完成 `git clone`、创建 Conda 环境、安装 `pynini` 和 `requirements.txt` 中的所有 Python 包，并在 `pip install` 中使用 `--no-cache-dir` 选项。

2.  **定义 `final` 运行阶段**:
    *   基于更小的 `nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04` 镜像。
    *   仅安装运行应用所必需的库，并清理 `apt` 缓存。
    *   使用 `COPY --from=builder` 指令，从 `builder` 阶段精确地复制已安装好的 Conda 环境和 `CosyVoice` 源代码。
    *   设置所有必要的环境变量和 `entrypoint`。
    *   设置工作目录。 