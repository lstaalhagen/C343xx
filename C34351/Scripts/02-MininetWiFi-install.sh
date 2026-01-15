#!/usr/bin/env bash

# Check for root 
[ $(id -u) -ne 0 ] && echo "Script must be executed with sudo" && exit 1
REALUSER=${SUDO_USER}
[ -z "${REALUSER}" ] && echo "Environment variable $SUDO_USER not set as expected" && exit 1
HOMEDIR=$(eval echo "~$REALUSER")

# Hack for libssl3 version confusion (NEEDS FIXING FOR FUTURE INSTALLS)
apt-get install -y --allow-downgrades libssl3=3.0.2-0ubuntu1.12
apt-get clean

# Create an installation directory and install Mininet-WiFi
TMPDIR=$(mktemp -d)
cd ${TMPDIR}
git clone https://github.com/intrig-unicamp/mininet-wifi || { echo "Git clone failed - exiting" ; exit 1; }
cd mininet-wifi
util/install.sh -Wlnfv
cd $HOMEDIR
rm -rf ${TMPDIR}

sudo -u ${REALUSER} -D ${HOMEDIR} mkdir -p mininet-wifi
sudo -u ${REALUSER} -D ${HOMEDIR} cp ../MininetWiFi-exercise/skeleton.py mininet-wifi



