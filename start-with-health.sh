#!/bin/sh

# Start a simple HTTP health check server in background
(
  while true; do
    printf "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n<html><body style='font-family: Arial; text-align: center; padding: 50px;'><h1 style='color: green;'>✓ SOCKS5 Server Running</h1><p>Host: <b>render-socks5.onrender.com</b></p><p>Port: <b>10000</b></p><p>Username: <b>admin</b></p><p>Type: <b>SOCKS5</b></p></body></html>\r\n" | nc -l -p 8080
  done
) &

# Start SOCKS5 server with environment variables
# USER, PASS, and PORT are already set by Render
exec /run.sh
