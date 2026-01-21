#!/usr/bin/env bash

# Check for root
[ $(id -u) -ne 0 ] && echo "Script must be executed with sudo" && exit 0
REALUSER=${SUDO_USER}
[ -z "${REALUSER}" ] && echo "Environment variable $SUDO_USER not set as expected" && exit

CURRDIR=$(pwd)

# Create a temporary installation directory and install Mininet-WiFi
TMPDIR=$(mktemp -d)
cd ${TMPDIR}
git clone https://github.com/lstaalhagen/mininet-wifi || { echo "Git clone failed - exiting" ; exit 1; }
cd mininet-wifi
util/install.sh -Wlnv
rm -rf ${TMPDIR}

cd ${CURRDIR}
mkdir -p /home/${REALUSER}/mininet-wifi
cp Files/mininet-wifi/skeleton.py /home/${REALUSER}/mininet-wifi
chown -R ${REALUSER}: /home/${REALUSER}/mininet-wifi
