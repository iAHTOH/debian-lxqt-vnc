
FROM x11docker/lxqt:latest

RUN apt-get update \
    && apt-get install -y x11vnc net-tools xvfb
