#!/bin/sh

# Simple HTTP server for health checks
while true; do
  {
    echo "HTTP/1.1 200 OK"
    echo "Content-Type: text/html"
    echo ""
    echo "<!DOCTYPE html>"
    echo "<html>"
    echo "<head><title>SOCKS5 Server Status</title>"
    echo "<style>body{font-family:Arial;text-align:center;padding:50px;background:#1a1a1a;color:#fff}"
    echo "h1{color:#00ff00}a{color:#00aaff}</style></head>"
    echo "<body>"
    echo "<h1>✓ SOCKS5 Server is Running</h1>"
    echo "<p><strong>Host:</strong> render-socks5.onrender.com</p>"
    echo "<p><strong>SOCKS5 Port:</strong> 10000</p>"
    echo "<p><strong>Username:</strong> admin</p>"
    echo "<p><strong>Status:</strong> <span style='color:#00ff00'>Online</span></p>"
    echo "<hr>"
    echo "<p><small>Use this server with any SOCKS5 client (Telegram, browser proxy, etc.)</small></p>"
    echo "</body></html>"
  } | nc -l -p ${PORT:-8080} -q 1
done
