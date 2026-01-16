#!/usr/bin/env bash

if [ -z "${BASH}" ] ; then
  echo "Error: Script must be exercuted with the Bash shell"
  exit 1
fi

source ../env

# Create a temporary installation directory and install Mininet-WiFi
TMPDIR=$(mktemp -d)
cd ${TMPDIR}
git clone https://github.com/lstaalhagen/mininet-wifi || { echo "Git clone failed - exiting" ; exit 1; }
cd mininet-wifi
util/install.sh -Wlnfv
rm -rf ${TMPDIR}

mkdir -p ${USERHOME}/mininet-wifi
cp Files/mininet-wifi/skeleton.py ${USERHOME}/mininet-wifi
chown -R ${REALUSER}: ${USERHOME}/mininet-wifi
