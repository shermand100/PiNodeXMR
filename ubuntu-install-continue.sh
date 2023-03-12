#!/bin/bash

##Open Sources:
# Monero github https://github.com/moneroexamples/monero-compilation/blob/master/README.md
# Monero Blockchain Explorer https://github.com/moneroexamples/onion-monero-blockchain-explorer
# Nanode scripts and custom files at my repo https://github.com/monero-ecosystem/Nanode
# PiVPN - OpenVPN server setup https://github.com/pivpn/pivpn

###Begin2

#Create debug file for handling install errors:
touch /home/nanode/debug.log
echo "
####################
" 2>&1 | tee -a /home/nanode/debug.log
echo "Start ubuntu-install-continue.sh script $(date)" 2>&1 | tee -a /home/nanode/debug.log
echo "
####################
" 2>&1 | tee -a /home/nanode/debug.log

whiptail --title "Nanode Continue Ubuntu LTS Installer" --msgbox "Your Nanode is taking shape...\n\nThis next part will take ~80 minutes installing Monero and Nanode \n\nSelect ok to continue setup" 16 60
###Continue as 'nanode'

###Continue as 'nanode'
cd
echo -e "\e[32mLock old user 'pi'\e[0m"
sudo passwd --lock pi
echo -e "\e[32mUser 'pi' Locked\e[0m"
echo -e "\e[32mLock old user 'ubuntu'\e[0m"
sudo passwd --lock ubuntu
echo -e "\e[32mUser 'ubuntu' Locked\e[0m"

##Update and Upgrade system (This step repeated due to importance and maybe someone using this installer sript out-of-sequence)
echo -e "\e[32mReceiving and applying Ubuntu updates to latest versions\e[0m"
sudo apt-get update 2>&1 | tee -a /home/nanode/debug.log
sudo apt-get --yes -o Dpkg::Options::="--force-confnew" upgrade 2>&1 | tee -a /home/nanode/debug.log
sudo apt-get --yes -o Dpkg::Options::="--force-confnew" dist-upgrade 2>&1 | tee -a /home/nanode/debug.log
sudo apt-get upgrade -y 2>&1 | tee -a /home/nanode/debug.log

##Installing dependencies for --- Web Interface
	echo "Installing dependencies for --- Web Interface" 2>&1 | tee -a /home/nanode/debug.log
echo -e "\e[32mInstalling dependencies for --- Web Interface\e[0m"
sudo apt-get install apache2 shellinabox php php-common avahi-daemon -y 2>&1 | tee -a /home/nanode/debug.log
sudo usermod -a -G nanode www-data
##Installing dependencies for --- Monero
	echo "Installing dependencies for --- Monero" 2>&1 | tee -a /home/nanode/debug.log
echo -e "\e[32mInstalling dependencies for --- Monero\e[0m"
sudo apt-get update
sudo apt-get install build-essential cmake pkg-config libssl-dev libzmq3-dev libunbound-dev libsodium-dev libunwind8-dev liblzma-dev libreadline6-dev libldns-dev libexpat1-dev libpgm-dev qttools5-dev-tools libhidapi-dev libusb-1.0-0-dev libprotobuf-dev protobuf-compiler libudev-dev libboost-chrono-dev libboost-date-time-dev libboost-filesystem-dev libboost-locale-dev libboost-program-options-dev libboost-regex-dev libboost-all-dev libboost-serialization-dev libboost-system-dev libboost-thread-dev ccache doxygen graphviz -y 2>&1 | tee -a /home/nanode/debug.log
	echo "manual build of gtest for --- Monero" 2>&1 | tee -a /home/nanode/debug.log
sudo apt-get install libgtest-dev -y 2>&1 | tee -a /home/nanode/debug.log
cd /usr/src/gtest
sudo cmake . 2>&1 | tee -a /home/nanode/debug.log
sudo make
sudo mv lib/libg* /usr/lib/
cd
##Installing dependencies for --- P2Pool
	echo "Installing dependencies for --- P2Pool" 2>&1 | tee -a /home/nanode/debug.log
sudo apt-get install git build-essential cmake libuv1-dev libzmq3-dev libsodium-dev libpgm-dev libnorm-dev libgss-dev -y


##Checking all dependencies are installed for --- miscellaneous (security tools-fail2ban-ufw, menu tool-dialog, screen, mariadb)
	echo "Installing dependencies for --- miscellaneous" 2>&1 | tee -a /home/nanode/debug.log
echo -e "\e[32mChecking all dependencies are installed for --- Miscellaneous\e[0m"
sudo apt-get install git mariadb-client mariadb-server screen fail2ban ufw dialog jq libcurl4-openssl-dev libpthread-stubs0-dev cron -y 2>&1 | tee -a /home/nanode/debug.log
sudo apt-get install exfat-fuse exfat-utils -y 2>&1 | tee -a /home/nanode/debug.log
#libcurl4-openssl-dev & libpthread-stubs0-dev for block-explorer

##Clone Nanode to device from git
	echo "Clone Nanode to device from git" 2>&1 | tee -a /home/nanode/debug.log
echo -e "\e[32mDownloading Nanode files\e[0m"
git clone -b ubuntuServer-20.04 --single-branch https://github.com/monero-ecosystem/Nanode.git 2>&1 | tee -a /home/nanode/debug.log


##Configure ssh security. Allows only user 'nanode'. Also 'root' login disabled via ssh, restarts config to make changes
	echo "Configure ssh security" 2>&1 | tee -a /home/nanode/debug.log
echo -e "\e[32mConfiguring SSH security\e[0m"
sudo mv /home/nanode/Nanode/etc/ssh/sshd_config /etc/ssh/sshd_config 2>&1 | tee -a /home/nanode/debug.log
sudo chmod 644 /etc/ssh/sshd_config 2>&1 | tee -a /home/nanode/debug.log
sudo chown root /etc/ssh/sshd_config 2>&1 | tee -a /home/nanode/debug.log
sudo /etc/init.d/ssh restart 2>&1 | tee -a /home/nanode/debug.log
echo -e "\e[32mSSH security config complete\e[0m"


##Copy Nanode scripts to home folder
echo -e "\e[32mMoving Nanode scripts into position\e[0m"
mv /home/nanode/Nanode/home/nanode/* /home/nanode/ 2>&1 | tee -a /home/nanode/debug.log
mv /home/nanode/Nanode/home/nanode/.profile /home/nanode/ 2>&1 | tee -a /home/nanode/debug.log
sudo chmod 777 -R /home/nanode/* 2>&1 | tee -a /home/nanode/debug.log #Read/write access needed by www-data to action php port, address customisation
echo -e "\e[32mSuccess\e[0m"

##Add Nanode systemd services
	echo "Add Nanode systemd services" 2>&1 | tee -a /home/nanode/debug.log
echo -e "\e[32mAdd Nanode systemd services\e[0m"
sudo mv /home/nanode/Nanode/etc/systemd/system/*.service /etc/systemd/system/ 2>&1 | tee -a /home/nanode/debug.log
sudo chmod 644 /etc/systemd/system/*.service 2>&1 | tee -a /home/nanode/debug.log
sudo chown root /etc/systemd/system/*.service 2>&1 | tee -a /home/nanode/debug.log
sudo systemctl daemon-reload 2>&1 | tee -a /home/nanode/debug.log
sudo systemctl start moneroStatus.service 2>&1 | tee -a /home/nanode/debug.log
sudo systemctl enable moneroStatus.service 2>&1 | tee -a /home/nanode/debug.log
echo -e "\e[32mSuccess\e[0m"

#Configure apache server for access to monero log file
sudo mv /home/nanode/Nanode/etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf 2>&1 | tee -a /home/nanode/debug.log
sudo chmod 777 /etc/apache2/sites-enabled/000-default.conf 2>&1 | tee -a /home/nanode/debug.log
sudo chown root /etc/apache2/sites-enabled/000-default.conf 2>&1 | tee -a /home/nanode/debug.log
sudo /etc/init.d/apache2 restart 2>&1 | tee -a /home/nanode/debug.log

echo -e "\e[32mSuccess\e[0m"

##Setup local hostname
	echo "Setup local hostname" 2>&1 | tee -a /home/nanode/debug.log
sudo mv /home/nanode/Nanode/etc/avahi/avahi-daemon.conf /etc/avahi/avahi-daemon.conf 2>&1 | tee -a /home/nanode/debug.log
sudo /etc/init.d/avahi-daemon restart 2>&1 | tee -a /home/nanode/debug.log

##Configure Web-UI
	echo "Configure Web-UI" 2>&1 | tee -a /home/nanode/debug.log

echo -e "\e[32mSuccess\e[0m"

# ********************************************
# ******START OF MONERO SOURCE BULD******
# ********************************************
##Build Monero and Onion Blockchain Explorer (the simple but time comsuming bit)
	#Download latest Monero release number
#ubuntu /dev/null odd requiremnt to set permissions
sudo chmod 666 /dev/null
wget -q https://raw.githubusercontent.com/monero-ecosystem/Nanode/master/release.sh -O /home/nanode/release.sh
chmod 755 /home/nanode/release.sh
. /home/nanode/release.sh

echo -e "\e[32mDownloading Monero \e[0m"

git clone --recursive https://github.com/monero-project/monero
echo -e "\e[32mBuilding Monero \e[0m"
echo -e "\e[32m****************************************************\e[0m"
echo -e "\e[32m****************************************************\e[0m"
echo -e "\e[32m***This will take a while - Hardware Dependent***\e[0m"
echo -e "\e[32m****************************************************\e[0m"
echo -e "\e[32m****************************************************\e[0m"
cd monero && git submodule init && git submodule update
git checkout $RELEASE
git submodule sync && git submodule update
USE_SINGLE_BUILDDIR=1 make 2>&1 | tee -a /home/nanode/debug.log
cd
#Make dir .bitmonero to hold lmdb. Needs to be added before drive mounted to give mount point. Waiting for monerod to start fails mount.
mkdir .bitmonero 2>&1 | tee -a /home/nanode/debug.log

echo -e "\e[32mBuilding Monero Blockchain Explorer[0m"
echo -e "\e[32m*******************************************************\e[0m"
echo -e "\e[32m***This will take a few minutes - Hardware Dependent***\e[0m"
echo -e "\e[32m*******************************************************\e[0m"
		echo "Build Monero Onion Block Explorer" 2>&1 | tee -a /home/nanode/debug.log
git clone https://github.com/moneroexamples/onion-monero-blockchain-explorer.git 2>&1 | tee -a /home/nanode/debug.log
cd onion-monero-blockchain-explorer
mkdir build
cd build
cmake .. 2>&1 | tee -a /home/nanode/debug.log
make 2>&1 | tee -a /home/nanode/debug.log
cd
rm ~/release.sh

# ********************************************
# ********END OF MONERO SOURCE BULD **********
# ********************************************

echo -e "\e[32mInstalling P2Pool\e[0m" 2>&1 | tee -a /home/nanode/debug.log
git clone --recursive https://github.com/SChernykh/p2pool 2>&1 | tee -a /home/nanode/debug.log
cd p2pool
git checkout tags/v2.2.1
mkdir build && cd build
cmake .. 2>&1 | tee -a /home/nanode/debug.log
make -j2 2>&1 | tee -a /home/nanode/debug.log
echo -e "\e[32mSuccess\e[0m" 2>&1 | tee -a /home/nanode/debug.log

#Manage P2pool log file ia log rotate
sudo mv /home/nanode/Nanode/etc/logrotate.d/p2pool /etc/logrotate.d/p2pool 2>&1 | tee -a /home/nanode/debug.log
sudo chmod 644 /etc/logrotate.d/p2pool 2>&1 | tee -a /home/nanode/debug.log
sudo chown root /etc/logrotate.d/p2pool 2>&1 | tee -a /home/nanode/debug.log

##Install log.io (Real-time service monitoring)
#Establish Device IP
. ~/variables/deviceIp.sh
echo -e "\e[32mInstalling log.io\e[0m" 2>&1 | tee -a /home/nanode/debug.log
sudo apt-get install nodejs npm -y 2>&1 | tee -a /home/nanode/debug.log
sudo npm install -g log.io 2>&1 | tee -a /home/nanode/debug.log
sudo npm install -g log.io-file-input 2>&1 | tee -a /home/nanode/debug.log
mkdir -p ~/.log.io/inputs/ 2>&1 | tee -a /home/nanode/debug.log
mv /home/nanode/Nanode/.log.io/inputs/file.json ~/.log.io/inputs/file.json 2>&1 | tee -a /home/nanode/debug.log
mv /home/nanode/Nanode/.log.io/server.json ~/.log.io/server.json 2>&1 | tee -a /home/nanode/debug.log
sed -i "s/127.0.0.1/$DEVICE_IP/g" ~/.log.io/server.json 2>&1 | tee -a /home/nanode/debug.log
sed -i "s/127.0.0.1/$DEVICE_IP/g" ~/.log.io/inputs/file.json 2>&1 | tee -a /home/nanode/debug.log
sudo systemctl start log-io-server.service 2>&1 | tee -a /home/nanode/debug.log
sudo systemctl start log-io-file.service 2>&1 | tee -a /home/nanode/debug.log
sudo systemctl enable log-io-server.service 2>&1 | tee -a /home/nanode/debug.log
sudo systemctl enable log-io-file.service 2>&1 | tee -a /home/nanode/debug.log


##Install crontab
		echo "Install crontab" 2>&1 | tee -a /home/nanode/debug.log
echo -e "\e[32mSetup crontab\e[0m"
crontab /home/nanode/Nanode/var/spool/cron/crontabs/nanode 2>&1 | tee -a /home/nanode/debug.log
echo -e "\e[32mSuccess\e[0m"

## Remove left over files from git clone actions
	echo "Remove left over files from git clone actions" 2>&1 | tee -a /home/nanode/debug.log
echo -e "\e[32mCleanup leftover directories\e[0m"
sudo rm -r /home/nanode/Nanode/ 2>&1 | tee -a /home/nanode/debug.log

##Change log in menu to 'main'
wget -O ~/.profile https://raw.githubusercontent.com/monero-ecosystem/Nanode/ubuntuServer-20.04/home/nanode/.profile 2>&1 | tee -a /home/nanode/debug.log

##End debug log
echo "
####################
" 2>&1 | tee -a /home/nanode/debug.log
echo "End ubuntu-install-continue.sh script $(date)" 2>&1 | tee -a /home/nanode/debug.log
echo "
####################
" 2>&1 | tee -a /home/nanode/debug.log

## Install complete
echo -e "\e[32mAll Installs complete\e[0m"
whiptail --title "Nanode Continue Install" --msgbox "Your Nanode is ready\n\nInstall complete. When you log in after the reboot use the menu to change your passwords and other features.\n\nEnjoy your Private Node\n\nSelect ok to reboot" 16 60
echo -e "\e[32m****************************************\e[0m"
echo -e "\e[32m****************************************\e[0m"
echo -e "\e[32m**********Nanode rebooting**********\e[0m"
echo -e "\e[32m**********Reminder:*********************\e[0m"
echo -e "\e[32m**********User: 'nanode'*************\e[0m"
echo -e "\e[32m**********Password: 'Nanode'**********\e[0m"
echo -e "\e[32m****************************************\e[0m"
echo -e "\e[32m****************************************\e[0m"
sudo reboot
