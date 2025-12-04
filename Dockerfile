# ---------- 1️⃣ Base image ----------
FROM alpine:latest

# ---------- 2️⃣ Install Dante ----------
#   -dante-server provides the `sockd` daemon
#   -openssl is needed for the optional TLS variant (not used here)
RUN apk add --no-cache dante-server

# ---------- 3️⃣ Set default credentials ----------
# These environment variables can be overridden in Render’s “Environment” UI.
ENV SOCKS_USER   user
ENV SOCKS_PASS   password

# ---------- 4️⃣ Create a small Dante config file ----------
# The config uses the $PORT variable that Render injects at runtime.
# It also reads the username/password from the env vars above.
RUN mkdir -p /etc/dante && \
cat > /etc/dante/sockd.conf <><>'EOF'
logoutput: stderr
internal: 0.0.0.0 port = ${PORT:-1080}
external: eth0

# Only allow connections from anywhere (you can lock this down later)
method: username
user.privileged: root
client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect error
}
# Authentication rule – check username/password against the ones below
pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    protocol: tcp udp
    method: username
    username: "${SOCKS_USER}"
    password: "${SOCKS_PASS}"
}
EOF

# ---------- 5️⃣ Expose the (default) port ----------
EXPOSE 1080

# ---------- 6️⃣ Start the daemon ----------
# `sockd -D` runs it in the foreground (required on Render)
CMD ["sockd", "-D"]
