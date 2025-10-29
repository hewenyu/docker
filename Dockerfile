FROM alpine:latest

LABEL maintainer="yueban"
LABEL description="Clash proxy service"

# 安装必要的依赖
RUN apk add --no-cache curl gzip tar ca-certificates

# 创建工作目录
WORKDIR /root/clash

# 下载 Clash 二进制文件
RUN curl -L "https://s.stotik.com/download/clash/1_18_0/clash-linux-amd64-v1.18.0.gz" -o clash-linux-amd64-v1.18.0.gz && \
    gzip -d clash-linux-amd64-v1.18.0.gz && \
    chmod +x clash-linux-amd64-v1.18.0

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
