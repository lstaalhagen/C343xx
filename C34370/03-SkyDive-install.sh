#!/bin/sh

# Check for root
[ $(id -u) -ne 0 ] && echo "Script must be executed with sudo" && exit

apt-get update
apt-get -y install at
curl -Lo - https://github.com/skydive-project/skydive-binaries/raw/jenkins-builds/skydive-latest.gz | gzip -d > skydive && chmod +x skydive && sudo mv skydive /usr/local/bin/
install -m 0755 skydivectl /usr/local/bin/skydivectl

# Cleanup apt-get
apt-get clean
