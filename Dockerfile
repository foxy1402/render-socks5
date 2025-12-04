FROM schors/tgdante2:latest

# Install netcat for HTTP health check server
RUN apk add --no-cache netcat-openbsd

# Copy health check server script
COPY health-server.sh /health-server.sh
RUN chmod +x /health-server.sh

# Set default SOCKS5 port (will be overridden by env var if needed)
ENV WORKERS=10

# Start health server in background on $PORT (Render's HTTP port)
# Start SOCKS5 on port 10000
CMD sh -c 'PORT=${PORT:-8080} /health-server.sh & SOCKS_PORT=10000 PORT=10000 exec /run.sh'
