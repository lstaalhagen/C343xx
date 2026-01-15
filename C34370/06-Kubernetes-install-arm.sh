#!/bin/bash

# Check for root
[ $(id -u) -ne 0 ] && echo "Script must be executed with sudo" && exit

# Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_arm64.deb
dpkg -i minikube_latest_arm64.deb
rm -f minikube_latest_arm64.deb

# Kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl kubectl.sha256

# crictl
VERSION="v1.29.0" # check latest version in /releases page at https://github.com/kubernetes-sigs/cri-tools/releases
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-arm64.tar.gz
sudo tar zxvf crictl-$VERSION-linux-arm64.tar.gz -C /usr/local/bin
rm -f crictl-$VERSION-linux-arm64.tar.gz

# cri-dockerd
# Check latest at https://github.com/Mirantis/cri-dockerd/releases
wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.9/cri-dockerd-0.3.9.arm64.tgz
sudo tar zxvf cri-dockerd-0.3.9.arm64.tgz
mv cri-dockerd/cri-dockerd /usr/local/bin/
wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.service
wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.socket
sudo mv cri-docker.socket cri-docker.service /etc/systemd/system/
sudo sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
sudo systemctl daemon-reload
sudo systemctl enable cri-docker.service
sudo systemctl enable --now cri-docker.socket
rm -f cri-dockerd-0.3.9.arm64.tgz

# container-networking
# Check latest at https://github.com/containernetworking/plugins/releases
CNI_PLUGIN_VERSION="v1.4.0"
CNI_PLUGIN_TAR="cni-plugins-linux-arm64-$CNI_PLUGIN_VERSION.tgz" # change arch if not on amd64
CNI_PLUGIN_INSTALL_DIR="/opt/cni/bin"
curl -LO "https://github.com/containernetworking/plugins/releases/download/$CNI_PLUGIN_VERSION/$CNI_PLUGIN_TAR"
sudo mkdir -p "$CNI_PLUGIN_INSTALL_DIR"
sudo tar -xf "$CNI_PLUGIN_TAR" -C "$CNI_PLUGIN_INSTALL_DIR"
rm "$CNI_PLUGIN_TAR"

# Misc
SYSCTLCNF="/etc/sysctl.conf"
grep -q -e "fs.protected_regular=" $SYSCTLCNF
if [ $? -eq 0 ]
then
   sed -i 's/fs.protected_regular=.*/fs.protected_regular=0/g' $SYSCTLCNF
else
   echo "fs.protected_regular=0" >> $SYSCTLCNF
fi
sysctl -p

echo "Please run 'sudo minikube start --driver=none' at least once before distributing the VM"
