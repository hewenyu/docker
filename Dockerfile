FROM alpine:latest

LABEL maintainer="yueban"
LABEL description="Clash proxy service"

# 安装必要的依赖
RUN apk add --no-cache curl gzip tar ca-certificates file

# 创建工作目录
WORKDIR /root/clash

# 下载 Clash 二进制文件
RUN curl -L "https://s.stotik.com/download/clash/1_18_0/clash-linux-amd64-v1.18.0.gz" -o clash-linux-amd64-v1.18.0.gz && \
    echo "Downloaded file info:" && \
    ls -lh clash-linux-amd64-v1.18.0.gz && \
    file clash-linux-amd64-v1.18.0.gz && \
    echo "First 100 bytes:" && \
    head -c 100 clash-linux-amd64-v1.18.0.gz | od -A x -t x1z -v && \
    if file clash-linux-amd64-v1.18.0.gz | grep -q "gzip compressed data"; then \
        echo "Valid gzip file, decompressing..."; \
        gzip -d clash-linux-amd64-v1.18.0.gz && \
        chmod +x clash-linux-amd64-v1.18.0; \
    else \
        echo "ERROR: Downloaded file is not gzip format!"; \
        echo "File content:"; \
        cat clash-linux-amd64-v1.18.0.gz; \
        exit 1; \
    fi

# 下载控制面板文件
RUN curl -L "https://s.stotik.com/download/clash/1_18_0/clash-dashboard.tar.gz" -o clash-dashboard.tar.gz && \
    tar xzf clash-dashboard.tar.gz && \
    rm clash-dashboard.tar.gz

# 下载 GeoIP 数据库文件
RUN curl -L "https://s.stotik.com/download/clash/Country.mmdb" -o Country.mmdb

# 暴露端口
# 7890: HTTP/HTTPS 代理端口
# 7891: SOCKS5 代理端口
# 9090: 外部控制端口（Dashboard）
EXPOSE 7890 7891 9090

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:9090 || exit 1

# 启动 Clash
# config.yaml 需要通过挂载卷提供
CMD ["/root/clash/clash-linux-amd64-v1.18.0", "-d", "/root/clash"]
