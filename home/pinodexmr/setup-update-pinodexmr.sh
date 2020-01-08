#!/bin/bash

wget -q https://raw.githubusercontent.com/shermand100/pinode-xmr/master/new-ver-pi.sh -O /home/pinodexmr/new-ver-pi.sh
echo "Version Info file recieved:"
#Permission Setting
chmod 755 /home/pinodexmr/current-ver-pi.sh
chmod 755 /home/pinodexmr/new-ver-pi.sh
#Load Variables
. /home/pinodexmr/current-ver-pi.sh
. /home/pinodexmr/new-ver-pi.sh
. /home/pinodexmr/strip.sh
echo $NEW_VERSION_PI 'New Version'
echo $CURRENT_VERSION_PI 'Current Version'
sleep "3"
	if [ $CURRENT_VERSION_PI -lt $NEW_VERSION_PI ]
		then
		echo -e "\e[32mNew PiNode-XMR version available...Proceeding with download\e[0m"
		sleep 3
		sudo systemctl stop monerod-start.service
		sudo systemctl stop monerod-start-mining.service
		sudo systemctl stop monerod-start-tor.service
		sudo systemctl stop monerod-start-public.service
		sudo systemctl stop explorer-start.service
		echo "Monerod and Blockchain explorer stop commands sent, allowing 30 seconds for safe shutdown"
		sleep "30"
		
		##Replace file /etc/sudoers to set global sudo permissions/rules
		echo -e "\e[32mDownload and replace /etc/sudoers file\e[0m"
		sleep 2
		wget https://raw.githubusercontent.com/shermand100/pinode-xmr/development/etc/sudoers
		sudo chmod 0440 /home/pi/sudoers
		sudo chown root /home/pi/sudoers
		sudo mv /home/pi/sudoers /etc/sudoers
		echo -e "\e[32mGlobal permissions changed\e[0m"
		sleep 3
		
		##Update and Upgrade system
		echo -e "\e[32mReceiving and applying Raspbian updates to latest versions\e[0m"
		sleep 3
		sudo apt update && sudo apt upgrade -y
		
		##Clone New PiNode-XMR to device from git
		echo -e "\e[32mDownloading New PiNode-XMR files\e[0m"
		sleep 3
		git clone -b development --single-branch https://github.com/shermand100/pinode-xmr.git
		
		##Adding New PiNode-XMR systemd services (if any)
		echo -e "\e[32mAdd PiNode-XMR systemd services\e[0m"
		sleep 3
		sudo mv /home/pinodexmr/pinode-xmr/etc/systemd/system/*.service /etc/systemd/system/
		sudo chmod 644 /etc/systemd/system/*.service
		sudo chown root /etc/systemd/system/*.service
		echo -e "\e[32mSuccess\e[0m"
		sleep 3
		
		##Setup New tor config files (if any)
		echo -e "\e[32mSetup tor hidden service and monitor file\e[0m"
		sleep 3
		sudo mv /home/pinodexmr/pinode-xmr/etc/tor/torrc /etc/tor/torrc
		sudo chmod 644 /etc/tor/torrc
		sudo chown root /etc/tor/torrc
		echo -e "\e[32mSuccess\e[0m"
		sleep 3
		
		##Copy PiNode-XMR scripts to home folder
		echo -e "\e[32mMoving PiNode-XMR scripts into possition\e[0m"
		sleep 3
		mv /home/pinodexmr/pinode-xmr/home/pinodexmr/* /home/pinodexmr/
		mv /home/pinodexmr/pinode-xmr/home/pinodexmr/.profile /home/pinodexmr/
		chmod 755 /home/pinodexmr/*
		echo -e "\e[32mSuccess\e[0m"
		sleep 3
		
		##Update Web-UI
		echo -e "\e[32mDownloading Web-UI template\e[0m"
		sleep 3
		git clone https://github.com/designmodo/Flat-UI.git
		echo -e "\e[32mInstalling Web-UI template\e[0m"
		sleep 3
		sudo mv /home/pinodexmr/Flat-UI/app/ /var/www/html/
		sudo mv /home/pinodexmr/Flat-UI/dist/ /var/www/html/
		echo -e "\e[32mConfiguring Web-UI template\e[0m"
		sleep 3
		sudo mv /home/pinodexmr/pinode-xmr/HTML/*.* /var/www/html/
		sudo cp -R /home/pinodexmr/pinode-xmr/HTML/docs/ /var/www/html/
		sudo chown www-data -R /var/www/html/
		sudo chmod 755 -R /var/www/html/
		
		## Remove left over files from git clone actions
		echo -e "\e[32mCleanup leftover directories\e[0m"
		sleep 3
		sudo rm -r /home/pinodexmr/Flat-UI/
		sudo rm -r /home/pinodexmr/pinode-xmr/
		
		
		
./setup.sh
