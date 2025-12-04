#!/bin/sh

# Use Render's PORT environment variable or default to 1080
PORT=${PORT:-1080}

# Create dante config with dynamic port
cat <<EOF > /etc/dante/sockd.conf
logoutput: stderr
internal: 0.0.0.0 port = ${PORT}
external: eth0

client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect error
}

socks pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    protocol: tcp udp
    command: bind connect udpassociate
    log: error connect disconnect
    socksmethod: username
}
EOF

# Start dante server
exec sockd -D
