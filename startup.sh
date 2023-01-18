#!/bin/bash
vncserver -localhost no
exec "$@"
