#!/usr/bin/env bash

# Check for root 
[ $(id -u) -ne 0 ] && echo "Script must be executed with sudo" && exit
REALUSER=${SUDO_USER}
[ -z "${REALUSER}" ] && echo "Environment variable $SUDO_USER not set as expected" && exit
HOMEDIR=$(eval echo "~$REALUSER")

NONINTERACTIVE="NO"
if [ "${1}" = "-q" ] ; then
  NONINTERACTIVE="YES"
fi

apt update

#
# Skydive tool
#
###############################################################################
INST="NO"
if [ "${NONINTERACTIVE}" = "NO" ] ; then
  echo "Install Skydive: "
  read -n 1 KEY
  if [ "${KEY}" = "y" ] || [ "${KEY}" = "Y" ] ; then
    INST="YES"
  fi
fi
if [ "${NONINTERACTIVE}" = "YES" ] || [ "${INST}" = "YES" ] ; then
  curl -Lo - https://github.com/skydive-project/skydive-binaries/raw/jenkins-builds/skydive-latest.gz | gzip -d > skydive && chmod +x skydive && sudo mv skydive /usr/local/bin/
  install -m 0755 skydivectl /usr/local/bin/skydivectl  
fi
###############################################################################

#
# mininet
#
###############################################################################
# git clone https://github.com/mininet/mininet
# mininet/util/install.sh
INST="NO"
if [ "${NONINTERACTIVE}" = "NO" ] ; then
  echo "Install mininet: "
  read -n 1 KEY
  if [ "${KEY}" = "y" ] || [ "${KEY}" = "Y" ] ; then
    INST="YES"
  fi
fi
if [ "${NONINTERACTIVE}" = "YES" ] || [ "${INST}" = "YES" ] ; then
  apt install mininet
fi
#############################################################################

#
# Docker
#
###############################################################################
INST="NO"
if [ "${NONINTERACTIVE}" = "NO" ] ; then
  echo "Install Docker: "
  read -n 1 KEY
  if [ "${KEY}" = "y" ] || [ "${KEY}" = "Y" ] ; then
    INST="YES"
  fi
fi
if [ "${NONINTERACTIVE}" = "YES" ] || [ "${INST}" = "YES" ] ; then
  for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc ; do 
    apt-get remove $pkg
  done
  apt-get install -y ca-certificates curl gnupg
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc

  # Change $UBUNTU_CODENAME to $VERSION_CODENAME if a real Ubuntu distribution is used
  sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF
  apt update
  
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi
###############################################################################

#
#  Minikube
#
###############################################################################
if [ "${INTERACTIVE}" = "YES" ] ; then
  echo "Minikube: "
  read -n 1 key
fi

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
dpkg -i minikube_latest_amd64.deb
rm -f minikube_latest_amd64.deb

# Kubectl (MAY NOT BE NEEDED FOR MINIKUBE IF "alias kubectl='sudo minikube kubectl --'" IS USED - MUST BE CHECKED!)
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl kubectl.sha256

# crictl
VERSION="v1.29.0" # check latest version in /releases page at https://github.com/kubernetes-sigs/cri-tools/releases
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz
sudo tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin
rm -f crictl-$VERSION-linux-amd64.tar.gz

# cri-dockerd
# Check latest at https://github.com/Mirantis/cri-dockerd/releases
wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.9/cri-dockerd_0.3.9.3-0.ubuntu-jammy_amd64.deb
dpkg -i cri-dockerd_0.3.9.3-0.ubuntu-jammy_amd64.deb
rm -f cri-dockerd_0.3.9.3-0.ubuntu-jammy_amd64.deb

# container-networking
# Check latest at https://github.com/containernetworking/plugins/releases
CNI_PLUGIN_VERSION="v1.4.0"
CNI_PLUGIN_TAR="cni-plugins-linux-amd64-$CNI_PLUGIN_VERSION.tgz" # change arch if not on amd64
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
# echo "Please run 'sudo minikube start --driver=none' at least once before distributing the VM"
###############################################################################

#
# Ansible
#
###############################################################################
if [ "${INTERACTIVE}" = "YES" ] ; then
  echo "Ansible: "
  read -n 1 key
fi
apt-add-repository -y ppa:ansible/ansible
apt-get update
apt-get install -y ansible

if [ -f Playbooks/playbooks.zip ] ; then
  # Fix path
  sudo -u ${REALUSER} unzip -d /home/${REALUSER}/Playbooks Playbooks/playbooks.zip
fi  
###############################################################################

# Clean up for apt
apt-get clean
