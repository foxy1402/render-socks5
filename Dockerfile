FROM schors/tgdante2:latest

RUN apk add --no-cache netcat-openbsd bash

COPY health-server.sh /health-server.sh
RUN chmod +x /health-server.sh

CMD ["/bin/sh", "-c", "/health-server.sh & exec /app/tgdante2 -l 0.0.0.0:1080"]
