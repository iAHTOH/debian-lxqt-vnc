#!/usr/bin/expec
set SCREEN_RESOLUTION 1920x1080
catch {set SCREEN_RESOLUTION $env(resolution)}

spawn /usr/bin/vncserver :1 -fg -geometry $SCREEN_RESOLUTION

set timeout -1
expect eof
