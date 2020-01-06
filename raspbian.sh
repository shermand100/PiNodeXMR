#!/bin/bash

##Open Sources:
# Web-UI by designmodo Flat-UI free project at https://github.com/designmodo/Flat-UI
# Monero github https://github.com/moneroexamples/monero-compilation/blob/master/README.md
# Monero Blockchain Explorer https://github.com/moneroexamples/onion-monero-blockchain-explorer
# PiNode-XMR scripts and custom files at my repo https://github.com/shermand100/pinode-xmr
###Begin
##User pinodexmr creation
echo -e "\e[32mStep 1: produce user 'pinodexmr'\e[0m" 
sleep 2
sudo adduser pinodexmr --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "pinodexmr:PiNodeXMR" | sudo chpasswd
echo -e "\e[32mUser 'pinodexmr' created and password 'PiNodeXMR' set\e[0m"
sleep 2


##Replace file /etc/sudoers to set global sudo permissions/rules
echo -e "\e[32mDownlaod and replace /etc/sudoers file\e[0m"
sleep 2
wget https://raw.githubusercontent.com/shermand100/pinode-xmr/master/etc/sudoers
sudo chmod 0440 /home/pi/sudoers
sudo chown root /home/pi/sudoers
sudo mv /home/pi/sudoers /etc/sudoers
echo -e "\e[32mGlobal permissions changed\e[0m"
sleep 1

##Change from user 'pi' to 'pinodexmr' and lock 'pi'
echo -e "\e[32mSwitching user to 'pinodexmr'\e[0m"
sleep 1
sudo su pinodexmr
cd
echo -e "\e[32mLock old user 'pi'\e[0m"
sleep 1
sudo passwd --lock pi
echo -e "\e[32mUser 'pi' Locked\e[0m"
sleep 1

##Update and Upgrade system
echo -e "\e[32mReceiving and applying Raspbian updates to latest versions\e[0m"
sleep 3
sudo apt update && sudo apt upgrade -y

##Installing dependencies for --- Web Interface
echo -e "\e[32mInstalling dependencies for --- Web Interface\e[0m"
sleep 3
sudo apt install apache2 shellinabox php7.3 php7.3-cli php7.3-common php7.3-curl php7.3-gd php7.3-json php7.3-mbstring php7.3-mysql php7.3-xml -y

##Update and Upgrade system (2nd time to prevent error in next dependency set install)
echo -e "\e[32mReceiving and applying Raspbian updates to latest versions\e[0m"
sleep 3
sudo apt update && sudo apt upgrade -y

##Installing dependencies for --- Monero
echo -e "\e[32mInstalling dependencies for --- Monero\e[0m"
sleep 3
sudo apt install git build-essential cmake libpython2.7-dev libboost-all-dev miniupnpc pkg-config libunbound-dev graphviz doxygen libunwind8-dev libssl-dev libcurl4-openssl-dev libgtest-dev libreadline-dev libzmq3-dev libsodium-dev libhidapi-dev libhidapi-libusb0 -y

##Installing dependencies for --- miscellaneous (tor+tor monitor-nyx, security tools-fail2ban-ufw, menu tool-dialog, screen, mariadb)
echo -e "\e[32mInstalling dependencies for --- Miscellaneous\e[0m"
sleep 3
sudo apt install mariadb-client-10.0 mariadb-server-10.0 screen exfat-fuse exfat-utils tor nyx fail2ban ufw  dialog -y

##Update and Upgrade dependencies (again)
echo -e "\e[32mReceiving and applying Raspbian updates to latest versions\e[0m"
sleep 3
sudo apt update && sudo apt upgrade -y

##Configure Swap file
echo -e "\e[32mConfiguring 2GB Swap file (required for Monero build)\e[0m"
sleep 3
sudo echo "CONF_SWAPSIZE=2000" > /etc/dphys-swapfile
sudo dphys-swapfile setup
sudo dphys-swapfile swapon

