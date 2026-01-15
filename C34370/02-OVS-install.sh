#!/bin/sh

# Check for root
[ $(id -u) -ne 0 ] && echo "Script must be executed with sudo" && exit

apt-get -y install openvswitch-common openvswitch-switch openvswitch-switch-dpdk openvswitch-doc python3-openvswitch

# Cleanup apt-get
apt-get clean

