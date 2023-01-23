
FROM debian:stable-slim

RUN         apt-get update && \
            apt-get install -y sudo mc openbox\
            lxqt-about lxqt-config lxqt-globalkeys lxqt-notificationd \
            lxqt-openssh-askpass lxqt-panel lxqt-policykit lxqt-qtplugin lxqt-runner \
            lxqt-theme-debian lxqt-branding-debian lxqt-session \
            featherpad nano qterminal synaptic \   
            && \
            apt-get clean \
            && \
            rm -rf /var/lib/apt/lists/*
            
RUN apt update -y \
    && apt install -y \
      xvfb \
      x11vnc

COPY docker_entrypoint /usr/local/bin/docker_entrypoint

ENTRYPOINT ["/usr/local/bin/docker_entrypoint"]
