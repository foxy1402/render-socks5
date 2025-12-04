FROM alpine:latest

RUN apk add --no-cache tinyproxy

RUN mkdir -p /etc/tinyproxy

COPY tinyproxy.conf /etc/tinyproxy/tinyproxy.conf

EXPOSE 8080

CMD ["tinyproxy", "-d", "-c", "/etc/tinyproxy/tinyproxy.conf"]
