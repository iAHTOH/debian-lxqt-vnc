
FROM debian:stable-slim


LABEL maintainer="admin@iahtoh.ru" \
      io.k8s.description="Headless VNC Container with LXQt Desktop manager" \
      io.k8s.display-name="Headless VNC Container based on Debian" \
      io.openshift.expose-services="5901:xvnc" \
      io.openshift.tags="vnc, debian, lxqt" \
      io.openshift.non-scalable=true


ENV HOME=/home/headless


RUN         apt-get update && \
            apt-get install -y dbus-x11 sudo mc openbox\
            tigervnc-standalone-server tigervnc-common \
            lxqt-about lxqt-config lxqt-globalkeys lxqt-notificationd \
            lxqt-openssh-askpass lxqt-panel lxqt-policykit lxqt-qtplugin lxqt-runner \
            lxqt-theme-debian lxqt-branding-debian lxqt-session \
            featherpad nano qterminal synaptic \   
            && \
            apt-get clean \
            && \
            rm -rf /var/lib/apt/lists/*



RUN     /usr/bin/dbus-uuidgen --ensure && \
        useradd -m  -s /bin/bash headless && \
        echo "root:debian" | chpasswd && \
        echo "headless:debian" | chpasswd && \
        usermod -aG sudo headless
        

ADD     headless ${HOME}       
RUN     echo '#!/bin/sh' > ${HOME}/.vnc/xstartup && \
        echo 'exec startlxqt' >> ${HOME}/.vnc/xstartup && \
        chmod 775 ${HOME}/.vnc/xstartup \
        && \
        chown headless:headless -R ${HOME} 


#COPY    ./startup.sh ${HOME}

#RUN     mkdir -p ${HOME}/.vnc \
#        && \
#        echo '#!/bin/sh' > ${HOME}/.vnc/xstartup && \
#        echo 'exec startlxqt' >> ${HOME}/.vnc/xstartup && \
#        chmod 775 ${HOME}/.vnc/xstartup \
#        && \
#        chown headless:headless -R ${HOME}


WORKDIR ${HOME}
USER headless

#RUN     vncserver -localhost no

# apply plazma theme, wallpaper, qterimal and pcman to quicklaunch
#RUN mkdir -p ${HOME}/.config/lxqt && \
#        echo '[General]' >> ${HOME}/.config/lxqt/lxqt.conf && \
#        echo '__userfile__=true' >> ${HOME}/.config/lxqt/lxqt.conf && \
#        echo 'theme=ambiance' >> ${HOME}/.config/lxqt/lxqt.conf &&\
#        echo 'icon_theme=Papirus' >> ${HOME}/.config/lxqt/lxqt.conf 
#        && \
#        echo 'Xcursor.theme: breeze_cursors' >> ${HOME}/.Xdefaults \
#        && \
#        mkdir -p ${HOME}/.config/pcmanfm-qt/lxqt && \
#        echo '[Desktop]' >> ${HOME}/.config/pcmanfm-qt/lxqt/settings.conf && \
#        echo 'Wallpaper=/usr/share/lxqt/wallpapers/kde-plasma.png' >> ${HOME}/.config/pcmanfm-qt/lxqt/settings.conf && \
#        echo 'WallpaperMode=stretch' >> ${HOME}/.config/pcmanfm-qt/lxqt/settings.conf \
#        && \
#        mkdir -p ${HOME}/.config/lxqt/ && \
#        echo '[quicklaunch]' >> ${HOME}/.config/lxqt/panel.conf && \
#        echo 'apps\1\desktop=/usr/share/applications/qterminal.desktop' >> ${HOME}/.config/lxqt/panel.conf && \
#        echo 'apps\2\desktop=/usr/share/applications/pcmanfm-qt.desktop' >> ${HOME}/.config/lxqt/panel.conf && \
#        echo 'apps\size=3' >> ${HOME}/.config/lxqt/panel.conf



ENTRYPOINT ["bash"]
