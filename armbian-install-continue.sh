#!/bin/bash

##Open Sources:
# Monero github https://github.com/moneroexamples/monero-compilation/blob/master/README.md
# Monero Blockchain Explorer https://github.com/moneroexamples/onion-monero-blockchain-explorer
# PiNode-XMR scripts and custom files at my repo https://github.com/monero-ecosystem/PiNode-XMR
# PiVPN - OpenVPN server setup https://github.com/pivpn/pivpn

###Begin2

whiptail --title "PiNode-XMR Continue Armbian Installer" --msgbox "Your PiNode-XMR is taking shape...\n\nThis next part will take several hours dependant on your hardware but I won't require any further input from you. I can be left to install myself if you wish\n\nSelect ok to continue setup" 16 60
###Continue as 'pinodexmr'

##Update and Upgrade system
echo -e "\e[32mReceiving and applying Armbian updates to latest versions\e[0m"
sleep 3
sudo apt update && sudo apt upgrade -y && sudo apt install armbian-config -y

##Installing dependencies for --- Web Interface
echo -e "\e[32mInstalling dependencies for --- Web Interface\e[0m"
sleep 3
sudo apt install apache2 shellinabox php7.3 php7.3-cli php7.3-common php7.3-curl php7.3-gd php7.3-json php7.3-mbstring php7.3-mysql php7.3-xml -y
sleep 3

##Installing dependencies for --- Monero
echo -e "\e[32mInstalling dependencies for --- Monero\e[0m"
sleep 3
sudo apt install git build-essential cmake libpython2.7-dev libboost-all-dev miniupnpc pkg-config libpgm-dev libexpat1-dev libusb-1.0-0-dev libprotobuf-dev protobuf-compiler libudev-dev libunbound-dev graphviz doxygen liblzma-dev libldns-dev libunwind8-dev libssl-dev libcurl4-openssl-dev libgtest-dev libreadline6-dev libzmq3-dev libsodium-dev libhidapi-dev libhidapi-libusb0 -y
sleep 3

##Installing dependencies for --- miscellaneous (security tools-fail2ban-ufw, menu tool-dialog, screen, mariadb)
echo -e "\e[32mInstalling dependencies for --- Miscellaneous\e[0m"
sleep 3
sudo apt install mariadb-client-10.3 mariadb-server-10.3 screen exfat-fuse exfat-utils fail2ban ufw avahi-daemon dialog -y
sleep 3
	## Installing new dependencies for IP2Geo map creation
sudo apt install python3-numpy python3-matplotlib libgeos-dev python3-geoip2 python3-mpltoolkits.basemap -y

##Clone PiNode-XMR to device from git
echo -e "\e[32mDownloading PiNode-XMR files\e[0m"
sleep 3
git clone -b Armbian-install --single-branch https://github.com/monero-ecosystem/PiNode-XMR.git


##Configure ssh security. Allows only user 'pinodexmr'. Also 'root' login disabled via ssh, restarts config to make changes
echo -e "\e[32mConfiguring SSH security\e[0m"
sleep 3
sudo mv /home/pinodexmr/PiNode-XMR/etc/ssh/sshd_config /etc/ssh/sshd_config
sudo chmod 644 /etc/ssh/sshd_config
sudo chown root /etc/ssh/sshd_config
sudo /etc/init.d/ssh restart
echo -e "\e[32mSSH security config complete\e[0m"
sleep 3


##Enable PiNode-XMR on boot
echo -e "\e[32mEnable PiNode-XMR on boot\e[0m"
sleep 3
sudo mv /home/pinodexmr/PiNode-XMR/etc/rc.local /etc/rc.local
sudo chmod 644 /etc/rc.local
sudo chown root /etc/rc.local
echo -e "\e[32mSuccess\e[0m"
sleep 3

##Add PiNode-XMR systemd services
echo -e "\e[32mAdd PiNode-XMR systemd services\e[0m"
sleep 3
sudo mv /home/pinodexmr/PiNode-XMR/etc/systemd/system/*.service /etc/systemd/system/
sudo chmod 644 /etc/systemd/system/*.service
sudo chown root /etc/systemd/system/*.service
echo -e "\e[32mSuccess\e[0m"
sleep 3

##Add PiNode-XMR php settings
echo -e "\e[32mAdd PiNode-XMR php settings\e[0m"
sleep 3
sudo mv /home/pinodexmr/PiNode-XMR/etc/php/7.3/apache2/php.ini /etc/php/7.3/apache2/
sudo /etc/init.d/apache2 restart

echo -e "\e[32mSuccess\e[0m"
sleep 3

##Setup local hostname
sudo mv /home/pinodexmr/PiNode-XMR/etc/avahi/avahi-daemon.conf /etc/avahi/avahi-daemon.conf
sudo /etc/init.d/avahi-daemon restart

##Copy PiNode-XMR scripts to home folder
echo -e "\e[32mMoving PiNode-XMR scripts into possition\e[0m"
sleep 3
mv /home/pinodexmr/PiNode-XMR/home/pinodexmr/* /home/pinodexmr/
mv /home/pinodexmr/PiNode-XMR/home/pinodexmr/.profile /home/pinodexmr/
sudo chmod 777 -R /home/pinodexmr/*	#Read/write access needed by www-data to action php port, address customisation
echo -e "\e[32mSuccess\e[0m"
sleep 3

##Configure Web-UI

echo -e "\e[32mConfiguring Web-UI\e[0m"
sleep 3
sudo mv /home/pinodexmr/PiNode-XMR/HTML/*.* /var/www/html/
sudo mv /home/pinodexmr/PiNode-XMR/HTML/images /var/www/html
sudo chown www-data -R /var/www/html/
sudo chmod 777 -R /var/www/html/

##Build Monero and Onion Blockchain Explorer (the simple but time comsuming bit)
#First build monero, single build directory

	#Download release number
wget -q https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/master/release.sh -O /home/pinodexmr/release.sh
chmod 755 /home/pinodexmr/release.sh
. /home/pinodexmr/release.sh

echo -e "\e[32mDownloading Monero $RELEASE\e[0m"
sleep 3
#git clone --recursive https://github.com/monero-project/monero.git       #Dev Branch
git clone --recursive -b $RELEASE https://github.com/monero-project/monero.git         #Latest Stable Branch
echo -e "\e[32mBuilding Monero $RELEASE\e[0m"
echo -e "\e[32m****************************************************\e[0m"
echo -e "\e[32m****************************************************\e[0m"
echo -e "\e[32m***This will take a 3-8hours - Hardware Dependent***\e[0m"
echo -e "\e[32m****************************************************\e[0m"
echo -e "\e[32m****************************************************\e[0m"
sleep 10
cd monero
USE_SINGLE_BUILDDIR=1 make
cd
#Make dir .bitmonero to hold lmdb. Needs to be added before drive mounted to give mount point. Waiting for monerod to start fails mount.
mkdir .bitmonero
echo -e "\e[32mBuilding Monero Blockchain Explorer[0m"
echo -e "\e[32m*******************************************************\e[0m"
echo -e "\e[32m***This will take a few minutes - Hardware Dependent***\e[0m"
echo -e "\e[32m*******************************************************\e[0m"
sleep 10
git clone https://github.com/moneroexamples/onion-monero-blockchain-explorer.git
cd onion-monero-blockchain-explorer
mkdir build && cd build
cmake ..
make
cd

##Install crontab
echo -e "\e[32mSetup crontab\e[0m"
sleep 3
sudo crontab /home/pinodexmr/PiNode-XMR/var/spool/cron/crontabs/root
crontab /home/pinodexmr/PiNode-XMR/var/spool/cron/crontabs/pinodexmr
echo -e "\e[32mSuccess\e[0m"
sleep 3

## Remove left over files from git clone actions
echo -e "\e[32mCleanup leftover directories\e[0m"
sleep 3
sudo rm -r /home/pinodexmr/PiNode-XMR/

##Change log in menu to 'main'
#Delete line 28 (previous setting)
sudo sed -i '28d' /home/pinodexmr/.profile
#Set to auto run main setup menu on login
echo '. /home/pinodexmr/setup.sh' | tee -a /home/pinodexmr/.profile

## Install complete
echo -e "\e[32mAll Installs complete\e[0m"
whiptail --title "PiNode-XMR Continue Install" --msgbox "Your PiNode-XMR is ready\n\nInstall complete. When you log in after the reboot use the menu to change your passwords and other features.\n\nEnjoy your Private Node\n\nSelect ok to reboot" 16 60
echo -e "\e[32m****************************************\e[0m"
echo -e "\e[32m****************************************\e[0m"
echo -e "\e[32m**********PiNode-XMR rebooting**********\e[0m"
echo -e "\e[32m**********Reminder:*********************\e[0m"
echo -e "\e[32m**********User: 'pinodexmr'*************\e[0m"
echo -e "\e[32m****************************************\e[0m"
echo -e "\e[32m****************************************\e[0m"
sleep 10
sudo reboot
