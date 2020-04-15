#!/bin/bash
##This file created following guidance from https://geti2p.net/en/download/debian#debian
##Setup i2p dependencies
echo -e "\e[32mChecking \"apt-transport-https\" and \"curl\" are installed...\e[0m"
sleep 3
    sudo apt-get update
    sudo apt-get install apt-transport-https curl -y

##Setup update location for i2p updates via debian inc keys
echo -e "\e[32mInstalling I2P...\e[0m"
sleep 3	
wget https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/Development-Raspbian/etc/apt/sources.list.d/i2p.list
sleep 1
sudo mv ~/i2p.list /etc/apt/sources.list.d/
sudo chmod 644 /etc/apt/sources.list.d/i2p.list
sudo chown root /etc/apt/sources.list.d/i2p.list
curl -o i2p-debian-repo.key.asc https://geti2p.net/_static/i2p-debian-repo.key.asc
gpg -n --import --import-options import-show i2p-debian-repo.key.asc
sudo apt-key add i2p-debian-repo.key.asc
sudo apt-get update

##Setup Installing i2p
echo -e "\e[32mInstalling I2P...\e[0m"
sleep 3	
	sudo apt-get install i2p i2p-keyring -y

##Setup Basic config of i2p
sudo dpkg-reconfigure i2p

if (whiptail --title "PiNode-XMR Start I2P?" --yesno "I2P installer script has finished.\n\nWould you like to start I2P now?" 14 78); then
									i2prouter start
									whiptail --title "PiNode-XMR I2P" --msgbox "I2P server has been started\n\nYou now have access to the I2P config menu found at $(hostname -I | awk '{print $1}'):7657" 12 78
									else
									. /home/pinodexmr/setup.sh
									fi
./setup.sh
