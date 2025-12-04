FROM schors/tgdante2:latest

RUN apk add --no-cache netcat-openbsd bash

COPY health-server.sh /health-server.sh
RUN chmod +x /health-server.sh

EXPOSE 8080 1080

CMD ["/health-server.sh"]
