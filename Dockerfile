
FROM debian:stable-slim


LABEL maintainer="admin@iahtoh.ru" \
      io.k8s.description="Headless VNC Container with LXQt Desktop manager" \
      io.k8s.display-name="Headless VNC Container based on Debian" \
      io.openshift.expose-services="5901:xvnc" \
      io.openshift.tags="vnc, debian, lxqt" \
      io.openshift.non-scalable=true


ENV HOME=/home/headless


RUN         apt-get update &&\
            apt-get install -y\
            tigervnc-standalone-server \
            tigervnc-common \
            openbox obconf-qt \
            lxqt-about lxqt-config lxqt-globalkeys lxqt-notificationd \
            lxqt-openssh-askpass lxqt-panel lxqt-policykit lxqt-qtplugin lxqt-runner \
            lxqt-session \
            #dejavu-sans-mono-fonts \
            pcmanfm-qt \
            dbus-x11 xorg \
            xterm nano htop expect sudo \
            passwd binutils wget \
        && \
        strip --remove-section=.note.ABI-tag /usr/lib/x86_64-linux-gnu/libQt5Core.so.5 \
        && \
        apt-get clean \
        && \
        rm -rf /var/cache/dnf/*



RUN /usr/bin/dbus-uuidgen --ensure && \
        useradd -m headless && \
        #addgroup wheel && \
        echo "root:debian" | chpasswd && \
        echo "headless:debian" | chpasswd && \
        usermod -aG sudo headless


COPY ./startup.sh ${HOME}

RUN mkdir -p ${HOME}/.vnc \
        && \
        echo '#!/bin/sh' > ${HOME}/.vnc/xstartup && \
        echo 'exec startlxqt' >> ${HOME}/.vnc/xstartup && \
        chmod 775 ${HOME}/.vnc/xstartup \
        && \
        chown headless:headless -R ${HOME}


WORKDIR ${HOME}
USER headless


# apply plazma theme, wallpaper, qterimal and pcman to quicklaunch
RUN mkdir -p ${HOME}/.config/lxqt && \
        echo '[General]' >> ${HOME}/.config/lxqt/lxqt.conf && \
        echo 'theme=KDE-Plasma' >> ${HOME}/.config/lxqt/lxqt.conf \
        && \
        echo 'Xcursor.theme: breeze_cursors' >> ${HOME}/.Xdefaults \
        && \
        mkdir -p ${HOME}/.config/pcmanfm-qt/lxqt && \
        echo '[Desktop]' >> ${HOME}/.config/pcmanfm-qt/lxqt/settings.conf && \
        echo 'Wallpaper=/usr/share/lxqt/wallpapers/kde-plasma.png' >> ${HOME}/.config/pcmanfm-qt/lxqt/settings.conf && \
        echo 'WallpaperMode=stretch' >> ${HOME}/.config/pcmanfm-qt/lxqt/settings.conf \
        && \
        mkdir -p ${HOME}/.config/lxqt/ && \
        echo '[quicklaunch]' >> ${HOME}/.config/lxqt/panel.conf && \
        echo 'apps\1\desktop=/usr/share/applications/qterminal.desktop' >> ${HOME}/.config/lxqt/panel.conf && \
        echo 'apps\2\desktop=/usr/share/applications/pcmanfm-qt.desktop' >> ${HOME}/.config/lxqt/panel.conf && \
        echo 'apps\size=3' >> ${HOME}/.config/lxqt/panel.conf


ENTRYPOINT ["expect", "./startup.sh"]
