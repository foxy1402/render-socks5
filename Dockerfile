FROM alpine:latest

RUN apk add --no-cache tinyproxy python3

RUN mkdir -p /etc/tinyproxy /app

COPY tinyproxy.conf /etc/tinyproxy/tinyproxy.conf
COPY index.html /app/index.html

EXPOSE 8080

CMD sh -c "tinyproxy -d -c /etc/tinyproxy/tinyproxy.conf & python3 -m http.server 9000 --directory /app"
