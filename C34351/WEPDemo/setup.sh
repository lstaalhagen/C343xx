#!/usr/bin/env bash

[ $(id -u) -ne 0 ] && echo "Script must be executed with sudo" && exit 1

if [ $# -lt 1 ] ; then
  echo "Usage: Call this script with either '-c' or '-s' for the client or the server, respectively"
  exit 1
fi

apt update
apt -y upgrade

apt -y install iperf tcpdump

if [ "${1}" = "-c" ] ; then
  install iperfclient.sh /usr/local/bin
  install -m 0644 iperfclient.service /lib/systemd/system
  systemctl enable iperfclient.service
  install -m 0644 iperfclientserver.conf /etc
elif [ "${1}" = "-s" ] ; then
  install iperfserver.sh /usr/local/bin
  install -m 0644 iperfserver.service /lib/systemd/system
  systemctl enable iperfserver.service
  install -m 0644 iperfclientserver.conf /etc
else 
  echo "Unknown option: ${1}"
  exit 1
fi

exit 0
