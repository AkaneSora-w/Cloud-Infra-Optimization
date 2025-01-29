#!/bin/bash

# Packages update

export DEBIAN_FRONTEND=noninteractive

apt-get -y update
apt-get -y upgrade

# Download openvpn-install.sh

curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
chmod +x openvpn-install.sh
export AUTO_INSTALL=y
./openvpn-install.sh
