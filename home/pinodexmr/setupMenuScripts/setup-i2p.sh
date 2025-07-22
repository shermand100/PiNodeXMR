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

###Make web console accessable on lan

	##Set Device IP variable
	cd
	. ~/variables/deviceIp.sh

	##add lan ip to config (default blocks lan access to web client)
	#This allows access from ip e.g.: 192.168.1.116:7657
	sed -i "/clientApp.0.args*/c\clientApp.0.args=7657 ::1,127.0.0.1,"${DEVICE_IP}" ./webapps/" /home/pinodexmr/.i2p/clients.config.d/00-net.i2p.router.web.RouterConsoleRunner-clients.config
	#This allows access from hostname e.g: http://pinodexmr.local:7657
	echo "routerconsole.allowedHosts=pinodexmr.local" >> /home/pinodexmr/.i2p/router.config

sleep 2 
    ##Apply changes
    i2prouter restart


whiptail --title "PiNode-XMR I2P" --msgbox "I2P server has been installed and started\n\nYou now have access to the I2P config menu found at $(hostname -I | awk '{print $1}'):7657" 12 78



./setup.sh

