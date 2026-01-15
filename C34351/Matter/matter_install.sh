#!/usr/bin/env bash

[ $(id -u) -eq 0 ] && echo "Script must be executed as regular user" && exit 1

USERNAME=$(who am i|cut -d ' ' -f 1)
HOMEDIR=$(eval echo "~$USERNAME")

cd $HOMEDIR
mkdir -p matter
cd matter
rm -rf connectedhomeip

git clone https://github.com/project-chip/connectedhomeip.git
if [ $? -ne 0 ] ; then
  echo "Git clone failed"
  exit 1
fi

cd connectedhomeip
./scripts/checkout_submodules.py --allow-changing-global-git-config --shallow --platform linux

source scripts/bootstrap.sh
source scripts/activate.sh

gn gen out/debug --args='chip_mdns="platform" chip_inet_config_enable_ipv4=false'
ninja -C out/debug

./scripts/build/build_examples.py \
  --target linux-x64-all-clusters-ipv6only \
  --target linux-x64-chip-tool-ipv6only \
  build \
  && mv out/linux-x64-all-clusters-ipv6only/chip-all-clusters-app out/chip-all-clusters-app \
  && mv out/linux-x64-chip-tool-ipv6only/chip-tool out/chip-tool 