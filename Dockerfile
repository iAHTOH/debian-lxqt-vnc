
FROM debian:stable-slim


LABEL maintainer="admin@iahtoh.ru" \
      io.k8s.description="Headless VNC Container with LXQt Desktop manager" \
      io.k8s.display-name="Headless VNC Container based on Debian" \
      io.openshift.expose-services="5901:xvnc" \
      io.openshift.tags="vnc, debian, lxqt" \
      io.openshift.non-scalable=true


ENV HOME=/home/headless


RUN         apt-get update && \
            apt-get install -y --no-install-recommends --allow-unauthenticated \
            sudo mc net-tools openbox \
            dbus-x11 x11-utils alsa-utils mesa-utils libgl1-mesa-dri\              
            && apt autoclean -y \
            && apt autoremove -y \
            && rm -rf /var/lib/apt/lists/*

RUN         apt update \
            && apt install -y --no-install-recommends --allow-unauthenticated \
            xvfb x11vnc \            
            && apt autoclean -y \
            && apt autoremove -y \
            && rm -rf /var/lib/apt/lists/* 
           
RUN         apt update \
            && apt install -y --no-install-recommends --allow-unauthenticated \
            lxqt-about lxqt-config lxqt-globalkeys lxqt-notificationd \
            lxqt-openssh-askpass lxqt-panel lxqt-policykit lxqt-qtplugin lxqt-runner \
            lxqt-theme-debian lxqt-branding-debian lxqt-session \
            featherpad spawn-fcgi nano qterminal synaptic \ 
            && apt autoclean -y \
            && apt autoremove -y \
            && rm -rf /var/lib/apt/lists/*


RUN         /usr/bin/dbus-uuidgen --ensure && \
            useradd -m  -s /bin/bash headless && \
            echo "root:debian" | chpasswd && \
            echo "headless:debian" | chpasswd && \
            usermod -aG sudo headless

       


ADD     headless ${HOME} 
#COPY    ./startup.sh ${HOME}  
RUN chmod -c a+rX ${HOME}/startup.sh
RUN chmod +x ${HOME}/startup.sh
ENTRYPOINT ["/home/headless/startup.sh"]


      
RUN     echo '#!/bin/sh' > ${HOME}/.vnc/xstartup && \
        echo 'exec startlxqt' >> ${HOME}/.vnc/xstartup && \
        chmod 775 ${HOME}/.vnc/xstartup \
        && \
        chmod 700 ${HOME}/.vnc/passwd \        
        && \
        chown headless:headless -R ${HOME} 

WORKDIR ${HOME}
USER headless

#RUN     vncserver -localhost no

