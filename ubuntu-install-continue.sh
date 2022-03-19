#!/bin/bash

##Open Sources:
# Monero github https://github.com/moneroexamples/monero-compilation/blob/master/README.md
# Monero Blockchain Explorer https://github.com/moneroexamples/onion-monero-blockchain-explorer
# PiNode-XMR scripts and custom files at my repo https://github.com/monero-ecosystem/PiNode-XMR
# PiVPN - OpenVPN server setup https://github.com/pivpn/pivpn

###Begin2

#Create debug file for handling install errors:
touch debug.log
echo "
####################
" >>debug.log
echo "Start raspbian-pinodexmr.sh script $(date)" >>debug.log
echo "
####################
" >>debug.log

whiptail --title "PiNode-XMR Continue Ubuntu Buster (oldstable) Installer" --msgbox "Your PiNode-XMR is taking shape...\n\nThis next part will take several hours dependant on your hardware but I won't require any further input from you. I can be left to install myself if you wish\n\nSelect ok to continue setup" 16 60
###Continue as 'pinodexmr'

##Configure temporary Swap file if needed (swap created is not persistant and only for compiling monero. It will unmount on reboot)
if (whiptail --title "PiNode-XMR Ubuntu Installer" --yesno "For Monero to compile successfully 2GB of RAM is required.\n\nIf your device does not have 2GB RAM it can be artificially created with a swap file\n\nDo you have 2GB RAM on this device?\n\n* YES\n* NO - I do not have 2GB RAM (create a swap file)" 18 60); then
	echo -e "\e[32mSwap file unchanged\e[0m"
	sleep 3
		else
			sudo fallocate -l 2G /swapfile 2> >(tee -a debug.log >&2)
			sudo chmod 600 /swapfile 2> >(tee -a debug.log >&2)
			sudo mkswap /swapfile 2> >(tee -a debug.log >&2)
			sudo swapon /swapfile 2> >(tee -a debug.log >&2)
			echo -e "\e[32mSwap file of 2GB Configured and enabled\e[0m"
			free -h
			sleep 3
fi

##Update and Upgrade system
echo -e "\e[32mReceiving and applying Ubuntu updates to latest versions\e[0m"
sleep 3
sudo apt update 2> >(tee -a debug.log >&2) && sudo apt upgrade -y 2> >(tee -a debug.log >&2)

##Installing dependencies for --- Web Interface
	echo "Installing dependencies for --- Web Interface" >>debug.log
echo -e "\e[32mInstalling dependencies for --- Web Interface\e[0m"
sleep 3
sudo apt install apache2 shellinabox php php-common avahi-daemon -y 2> >(tee -a debug.log >&2)
sleep 3

##Installing dependencies for --- Monero
	echo "Installing dependencies for --- Monero" >>debug.log
echo -e "\e[32mInstalling dependencies for --- Monero\e[0m"
sleep 3
sudo apt update && sudo apt install build-essential cmake pkg-config libssl-dev libzmq3-dev libunbound-dev libsodium-dev libunwind8-dev liblzma-dev libreadline6-dev libldns-dev libexpat1-dev libpgm-dev qttools5-dev-tools libhidapi-dev libusb-1.0-0-dev libprotobuf-dev protobuf-compiler libudev-dev libboost-chrono-dev libboost-date-time-dev libboost-filesystem-dev libboost-locale-dev libboost-program-options-dev libboost-regex-dev libboost-serialization-dev libboost-system-dev libboost-thread-dev ccache doxygen graphviz -y 2> >(tee -a debug.log >&2)
sleep 2
	echo "manual build of gtest for --- Monero" >>debug.log
sudo apt-get install libgtest-dev 2> >(tee -a debug.log >&2) && cd /usr/src/gtest 2> >(tee -a debug.log >&2) && sudo cmake . 2> >(tee -a debug.log >&2) && sudo make 2> >(tee -a debug.log >&2)
sudo mv lib/libg* /usr/lib/ 2> >(tee -a debug.log >&2)

##Checking all dependencies are installed for --- miscellaneous (security tools-fail2ban-ufw, menu tool-dialog, screen, mariadb)
	echo "Installing dependencies for --- miscellaneous" >>debug.log
echo -e "\e[32mChecking all dependencies are installed for --- Miscellaneous\e[0m"
sleep 3
sudo apt install git mariadb-client mariadb-server screen exfat-fuse exfat-utils fail2ban ufw dialog jq libcurl4-openssl-dev -y 2> >(tee -a debug.log >&2)
#libcurl4-openssl-dev for block-explorer
sleep 3

##Clone PiNode-XMR to device from git
	echo "Clone PiNode-XMR to device from git" >>debug.log
echo -e "\e[32mDownloading PiNode-XMR files\e[0m"
sleep 3
git clone -b ubuntuServer-20.04 --single-branch https://github.com/monero-ecosystem/PiNode-XMR.git 2> >(tee -a debug.log >&2)


##Configure ssh security. Allows only user 'pinodexmr'. Also 'root' login disabled via ssh, restarts config to make changes
	echo "Configure ssh security" >>debug.log
echo -e "\e[32mConfiguring SSH security\e[0m"
sleep 3
sudo mv /home/pinodexmr/PiNode-XMR/etc/ssh/sshd_config /etc/ssh/sshd_config 2> >(tee -a debug.log >&2)
sudo chmod 644 /etc/ssh/sshd_config 2> >(tee -a debug.log >&2)
sudo chown root /etc/ssh/sshd_config 2> >(tee -a debug.log >&2)
sudo /etc/init.d/ssh restart 2> >(tee -a debug.log >&2)
echo -e "\e[32mSSH security config complete\e[0m"
sleep 3


##Enable PiNode-XMR on boot
	echo "Enable PiNode-XMR on boot" >>debug.log
echo -e "\e[32mEnable PiNode-XMR on boot\e[0m"
sleep 3
sudo mv /home/pinodexmr/PiNode-XMR/etc/rc.local /etc/rc.local 2> >(tee -a debug.log >&2)
sudo chmod 755 /etc/rc.local 2> >(tee -a debug.log >&2)
sudo chown root /etc/rc.local 2> >(tee -a debug.log >&2)
echo -e "\e[32mSuccess\e[0m"
sleep 3

##Add PiNode-XMR systemd services
	echo "Add PiNode-XMR systemd services" >>debug.log
echo -e "\e[32mAdd PiNode-XMR systemd services\e[0m"
sleep 3
sudo mv /home/pinodexmr/PiNode-XMR/etc/systemd/system/*.service /etc/systemd/system/ 2> >(tee -a debug.log >&2)
sudo chmod 644 /etc/systemd/system/*.service 2> >(tee -a debug.log >&2)
sudo chown root /etc/systemd/system/*.service 2> >(tee -a debug.log >&2)
sudo systemctl daemon-reload 2> >(tee -a debug.log >&2)
sudo systemctl start statusOutputs.service 2> >(tee -a debug.log >&2)
sudo systemctl enable statusOutputs.service 2> >(tee -a debug.log >&2)
echo -e "\e[32mSuccess\e[0m"
sleep 3

#Configure apache server for access to monero log file
	sudo mv /home/pinodexmr/PiNode-XMR/etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf 2> >(tee -a debug.log >&2)
sudo chmod 777 /etc/apache2/sites-enabled/000-default.conf 2> >(tee -a debug.log >&2)
sudo chown root /etc/apache2/sites-enabled/000-default.conf 2> >(tee -a debug.log >&2)
sudo /etc/init.d/apache2 restart 2> >(tee -a debug.log >&2)

echo -e "\e[32mSuccess\e[0m"
sleep 3

##Setup local hostname
	echo "Setup local hostname" >>debug.log
sudo mv /home/pinodexmr/PiNode-XMR/etc/avahi/avahi-daemon.conf /etc/avahi/avahi-daemon.conf 2> >(tee -a debug.log >&2)
sudo /etc/init.d/avahi-daemon restart 2> >(tee -a debug.log >&2)

##Copy PiNode-XMR scripts to home folder
echo -e "\e[32mMoving PiNode-XMR scripts into position\e[0m"
sleep 3
mv /home/pinodexmr/PiNode-XMR/home/pinodexmr/* /home/pinodexmr/ 2> >(tee -a debug.log >&2)
mv /home/pinodexmr/PiNode-XMR/home/pinodexmr/.profile /home/pinodexmr/ 2> >(tee -a debug.log >&2)
sudo chmod 777 -R /home/pinodexmr/* 2> >(tee -a debug.log >&2) #Read/write access needed by www-data to action php port, address customisation
echo -e "\e[32mSuccess\e[0m"
sleep 3

##Configure Web-UI
	echo "Configure Web-UI" >>debug.log
echo -e "\e[32mConfiguring Web-UI\e[0m"
sleep 3
#First move hidden file specifically .htaccess file then entire directory
sudo mv /home/pinodexmr/PiNode-XMR/HTML/.htaccess /var/www/html/ 2> >(tee -a debug.log >&2)
sudo mv /home/pinodexmr/PiNode-XMR/HTML/*.* /var/www/html/ 2> >(tee -a debug.log >&2)
sudo mv /home/pinodexmr/PiNode-XMR/HTML/images /var/www/html 2> >(tee -a debug.log >&2)
sudo chown www-data -R /var/www/html/ 2> >(tee -a debug.log >&2)
sudo chmod 777 -R /var/www/html/ 2> >(tee -a debug.log >&2)


# ********************************************
# ******START OF MONERO SOURCE BULD******
# ********************************************
##Build Monero and Onion Blockchain Explorer (the simple but time comsuming bit)
	echo "Build Monero" >>debug.log
#First build monero, single build directory

	#Download latest Monero release/tag number
wget -q https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/master/moneroLatestTag.sh -O /home/pinodexmr/moneroLatestTag.sh 2> >(tee -a debug.log >&2)
chmod 755 /home/pinodexmr/moneroLatestTag.sh 2> >(tee -a debug.log >&2)
. /home/pinodexmr/moneroLatestTag.sh 2> >(tee -a debug.log >&2)

echo -e "\e[32mDownloading Monero $TAG\e[0m"
sleep 3
#git clone --recursive https://github.com/monero-project/monero.git       #Dev Branch
git clone --recursive https://github.com/monero-project/monero.git 2> >(tee -a debug.log >&2) #Latest Stable Branch
echo -e "\e[32mBuilding Monero $TAG\e[0m"
echo -e "\e[32m****************************************************\e[0m"
echo -e "\e[32m****************************************************\e[0m"
echo -e "\e[32m***This will take a 3-8hours - Hardware Dependent***\e[0m"
echo -e "\e[32m****************************************************\e[0m"
echo -e "\e[32m****************************************************\e[0m"
sleep 10
cd monero
git checkout $TAG 2> >(tee -a debug.log >&2)
git submodule sync 2> >(tee -a debug.log >&2) && git submodule update --init --force 2> >(tee -a debug.log >&2)
USE_SINGLE_BUILDDIR=1 make release 2> >(tee -a debug.log >&2)
cd
#Make dir .bitmonero to hold lmdb. Needs to be added before drive mounted to give mount point. Waiting for monerod to start fails mount.
mkdir .bitmonero 2> >(tee -a debug.log >&2)

echo -e "\e[32mBuilding Monero Blockchain Explorer[0m"
echo -e "\e[32m*******************************************************\e[0m"
echo -e "\e[32m***This will take a few minutes - Hardware Dependent***\e[0m"
echo -e "\e[32m*******************************************************\e[0m"
sleep 10
		echo "Build Monero Onion Block Explorer" >>debug.log
git clone https://github.com/moneroexamples/onion-monero-blockchain-explorer.git 2> >(tee -a debug.log >&2)
cd onion-monero-blockchain-explorer 2> >(tee -a debug.log >&2)
mkdir build && cd build 2> >(tee -a debug.log >&2)
cmake .. 2> >(tee -a debug.log >&2)
make 2> >(tee -a debug.log >&2)
cd
# ********************************************
# ********END OF MONERO SOURCE BULD **********
# ********************************************

# #********************************************
# #*******START OF ARMv7 BINARY USE************
# #*************(DISABLED)*********************
#
# echo "Downloading pre-built Monero from get.monero" >>debug.log
# #Make standard location for Monero
# mkdir -p ~/monero/build/release/bin
# #Downlaod Monero
# wget https://downloads.getmonero.org/cli/linuxarm7
# #Make temp folder to extract binaries
# mkdir temp && tar -xf linuxarm7 -C ~/temp
# #Mode Monerod files to standard location
# mv /home/pinodexmr/temp/monero-arm-linux-gnueabihf-v0.17.2.3/monero* /home/pinodexmr/monero/build/release/bin/
# #Clean-up used downloaded files
# rm -R ~/temp
# rm linuxarm7
#
# #********************************************
# #*******END OF ARMv7 BINARY USE *************
# #*************(DISABLED)*********************

##Install crontab
		echo "Install crontab" >>debug.log
echo -e "\e[32mSetup crontab\e[0m"
sleep 3
sudo crontab /home/pinodexmr/PiNode-XMR/var/spool/cron/crontabs/root 2> >(tee -a debug.log >&2)
crontab /home/pinodexmr/PiNode-XMR/var/spool/cron/crontabs/pinodexmr 2> >(tee -a debug.log >&2)
echo -e "\e[32mSuccess\e[0m"
sleep 3

##Set Swappiness lower
		echo "Set RAM Swappiness lower" >>debug.log
sudo sysctl vm.swappiness=10 2> >(tee -a debug.log >&2)

## Remove left over files from git clone actions
	echo "Remove left over files from git clone actions" >>debug.log
echo -e "\e[32mCleanup leftover directories\e[0m"
sleep 3
sudo rm -r /home/pinodexmr/PiNode-XMR/ 2> >(tee -a debug.log >&2)
sudo rm /home/pinodexmr/moneroLatestTag.sh 2> >(tee -a debug.log >&2)

##Change log in menu to 'main'
#Delete line 28 (previous setting)
wget -O ~/.profile https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/ubuntuServer-20.04/home/pinodexmr/.profile 2> >(tee -a debug.log >&2)

##End debug log
echo "
####################
" >>debug.log
echo "End raspbian-pinodexmr.sh script $(date)" >>debug.log
echo "
####################
" >>debug.log

## Install complete
echo -e "\e[32mAll Installs complete\e[0m"
whiptail --title "PiNode-XMR Continue Install" --msgbox "Your PiNode-XMR is ready\n\nInstall complete. When you log in after the reboot use the menu to change your passwords and other features.\n\nEnjoy your Private Node\n\nSelect ok to reboot" 16 60
echo -e "\e[32m****************************************\e[0m"
echo -e "\e[32m****************************************\e[0m"
echo -e "\e[32m**********PiNode-XMR rebooting**********\e[0m"
echo -e "\e[32m**********Reminder:*********************\e[0m"
echo -e "\e[32m**********User: 'pinodexmr'*************\e[0m"
echo -e "\e[32m**********Password: 'PiNodeXMR**********\e[0m"
echo -e "\e[32m****************************************\e[0m"
echo -e "\e[32m****************************************\e[0m"
sleep 10
sudo reboot
