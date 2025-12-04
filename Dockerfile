# -----------------------------------------------------------------
# 1️⃣ Base image that already contains OpenVPN + Easy‑RSA utilities
FROM kylemanna/openvpn

# -----------------------------------------------------------------
# 2️⃣ Build‑time: create a very simple TCP server config and the PKI
#    – everything is done **without any prompts** (nopass = no pass‑phrase)
RUN set -eux; \
    # Generate a tiny server config that will listen on TCP port 1194.
    # $(hostname) will be replaced by the container's hostname at runtime.
    ovpn_genconfig -u tcp://$(hostname) && \
    # Initialise the CA, server cert, DH params – purely non‑interactive.
    ovpn_initpki nopass

# -----------------------------------------------------------------
# 3️⃣ Build‑time: create ONE client certificate and export the .ovpn file
#    The file is stored at /client/myclient.ovpn and will be printed
#    to the container log when the container starts (see ENTRYPOINT).
RUN set -eux; \
    CLIENT_NAME=myclient; \
    # Create the client key / cert (no pass‑phrase)
    easyrsa build-client-full "$CLIENT_NAME" nopass && \
    # Export a ready‑to‑import .ovpn file
    ovpn_getclient "$CLIENT_NAME" > "/client/$CLIENT_NAME.ovpn"

# -----------------------------------------------------------------
# 4️⃣ When the container runs we do two things:
#    • Print the client file to stdout so you can copy it from the Render logs.
#    • Start the OpenVPN daemon (foreground) – this is what Render watches.
ENTRYPOINT ["/bin/sh","-c", "\
    echo '--- BEGIN CLIENT CONFIG ------------------------------------------------'; \
    cat /client/myclient.ovpn; \
    echo '--- END CLIENT CONFIG --------------------------------------------------'; \
    exec openvpn --config /etc/openvpn/openvpn.conf \
"]
