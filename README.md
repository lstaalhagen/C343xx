# C343xx
Repository for setting up virtual machines for courses 34351 and 34370.

## Prerequisite
A running VM running Xubuntu 24.04-4 LTS. Other distros may be applicable but may require modifications to scripts, etc.

## Instructions
Start terminal and change to root: `sudo -i`. Install the git program (if not already installed): `apt update; apt -y install git`. Clone this repository: `git clone https://www.github.com/lstaalhagen/C343xx.git`. Change directory to the root of the repository: `cd C343xx`. Execute script 01-general.sh with the command (as root): `./01-general.sh`

Next, depending on the course, change directory to either the 34351 subdirectory (`cd 34351`) or the 34370 subdirectory (`cd 34370`) and execute the scripts in there, e.g., `./02-xxx.sh`, `./03-xxx.sh`, etc.
