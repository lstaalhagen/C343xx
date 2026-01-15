# C34370
Scripts and miscellaneous files for course 34370 Cloud Networking. To install relevant packages/SW and prepare the VM for the course, run the NN-XXX-install.sh scripts, *starting with 01-General-install.sh*.

**NOTE:** VirtualBox's Guest Additions should be installed *after* the software mentioned here. Otherwise, an error message pops up shortly after the VM has been started - the error *seems* to be benign but futher testing is probably required.

---
* General - Disables unnessesary OS-services and other general stuff. Run the install.sh in this directory first.
---
* Ansible - Installs the Ansible automation software.
* Docker - Installs Docker Engine (*not* Docker Desktop).
* Kubernetes - Installs minikube and kubectl.
* Mininet - Mininet
* OVS - Installs Open vSwitch from packages.
* SkyDive - Installs the SkyDive visualization of namespaces, etc.
