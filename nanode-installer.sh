#!/bin/bash

##Open Sources:
# Web-UI by designmodo Flat-UI free project at https://github.com/designmodo/Flat-UI
# Monero github https://github.com/moneroexamples/monero-compilation/blob/master/README.md
# Monero Blockchain Explorer https://github.com/moneroexamples/onion-monero-blockchain-explorer
# Nanode scripts and custom files at my repo https://github.com/shermand100/pinode-xmr
# PiVPN - OpenVPN server setup https://github.com/pivpn/pivpn

#shellcheck source=home/nanode/common.sh
. home/nanode/common.sh

check_connection || (showtext "NO CONNECTION -- aborting"; exit 1)

##Create new user 'nanode'
showtext "Creating user 'nanode'..."
adduser nanode --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password

#Set nanode password 'Nanode'
echo "nanode:Nanode" | chpasswd
showtext "nanode password changed to 'Nanode'"

##Change system hostname to Nanode
showtext "Changing system hostname to 'Nanode'..."
echo 'Nanode' | tee /etc/hostname
#sed -i '6d' /etc/hosts
echo '127.0.0.1       Nanode' | tee -a /etc/hosts
hostname Nanode

##Disable IPv6 (confuses Monero start script if IPv6 is present)
showtext "Disabling IPv6..."
echo 'net.ipv6.conf.all.disable_ipv6 = 1' | tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.default.disable_ipv6 = 1' | tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.lo.disable_ipv6 = 1' | tee -a /etc/sysctl.conf

##Perform system update and upgrade now. This then allows for reboot before next install step, preventing warnings about kernal upgrades when installing the new packages (dependencies).
#setup debug file to track errors
showtext "Creating Debug log..."
touch "$DEBUG_LOG"
chown nanode "$DEBUG_LOG"
chmod 777 "$DEBUG_LOG"

##Update and Upgrade system
showtext "Downloading and installing OS updates..."
{
apt-get update
apt-get --yes -o Dpkg::Options::="--force-confnew" upgrade
apt-get --yes -o Dpkg::Options::="--force-confnew" dist-upgrade
apt-get upgrade -y -o Dpkg::Options::="--force-confnew"
##Auto remove any obsolete packages
apt-get autoremove -y 2>&1 | tee -a "$DEBUG_LOG"
} 2>&1 | tee -a "$DEBUG_LOG"

###Begin2

#showtext "Lock old user 'pi'"
passwd --lock pi
showtext "User 'pi' Locked"

##Update and Upgrade system (This step repeated due to importance and maybe someone using this installer sript out-of-sequence)
showtext "Verifying Update..."
{
	apt-get update
	apt-get --yes -o Dpkg::Options::="--force-confnew" upgrade
	apt-get --yes -o Dpkg::Options::="--force-confnew" dist-upgrade
	apt-get upgrade -y
} 2>&1 | tee -a "$DEBUG_LOG"

##Installing dependencies for --- Web Interface
showtext "Installing dependencies for Web Interface..."
apt-get install apache2 shellinabox php php-common avahi-daemon -y 2>&1 | tee -a "$DEBUG_LOG"
usermod -a -G nanode www-data
##Installing dependencies for --- Monero
# showtext "Installing dependencies for --- Monero"
# apt-get update
apt-get install build-essential cmake pkg-config libssl-dev libzmq3-dev libunbound-dev libsodium-dev libunwind8-dev liblzma-dev libreadline6-dev libldns-dev libexpat1-dev libpgm-dev qttools5-dev-tools libhidapi-dev libusb-1.0-0-dev libprotobuf-dev protobuf-compiler libudev-dev libboost-chrono-dev libboost-date-time-dev libboost-filesystem-dev libboost-locale-dev libboost-program-options-dev libboost-regex-dev libboost-all-dev libboost-serialization-dev libboost-system-dev libboost-thread-dev ccache doxygen graphviz -y 2>&1 | tee -a "$DEBUG_LOG"
log "manual build of gtest for --- Monero"
{
cd /usr/src/gtest || exit 1
apt-get install libgtest-dev -y
cmake .
make
mv lib/libg* /usr/lib/
cd || exit 1
} 2>&1 | tee -a "$DEBUG_LOG"

##Checking all dependencies are installed for --- miscellaneous (security tools-fail2ban-ufw, menu tool-dialog, screen, mariadb)
showtext "Checking all dependencies are installed..."
{
apt-get install git mariadb-client mariadb-server screen fail2ban ufw dialog jq libcurl4-openssl-dev libpthread-stubs0-dev cron -y
apt-get install exfat-fuse exfat-utils -y
} 2>&1 | tee -a "$DEBUG_LOG"
#libcurl4-openssl-dev & libpthread-stubs0-dev for block-explorer

##Clone Nanode to device from git
showtext "Downloading Nanode files..."
# Update Link
#git clone -b ubuntuServer-20.04 --single-branch https://github.com/monero-ecosystem/Nanode.git 2>&1 | tee -a "$DEBUG_LOG"


##Configure ssh security. Allows only user 'nanode'. Also 'root' login disabled via ssh, restarts config to make changes
showtext "Configuring SSH security..."
{
chmod 644 /etc/ssh/sshd_config
chown root /etc/ssh/sshd_config
systemctl restart sshd.service
} 2>&1 | tee -a "$DEBUG_LOG"
showtext "SSH security config complete"


##Copy Nanode scripts to home folder
showtext "Moving Nanode scripts into position..."
{
mv /home/nanode/Nanode/home/nanode/* /home/nanode/
mv /home/nanode/Nanode/home/nanode/.profile /home/nanode/
chmod 777 -R /home/nanode/* #Read/write access needed by www-data to action php port, address customisation
} 2>&1 | tee -a "$DEBUG_LOG"
showtext "Success"

##Add Nanode systemd services
showtext "Addding Nanode systemd services..."
{
mv /home/nanode/Nanode/etc/systemd/system/*.service /etc/systemd/system/
chmod 644 /etc/systemd/system/*.service
chown root /etc/systemd/system/*.service
systemctl daemon-reload
systemctl start moneroStatus.service
systemctl enable moneroStatus.service
} 2>&1 | tee -a "$DEBUG_LOG"
showtext "Success"

showtext "Configuring apache server for access to Monero log file..."
{
mv /home/nanode/Nanode/etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf
chmod 777 /etc/apache2/sites-enabled/000-default.conf
chown root /etc/apache2/sites-enabled/000-default.conf
/etc/init.d/apache2 restart
} 2>&1 | tee -a "$DEBUG_LOG"

showtext "Success"

##Setup local hostname
showtext "Setting up local hostname..."
{
mv /home/nanode/Nanode/etc/avahi/avahi-daemon.conf /etc/avahi/avahi-daemon.conf
/etc/init.d/avahi-daemon restart
} 2>&1 | tee -a "$DEBUG_LOG"

showtext "Setting up SSD..."

bash ./setup-drive.sh

showtext "Downloading Monero..."
# Install monero for the first time
bash ./update-monero.sh

showtext "Downloading Block Explorer..."
# Install monero block explorer for the first time
bash ./update-explorer.sh

##Install log.io (Real-time service monitoring)
#Establish Device IP
DEVICE_IP=$(getip)
showtext "Installing log.io..."

{
apt-get install nodejs npm -y
npm install -g log.io
npm install -g log.io-file-input
mkdir -p ~/.log.io/inputs/
mv /home/nanode/Nanode/.log.io/inputs/file.json ~/.log.io/inputs/file.json
mv /home/nanode/Nanode/.log.io/server.json ~/.log.io/server.json
sed -i "s/127.0.0.1/$DEVICE_IP/g" ~/.log.io/server.json
sed -i "s/127.0.0.1/$DEVICE_IP/g" ~/.log.io/inputs/file.json
systemctl start log-io-server.service
systemctl start log-io-file.service
systemctl enable log-io-server.service
systemctl enable log-io-file.service
} 2>&1 | tee -a "$DEBUG_LOG"

##Install crontab
showtext "Setting up crontab..."
crontab var/spool/cron/crontabs/nanode 2>&1 | tee -a "$DEBUG_LOG"
showtext "Success"

## Remove left over files from git clone actions
showtext "Deleting leftover directories..."
rm -r /home/nanode/Nanode/ 2>&1 | tee -a "$DEBUG_LOG"

##End debug log
{
	showtext "
	####################
	End ubuntu-install-continue.sh script $(date)
	####################"
} 2>&1 | tee -a "$DEBUG_LOG"

showtext "Move home contents"
cp -r home/nanode/* /home/nanode/
cp -r etc/* /etc/
cp -r HTML/* /var/www/html/

## Install complete
showtext "Installation Complete"
