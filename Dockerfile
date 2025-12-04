FROM schors/tgdante2:latest

# Your SOCKS5 server is already configured by the base image
# It will automatically use these environment variables:
# - USER (for SOCKS5 username)
# - PASS (for SOCKS5 password)
# - PORT (for SOCKS5 port, defaults to 1080)
