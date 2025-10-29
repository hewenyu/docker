FROM alpine:latest

LABEL maintainer="yueban"
LABEL description="Clash proxy service"

# 安装必要的依赖
RUN apk add --no-cache curl gzip tar ca-certificates file

# 创建工作目录
WORKDIR /root/clash

# 复制并解压 Clash 二进制文件
COPY clash/clash-linux-amd64-v1.18.0.gz /root/clash/clash-linux-amd64-v1.18.0.gz
RUN gzip -d /root/clash/clash-linux-amd64-v1.18.0.gz && \
    chmod +x /root/clash/clash-linux-amd64-v1.18.0

# 复制并解压控制面板文件
COPY clash/clash-dashboard.tar.gz /root/clash/clash-dashboard.tar.gz
RUN tar xzf clash-dashboard.tar.gz && rm clash-dashboard.tar.gz

# 复制 GeoIP 数据库文件
COPY clash/Country.mmdb /root/clash/Country.mmdb

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
