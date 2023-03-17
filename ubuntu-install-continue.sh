#!/bin/bash

##Open Sources:
# Monero github https://github.com/moneroexamples/monero-compilation/blob/master/README.md
# Monero Blockchain Explorer https://github.com/moneroexamples/onion-monero-blockchain-explorer
# Nanode scripts and custom files at my repo https://github.com/monero-ecosystem/Nanode
# PiVPN - OpenVPN server setup https://github.com/pivpn/pivpn

###Begin2

#shellcheck source=common.sh
. /home/nanode/common.sh

#Create debug file for handling install errors:
touch "$DEBUG_LOG"
{
	showtext "
	####################
	Start ubuntu-install-continue.sh script $(date)
	####################"
} 2>&1 | tee -a "$DEBUG_LOG"

whiptail --title "Nanode continues Ubuntu LTS Installer" --msgbox "Your Nanode is taking shape...\n\nThis next part will take ~80 minutes installing Monero and Nanode \n\nSelect ok to continue setup" 16 60
###Continue as 'nanode'

###Continue as 'nanode'
cd || exit 1
#showtext "Lock old user 'pi'"
sudo passwd --lock pi
showtext "User 'pi' Locked"
showtext "Lock old user 'ubuntu'"
sudo passwd --lock ubuntu
showtext "User 'ubuntu' Locked"

##Update and Upgrade system (This step repeated due to importance and maybe someone using this installer sript out-of-sequence)
showtext "Receiving and applying Ubuntu updates to the latest version"
{
	sudo apt-get update
	sudo apt-get --yes -o Dpkg::Options::="--force-confnew" upgrade
	sudo apt-get --yes -o Dpkg::Options::="--force-confnew" dist-upgrade
	sudo apt-get upgrade -y
} 2>&1 | tee -a "$DEBUG_LOG"

##Installing dependencies for --- Web Interface
showtext "Installing dependencies for --- Web Interface"
sudo apt-get install apache2 shellinabox php php-common avahi-daemon -y 2>&1 | tee -a "$DEBUG_LOG"
sudo usermod -a -G nanode www-data
##Installing dependencies for --- Monero
showtext "Installing dependencies for --- Monero"
sudo apt-get update
sudo apt-get install build-essential cmake pkg-config libssl-dev libzmq3-dev libunbound-dev libsodium-dev libunwind8-dev liblzma-dev libreadline6-dev libldns-dev libexpat1-dev libpgm-dev qttools5-dev-tools libhidapi-dev libusb-1.0-0-dev libprotobuf-dev protobuf-compiler libudev-dev libboost-chrono-dev libboost-date-time-dev libboost-filesystem-dev libboost-locale-dev libboost-program-options-dev libboost-regex-dev libboost-all-dev libboost-serialization-dev libboost-system-dev libboost-thread-dev ccache doxygen graphviz -y 2>&1 | tee -a "$DEBUG_LOG"
log "manual build of gtest for --- Monero"
{
cd /usr/src/gtest || exit 1
sudo apt-get install libgtest-dev -y
sudo cmake .
sudo make
sudo mv lib/libg* /usr/lib/
cd || exit 1
} 2>&1 | tee -a "$DEBUG_LOG"
##Installing dependencies for --- P2Pool
showtext "Installing dependencies for --- P2Pool"
sudo apt-get install git build-essential cmake libuv1-dev libzmq3-dev libsodium-dev libpgm-dev libnorm-dev libgss-dev -y


##Checking all dependencies are installed for --- miscellaneous (security tools-fail2ban-ufw, menu tool-dialog, screen, mariadb)
showtext "Checking all dependencies are installed for --- Miscellaneous"
{
sudo apt-get install git mariadb-client mariadb-server screen fail2ban ufw dialog jq libcurl4-openssl-dev libpthread-stubs0-dev cron -y
sudo apt-get install exfat-fuse exfat-utils -y
} 2>&1 | tee -a "$DEBUG_LOG"
#libcurl4-openssl-dev & libpthread-stubs0-dev for block-explorer

##Clone Nanode to device from git
showtext "Downloading Nanode files"
# Update Link
#git clone -b ubuntuServer-20.04 --single-branch https://github.com/monero-ecosystem/Nanode.git 2>&1 | tee -a "$DEBUG_LOG"


##Configure ssh security. Allows only user 'nanode'. Also 'root' login disabled via ssh, restarts config to make changes
showtext "Configuring SSH security"
{
sudo mv /home/nanode/Nanode/etc/ssh/sshd_config /etc/ssh/sshd_config
sudo chmod 644 /etc/ssh/sshd_config
sudo chown root /etc/ssh/sshd_config
sudo systemctl restart sshd.service
} 2>&1 | tee -a "$DEBUG_LOG"
showtext "SSH security config complete"


##Copy Nanode scripts to home folder
showtext "Moving Nanode scripts into position"
{
mv /home/nanode/Nanode/home/nanode/* /home/nanode/
mv /home/nanode/Nanode/home/nanode/.profile /home/nanode/
sudo chmod 777 -R /home/nanode/* #Read/write access needed by www-data to action php port, address customisation
} 2>&1 | tee -a "$DEBUG_LOG"
showtext "Success"

##Add Nanode systemd services
showtext "Add Nanode systemd services"
{
sudo mv /home/nanode/Nanode/etc/systemd/system/*.service /etc/systemd/system/
sudo chmod 644 /etc/systemd/system/*.service
sudo chown root /etc/systemd/system/*.service
sudo systemctl daemon-reload
sudo systemctl start moneroStatus.service
sudo systemctl enable moneroStatus.service
} 2>&1 | tee -a "$DEBUG_LOG"
showtext "Success"

showtext "Configure apache server for access to monero log file"
{
sudo mv /home/nanode/Nanode/etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf
sudo chmod 777 /etc/apache2/sites-enabled/000-default.conf
sudo chown root /etc/apache2/sites-enabled/000-default.conf
sudo /etc/init.d/apache2 restart
} 2>&1 | tee -a "$DEBUG_LOG"

showtext "Success"

##Setup local hostname
showtext "Setup local hostname"
{
sudo mv /home/nanode/Nanode/etc/avahi/avahi-daemon.conf /etc/avahi/avahi-daemon.conf
sudo /etc/init.d/avahi-daemon restart
} 2>&1 | tee -a "$DEBUG_LOG"

###Configure Web-UI
#showtext "Configure Web-UI"
## ???
#showtext "Success"

# ********************************************
# ******START OF MONERO SOURCE BULD******
# ********************************************
##Build Monero and Onion Blockchain Explorer (the simple but time comsuming bit)
#Download latest Monero release number
#ubuntu /dev/null odd requiremnt to set permissions
sudo chmod 666 /dev/null
RELEASE="$(curl -s https://raw.githubusercontent.com/monero-ecosystem/MoneroNanode/master/release.txt)"

showtext "Downloading Monero"

git clone --recursive https://github.com/monero-project/monero
showtext "Building Monero"
showtext "****************************************************"
showtext "****************************************************"
showtext "****This will take a while - Hardware Dependent*****"
showtext "****************************************************"
showtext "****************************************************"
cd monero && git submodule init && git submodule update
git checkout "$RELEASE"
git submodule sync && git submodule update
USE_SINGLE_BUILDDIR=1 make 2>&1 | tee -a "$DEBUG_LOG"
cd || exit 1
#Make dir .bitmonero to hold lmdb. Needs to be added before drive mounted to give mount point. Waiting for monerod to start fails mount.
mkdir .bitmonero 2>&1 | tee -a "$DEBUG_LOG"

showtext "Building Monero Blockchain Explore"
showtext "*******************************************************"
showtext "***This will take a few minutes - Hardware Dependent***"
showtext "*******************************************************"
log "Build Monero Onion Block Explorer"
{
git clone https://github.com/moneroexamples/onion-monero-blockchain-explorer.git
cd onion-monero-blockchain-explorer || exit 1
mkdir build
cd build || exit 1
cmake ..
make
cd || exit 1
} 2>&1 | tee -a "$DEBUG_LOG"

# ********************************************
# ********END OF MONERO SOURCE BULD **********
# ********************************************

showtext "Installing P2Pool"
{
git clone --recursive https://github.com/SChernykh/p2pool
cd p2pool || exit 1
git checkout tags/v2.2.1
mkdir build && cd build || exit 1
cmake ..
make -j2
} 2>&1 | tee -a "$DEBUG_LOG"
showtext "Success"

#Manage P2pool log file ia log rotate
{
sudo mv /home/nanode/Nanode/etc/logrotate.d/p2pool /etc/logrotate.d/p2pool
sudo chmod 644 /etc/logrotate.d/p2pool
sudo chown root /etc/logrotate.d/p2pool
} 2>&1 | tee -a "$DEBUG_LOG"

##Install log.io (Real-time service monitoring)
#Establish Device IP
DEVICE_IP=$(getip)
showtext "Installing log.io"

{
sudo apt-get install nodejs npm -y
sudo npm install -g log.io
sudo npm install -g log.io-file-input
mkdir -p ~/.log.io/inputs/
mv /home/nanode/Nanode/.log.io/inputs/file.json ~/.log.io/inputs/file.json
mv /home/nanode/Nanode/.log.io/server.json ~/.log.io/server.json
sed -i "s/127.0.0.1/$DEVICE_IP/g" ~/.log.io/server.json
sed -i "s/127.0.0.1/$DEVICE_IP/g" ~/.log.io/inputs/file.json
sudo systemctl start log-io-server.service
sudo systemctl start log-io-file.service
sudo systemctl enable log-io-server.service
sudo systemctl enable log-io-file.service
} 2>&1 | tee -a "$DEBUG_LOG"

##Install crontab
log "Install crontab"
showtext "Setup crontab"
crontab /home/nanode/Nanode/var/spool/cron/crontabs/nanode 2>&1 | tee -a "$DEBUG_LOG"
showtext "Success"

## Remove left over files from git clone actions
log "Remove left over files from git clone actions"
showtext "Cleanup leftover directories"
sudo rm -r /home/nanode/Nanode/ 2>&1 | tee -a "$DEBUG_LOG"

##Change log in menu to 'main'
#FIXME: change url
wget -O ~/.profile https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/ubuntuServer-20.04/home/nanode/.profile 2>&1 | tee -a "$DEBUG_LOG"

##End debug log
{
	showtext "
	####################
	End ubuntu-install-continue.sh script $(date)
	####################"
} 2>&1 | tee -a "$DEBUG_LOG"

## Install complete
showtext "All Installs complete"
whiptail --title "Nanode Continue Install" --msgbox "Your Nanode is ready\n\nInstall complete. When you log in after the reboot use the menu to change your passwords and other features.\n\nEnjoy your Private Node\n\nSelect ok to reboot" 16 60
showtext "****************************************"
showtext "****************************************"
showtext "**********Nanode rebooting**************"
showtext "**********Reminder:*********************"
showtext "**********User: 'nanode'****************"
showtext "**********Password: 'Nanode'************"
showtext "****************************************"
showtext "****************************************"
sudo reboot
