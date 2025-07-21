#!/bin/bash
##This file created following guidance from https://geti2p.net/en/download/debian#ubuntu
##Setup i2p dependencies
echo -e "\e[32mChecking \"apt-transport-https\" and \"curl\" are installed...\e[0m"
sleep 3
    sudo apt-get update
    sudo apt-get install apt-transport-https curl -y

##Setup update location for i2p updates via debian inc keys
echo -e "\e[32mInstalling I2P...\e[0m"
sleep 3	
sudo apt-add-repository ppa:i2p-maintainers/i2p -y
sudo apt-get update

##Setup Installing i2p
echo -e "\e[32mInstalling I2P...\e[0m"
sleep 3	
	sudo apt-get install i2p -y


##Setup Basic config of i2p
sudo dpkg-reconfigure i2p

sleep 2

i2prouter start

sleep 5
						
whiptail --title "PiNode-XMR I2P" --msgbox "I2P server has been installed and started\n\nYou now have access to the I2P config menu found at $(hostname -I | awk '{print $1}'):7657" 12 78



./setup.sh

