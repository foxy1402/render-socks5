# -------------------------------------------------
# 1️⃣ Base image – already contains OpenVPN & Easy‑RSA
FROM kylemanna/openvpn

# -------------------------------------------------
# 2️⃣ Run Easy‑RSA in batch mode – disables all prompts
ENV EASYRSA_BATCH=1

# -------------------------------------------------
# 3️⃣ Build‑time steps (run only while the image is being built)

# 3a️⃣ Generate a minimal TCP server config (port 1194)
RUN ovpn_genconfig -u tcp://$(hostname)

# 3b️⃣ Initialise the PKI (CA, server cert, DH params) – non‑interactive
RUN ovpn_initpki nopass

# 3c️⃣ Create ONE client certificate (change the name if you want more)
ARG CLIENT_NAME=myclient
RUN easyrsa build-client-full "$CLIENT_NAME" nopass

# 3d️⃣ Make a folder to store the client file and write it there
RUN mkdir -p /client && \
    ovpn_getclient "$CLIENT_NAME" > "/client/$CLIENT_NAME.ovpn"

# -------------------------------------------------
# 4️⃣ When the container starts we do two things:
#    • Print the client config to stdout (so you can copy it from Render logs)
#    • Launch OpenVPN in the foreground (Render watches this process)
ENTRYPOINT ["/bin/sh","-c", "\
  echo '--- BEGIN CLIENT CONFIG ------------------------------------------------'; \
  cat /client/myclient.ovpn; \
  echo '--- END CLIENT CONFIG --------------------------------------------------'; \
  exec openvpn --config /etc/openvpn/openvpn.conf \
"]
