#!/usr/bin/env bash

[ $(id -u) -ne 0 ] && echo "Script must be executed with sudo" && exit 1

apt update
apt -y upgrade

# Downgrade to allow install of -dev, -venv, -pip
# apt -y install python3=3.10.6-1~22.04 python3-minimal=3.10.6-1~22.04 libpython3-stdlib=3.10.6-1~22.04
apt -y install python3-dev python3-venv python3-pip

apt -y install pkg-config libssl-dev libdbus-1-dev libglib2.0-dev libavahi-client-dev \
            ninja-build libgirepository1.0-dev libcairo2-dev libreadline-dev
