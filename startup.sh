#!/bin/bash
spawn /usr/bin/vncserver :1 -fg -geometry 1920x1080
exec "$@"
