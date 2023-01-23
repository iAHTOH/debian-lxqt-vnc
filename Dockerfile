
FROM x11docker/lxqt:latest

RUN apt update -y \
    && apt install -y \
      xvfb \
      x11vnc

COPY docker_entrypoint /usr/local/bin/docker_entrypoint

ENTRYPOINT ["/usr/local/bin/docker_entrypoint"]
