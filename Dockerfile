FROM schors/tgdante2:latest

RUN apk add --no-cache netcat-openbsd

COPY health-server.sh /health-server.sh

RUN chmod +x /health-server.sh

# Expose port 8080 for HTTP proxy
EXPOSE 8080

# Start tgdante2 as HTTP proxy on 0.0.0.0:8080
CMD ["/bin/sh", "-c", "tgdante2 -l 0.0.0.0:8080 -protocol http"]
