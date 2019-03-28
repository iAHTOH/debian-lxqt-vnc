# Docker image with headless VNC environments

This repository contains a Docker image with headless VNC environments.

description in progress...


![Docker VNC Desktop access via TightVNC Client](.pics/vnc_container_view.png)


### Try
```sh
docker run -e password="YOUR_VNC_PASSWORD" -it --rm -p5901:5901 labeg/centos-lxqt-vnc
```

### For setup root and users password
For using root user you must setup password for him, for make it launch command
```sh
docker exec -u 0 -it CONTAINER_ID bash
```

Enter 'passwd root' and set password for user root.

### Build
```sh
docker build -t labeg/centos-lxqt-vnc .
```