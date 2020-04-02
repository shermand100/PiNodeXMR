#!/bin/bash

##Open Sources:
# Web-UI by designmodo Flat-UI free project at https://github.com/designmodo/Flat-UI
# Monero github https://github.com/moneroexamples/monero-compilation/blob/master/README.md
# Monero Blockchain Explorer https://github.com/moneroexamples/onion-monero-blockchain-explorer
# PiNode-XMR scripts and custom files at my repo https://github.com/shermand100/pinode-xmr
# PiVPN - OpenVPN server setup https://github.com/pivpn/pivpn

##Replace file /etc/sudoers to set global sudo permissions/rules
echo -e "\e[32mDownload and replace /etc/sudoers file\e[0m"
sleep 3
wget https://raw.githubusercontent.com/shermand100/pinode-xmr/Armbian-install/etc/sudoers
sudo chmod 0440 /home/pinodexmr/sudoers
sudo chown root /home/pinodexmr/sudoers
sudo mv /home/pinodexmr/sudoers /etc/sudoers
echo -e "\e[32mGlobal permissions changed\e[0m"
sleep 3

##Change system hostname to PiNodeXMR
echo -e "\e[32mChanging system hostname to 'PiNodeXMR'\e[0m"
sleep 3
echo 'PiNodeXMR' | sudo tee /etc/hostname
#sudo sed -i '6d' /etc/hosts
echo '127.0.0.1       PiNodeXMR' | sudo tee -a /etc/hosts
sudo hostname PiNodeXMR

