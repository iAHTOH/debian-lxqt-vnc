
FROM debian:stable-slim


LABEL maintainer="admin@iahtoh.ru" \
      io.k8s.description="Headless VNC Container with LXQt Desktop manager" \
      io.k8s.display-name="Headless VNC Container based on Debian" \
      io.openshift.expose-services="5901:xvnc" \
      io.openshift.tags="vnc, debian, lxqt" \
      io.openshift.non-scalable=true


ENV HOME=/home/headless

ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get update && \
  apt-get install -y \
# X Server
  xvfb \
# VNC Server
  x11vnc \
# Openbox
  openbox menu \
# NoVNC with dependencies
  git net-tools && \
  # must switch to a release tag once the ssl-only arg included
  git clone https://github.com/novnc/noVNC /root/noVNC && \
  git clone --branch v0.8.0 https://github.com/novnc/websockify /root/noVNC/utils/websockify && \
# Clean up the apt cache
  rm -rf /var/lib/apt/lists/*

CMD \
# X Server
  Xvfb :1 -screen 0 1920x1080x16 & \
# Openbox
  (export DISPLAY=:1 && openbox-session) & \
# VNC Server
  if [ -z $VNC_PASSWD ]; then \
    # no password
    x11vnc -display :1 -xkb -forever & \
  else \
    # set password from VNC_PASSWD env variable
    mkdir ~/.x11vnc && \
    x11vnc -storepasswd $VNC_PASSWD /root/.x11vnc/passwd && \
    x11vnc -display :1 -xkb -forever -rfbauth /root/.x11vnc/passwd & \
  fi && \
# NoVNC
  openssl req -new -x509 -days 36500 -nodes -batch -out /root/noVNC.pem -keyout /root/noVNC.pem && \
  ln -s /root/noVNC/vnc.html /root/noVNC/index.html && \
  /root/noVNC/utils/launch.sh --vnc localhost:5900 --cert /root/noVNC.pem --ssl-only
