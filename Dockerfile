FROM schors/tgdante2:latest

RUN apk add --no-cache netcat-openbsd

COPY health-server.sh /health-server.sh

RUN chmod +x /health-server.sh

CMD ["/health-server.sh"]
