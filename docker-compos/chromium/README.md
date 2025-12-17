# Chromium Docker Compose

基于 chromium 浏览器的 Docker 容器配置文件。

## 使用说明

### 1. 修改配置

编辑 `docker-compose.yml` 文件，将代理服务器地址修改为你自己的：

```yaml
- CHROME_ARGS=--hide-scrollbars --timezone=America/New_York --fingerprint-platform=windows --fingerprint-brand=Chrome --force-webrtc-ip-handling-policy --webrtc-ip-handling-policy=disable_non_proxied_udp --proxy-server=socks5://用户名:密码@地址:端口
```

将 `用户名:密码@地址:端口` 替换为实际的代理服务器信息。

### 2. 启动服务

```bash
docker-compose up -d
```

### 3. 访问浏览器

在浏览器中访问：http://localhost:3001

### 4. 停止服务

```bash
docker-compose down
```

## 配置说明

- **端口**: 3001
- **配置目录**: `./config` (映射到容器内的 `/config`)
- **共享内存**: 1GB
- **时区**: America/New_York
- **环境变量**:
  - `LC_ALL`: en-US.UTF-8
  - `CHROME_ARGS`: Chrome 启动参数
