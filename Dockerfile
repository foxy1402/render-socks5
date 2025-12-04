# -------------------------------------------------
# Base image that already contains OpenVPN
FROM kylemanna/openvpn

# -------------------------------------------------
# When the container starts:
#   * If no server config exists, create a very simple one
#   * Then launch OpenVPN in the foreground (needed so Render stays “running”)
CMD ["sh","-c", "\
  if [ ! -f /etc/openvpn/openvpn.conf ]; then \
    echo 'Generating simple server config…' && \
    ovpn_genconfig -u tcp://$(hostname) && \
    ovpn_initpki nopass; \
  fi && \
  exec openvpn --config /etc/openvpn/openvpn.conf \
"]
