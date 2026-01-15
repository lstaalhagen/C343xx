#!/bin/sh

# Check for root
[ $(id -u) -ne 0 ] && echo "Script must be executed with sudo" && exit
REALUSER=${SUDO_USER}
[ -z "${REALUSER}" ] && echo "Environment variable $SUDO_USER not set as expected" && exit

# Get mininet
git clone https://github.com/mininet/mininet

# Install mininet
mininet/util/install.sh


