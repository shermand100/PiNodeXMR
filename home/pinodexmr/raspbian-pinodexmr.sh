#!/bin/bash

##Open Sources:
# Web-UI by designmodo Flat-UI free project at https://github.com/designmodo/Flat-UI
# Monero github https://github.com/moneroexamples/monero-compilation/blob/master/README.md
# Monero Blockchain Explorer https://github.com/moneroexamples/onion-monero-blockchain-explorer
# PiNode-XMR scripts and custom files at my repo https://github.com/shermand100/pinode-xmr
whiptail --title "PiNode-XMR Continue Install" --msgbox "Your PiNode-XMR is taking shape...\n\nHowever this next part will take several hours. When testing this installation I would leave it overnight.\n\nSelect ok to continue setup" 16 60
###Continue as 'pinodexmr'
cd
echo -e "\e[32mLock old user 'pi'\e[0m"
sleep 1
#sudo passwd --lock pi
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
sleep 3

##Installing dependencies for --- Monero
echo -e "\e[32mInstalling dependencies for --- Monero\e[0m"
sleep 3
sudo apt install git build-essential cmake libpython2.7-dev libboost-all-dev miniupnpc pkg-config libunbound-dev graphviz doxygen libunwind8-dev libssl-dev libcurl4-openssl-dev libgtest-dev libreadline-dev libzmq3-dev libsodium-dev libhidapi-dev libhidapi-libusb0 -y
sleep 3

##Installing dependencies for --- miscellaneous (tor+tor monitor-nyx, security tools-fail2ban-ufw, menu tool-dialog, screen, mariadb)
echo -e "\e[32mInstalling dependencies for --- Miscellaneous\e[0m"
sleep 3
sudo apt install mariadb-client-10.0 mariadb-server-10.0 screen exfat-fuse exfat-utils tor nyx fail2ban ufw  dialog -y
sleep 3

##Configure Swap file
echo -e "\e[32mConfiguring 2GB Swap file (required for Monero build)\e[0m"
sleep 3
wget https://raw.githubusercontent.com/shermand100/pinode-xmr/development/etc/dphys-swapfile
sudo mv /home/pinodexmr/dphys-swapfile /etc/dphys-swapfile
sudo chmod 664 /etc/dphys-swapfile
sudo chown root /etc/dphys-swapfile
sudo dphys-swapfile setup
sleep 5
sudo dphys-swapfile swapon
echo -e "\e[32mSwap file of 2GB Configured and enabled\e[0m"
sleep 3

##Clone PiNode-XMR to device from git
echo -e "\e[32mDownloading PiNode-XMR files\e[0m"
sleep 3
git clone -b development --single-branch https://github.com/shermand100/pinode-xmr.git


##Configure ssh security. Allow only user 'pinodexmr' & 'root' login disabled, restart config to make changes
echo -e "\e[32mConfiguring SSH security\e[0m"
sleep 3
sudo mv /home/pinodexmr/pinode-xmr/etc/ssh/sshd_config /etc/ssh/sshd_config
sudo chmod 644 /etc/ssh/sshd_config
sudo chown root /etc/ssh/sshd_config
sudo /etc/init.d/ssh restart
echo -e "\e[32mSSH security config complete\e[0m"
sleep 3

##Disable IPv6 on boot. Enabled causes errors as Raspbian generates a IPv4 and IPv6 address and Monerod will fail with both.
echo -e "\e[32mDisable IPv6 on boot\e[0m"
sleep 3
echo 'ipv6.disable=1' | sudo tee -a /boot/cmdline.txt
echo -e "\e[32mIPv6 Disabled on boot\e[0m"
sleep 3

##Enable PiNode-XMR on boot
echo -e "\e[32mEnable PiNode-XMR on boot\e[0m"
sleep 3
sudo mv /home/pinodexmr/pinode-xmr/etc/rc.local /etc/rc.local
sudo chmod 644 /etc/rc.local
sudo chown root /etc/rc.local
echo -e "\e[32mSuccess\e[0m"
sleep 3

##Add PiNode-XMR systemd services
echo -e "\e[32mAdd PiNode-XMR systemd services\e[0m"
sleep 3
sudo mv /home/pinodexmr/pinode-xmr/etc/systemd/system/*.service /etc/systemd/system/
sudo chmod 644 /etc/systemd/system/*.service
sudo chown root /etc/systemd/system/*.service
echo -e "\e[32mSuccess\e[0m"
sleep 3

##Setup tor hidden service and monitor file
echo -e "\e[32mSetup tor hidden service and monitor file\e[0m"
sleep 3
sudo mv /home/pinodexmr/pinode-xmr/etc/tor/torrc /etc/tor/torrc
sudo chmod 644 /etc/tor/torrc
sudo chown root /etc/tor/torrc
echo -e "\e[32mSuccess\e[0m"
sleep 3

##UFW Setup
echo -e "\e[32mSetup Uncomplicated Firewall\e[0m"
sleep 3
sudo ufw allow 80		#web
sudo ufw allow 8081		#onion explorer
sudo ufw allow 443		#ssl 
sudo ufw allow 18080	#monero spare
sudo ufw allow 18081	#monero node default
sudo ufw allow 4200		#web terminal
sudo ufw allow 22		#ssh
sudo ufw enable
echo -e "\e[32mFirewall configured\e[0m"
sleep 3

##Copy PiNode-XMR scripts to home folder
echo -e "\e[32mMoving PiNode-XMR scripts into possition\e[0m"
sleep 3
mv /home/pinodexmr/pinode-xmr/home/pinodexmr/* /home/pinodexmr/
mv /home/pinodexmr/pinode-xmr/home/pinodexmr/.profile /home/pinodexmr/
chmod 755 /home/pinodexmr/*
echo -e "\e[32mSuccess\e[0m"
sleep 3

##Download (git clone) Web-UI template
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

##Build Monero and Onion Blockchain Explorer (the simple but time comsuming bit)
#First build monero, single build directory
echo -e "\e[32mDownloading Monero v0.15\e[0m"
sleep 3
git clone --recursive -b release-v0.15 https://github.com/monero-project/monero.git
echo -e "\e[32mBuilding Monero v0.15\e[0m"
echo -e "\e[32m****************************************************\e[0m"
echo -e "\e[32m****************************************************\e[0m"
echo -e "\e[32m***This will take a 3-8hours - Hardware Dependent***\e[0m"
echo -e "\e[32m****************************************************\e[0m"
echo -e "\e[32m****************************************************\e[0m"
sleep 10
cd monero
USE_SINGLE_BUILDDIR=1 make
cd
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
sudo chmod 1730 /home/pinodexmr/pinode-xmr/var/spool/cron/crontabs/pinodexmr
sudo chmod 1730 /home/pinodexmr/pinode-xmr/var/spool/cron/crontabs/root
sudo chown root /home/pinodexmr/pinode-xmr/var/spool/cron/crontabs/root
sudo chown pinodexmr /home/pinodexmr/pinode-xmr/var/spool/cron/crontabs/pinodexmr
sudo mv /home/pinodexmr/pinode-xmr/var/spool/cron/crontabs/pinodexmr /var/spool/cron/crontabs/
sudo mv /home/pinodexmr/pinode-xmr/var/spool/cron/crontabs/root /var/spool/cron/crontabs/
echo -e "\e[32mSuccess\e[0m"
sleep 3

## Remove left over files from git clone actions
echo -e "\e[32mCleanup leftover directories\e[0m"
sleep 3
sudo rm -r /home/pinodexmr/Flat-UI/
sudo rm -r /home/pinodexmr/pinode-xmr/

##Change log in menu to 'main'
#Delete line 28 (previous setting)
sudo sed -i '28d' /home/pinodexmr/.profile
#Set to auto run main setup menu on login
echo '. /home/pinodexmr/setup.sh' | tee -a /home/pinodexmr/.profile

## Install complete
echo -e "\e[32mAll Installs complete\e[0m"
whiptail --title "PiNode-XMR Continue Install" --msgbox "Your PiNode-XMR is ready\n\nInstall complete. When you log in after the reboot use the menu to change your passwords and other features.\n\nEnjoy your Private Node\n\nSelect ok to reboot" 16 60
echo -e "\e[32m****************************************\e[0m"
echo -e "\e[32m**********PiNode-XMR rebooting**********\e[0m"
echo -e "\e[32m**********Reminder:*********************\e[0m"
echo -e "\e[32m**********User: 'pinodexmr'*************\e[0m"
echo -e "\e[32m**********Password: 'PiNodeXMR'*********\e[0m"
echo -e "\e[32m****************************************\e[0m"
sleep 10
sudo reboot
