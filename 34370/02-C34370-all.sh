#!/usr/bin/env bash

# Check for root 
[ $(id -u) -ne 0 ] && echo "Script must be executed with sudo" && exit
REALUSER=${SUDO_USER}
[ -z "${REALUSER}" ] && echo "Environment variable $SUDO_USER not set as expected" && exit
HOMEDIR=$(eval echo "~$REALUSER")

# Install skydive tool
curl -Lo - https://github.com/skydive-project/skydive-binaries/raw/jenkins-builds/skydive-latest.gz | gzip -d > skydive && chmod +x skydive && sudo mv skydive /usr/local/bin/
install -m 0755 skydivectl /usr/local/bin/skydivectl

# Get and install mininet
git clone https://github.com/mininet/mininet
mininet/util/install.sh
