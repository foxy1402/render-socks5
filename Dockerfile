# -------------------------------------------------
# 1️⃣ Base image that already contains OpenVPN + Easy‑RSA
FROM kylemanna/openvpn

# -------------------------------------------------
# 2️⃣ Make Easy‑RSA run without interactive prompts
ENV EASYRSA_BATCH=1

# -------------------------------------------------
# 3️⃣ Build‑time steps (run only while the image is being built)

# 3a️⃣ Create a minimal server config that will listen on TCP 1194.
#      $(hostname) will be replaced by the container’s host name at runtime.
RUN ovpn_genconfig -u tcp://$(hostname)

# 3b️⃣ Initialise the PKI (CA, server cert, DH params) – non‑interactive.
RUN ovpn_initpki nopass

# 3c️⃣ Create ONE client certificate (you can change the name if you like)
ARG CLIENT_NAME=myclient
RUN easyrsa build-client-full "$CLIENT_NAME" nopass

# 3d️⃣ Export the ready‑to‑import .ovpn file into the image.
RUN ovpn_getclient "$CLIENT_NAME" > "/client/$CLIENT_NAME.ovpn"

# -------------------------------------------------
# 4️⃣ When the container runs we do two things:
#    • Print the client file to stdout (so you can copy it from Render logs)
#    • Start the OpenVPN daemon (foreground) – this is what Render watches.
ENTRYPOINT ["/bin/sh","-c", "\
  echo '--- BEGIN CLIENT CONFIG ------------------------------------------------'; \
  cat /client/myclient.ovpn; \
  echo '--- END CLIENT CONFIG --------------------------------------------------'; \
  exec openvpn --config /etc/openvpn/openvpn.conf \
"]
