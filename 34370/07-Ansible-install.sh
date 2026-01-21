#!/bin/sh

# Check for root
[ $(id -u) -ne 0 ] && echo "Script must be executed with sudo" && exit
REALUSER=${SUDO_USER}
[ -z "${REALUSER}" ] && echo "Environment variable $SUDO_USER not set as expected" && exit

apt-add-repository -y ppa:ansible/ansible
apt-get update
apt-get install -y ansible

# Cleanup apt-get
apt-get clean

if [ -f Playbooks/playbooks.zip ] ; then
  sudo -u ${REALUSER} unzip -d /home/${REALUSER}/Playbooks Playbooks/playbooks.zip
fi  
