#!/usr/bin/env bash

# Check for root
[ $(id -u) -ne 0 ] && echo "Script must be executed with sudo" && exit 0
REALUSER=${SUDO_USER}
[ -z "${REALUSER}" ] && echo "Environment variable $SUDO_USER not set as expected" && exit 1

apt-get update
apt-get -y upgrade
apt-get -y autoremove

# Miscellaneous other packages
apt-get -y install build-essential conntrack conntrackd xterm curl \
           net-tools ssh gcc-12 bridge-utils jq nmap at gnupg ca-certificates \
           openvswitch-common openvswitch-switch openvswitch-switch-dpdk openvswitch-doc python3-openvswitch \
		   doxygen autoconf libtool libssl-dev htop dos2unix
		   
DEBIAN_FRONTEND=noninteractive apt-get -yq install wireshark		   

# Cleanup apt-get
apt-get clean

# Stop/disable some irrelevant services
if [ -s Files/disablelist ] ; then
  for p in $(cat Files/disablelist) ; do
    systemctl stop ${p}
	systemctl disable ${p}
    systemctl mask ${p}
  done
fi

# Fix Grub
sed -i 's/GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=menu/g' /etc/default/grub
sed -i 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=2/g' /etc/default/grub
update-grub

# Hack to get a better default font size in Xterm windows
XRESOURCES=/home/${REALUSER}/.Xresources
if [ -s $XRESOURCES ]; then
  grep -q -e "^xterm\*faceName:" $XRESOURCES
  if [ $? -ne 0 ]; then
    echo "xterm*faceName: Monospace" >> $XRESOURCES
    echo "xterm*faceSize: 12" >> $XRESOURCES
  else
    sed -i 's/xterm\*faceName:.*/xterm\*faceName: Monospace/g' $XRESOURCES
    sed -i 's/xterm\*faceSize:.*/xterm\*faceSize: 12/g' $XRESOURCES
  fi
else
  echo "xterm*faceName: Monospace" > $XRESOURCES
  echo "xterm*faceSize: 12" >> $XRESOURCES
fi
chown ${REALUSER}: $XRESOURCES
sudo -u ${REALUSER} xrdb -merge $XRESOURCES

