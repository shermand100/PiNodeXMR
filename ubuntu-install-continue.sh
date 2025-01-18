#!/bin/bash

##Open Sources:
# Monero github https://github.com/moneroexamples/monero-compilation/blob/master/README.md
# Monero Blockchain Explorer https://github.com/moneroexamples/onion-monero-blockchain-explorer
# PiNode-XMR scripts and custom files at my repo https://github.com/shermand100/PiNodeXMR
# PiVPN - OpenVPN server setup https://github.com/pivpn/pivpn
# Atomic Swaps - https://github.com/AthanorLabs/atomic-swap
# P2Pool - https://github.com/SChernykh/p2pool
# ATS Fan controller - https://github.com/tuxd3v/ats#credits

###Begin2

#Create debug file for handling install errors:
touch /home/pinodexmr/debug.log
echo "
####################
" 2>&1 | tee -a /home/pinodexmr/debug.log
echo "Start ubuntu-install-continue.sh script $(date)" 2>&1 | tee -a /home/pinodexmr/debug.log
echo "
####################
" 2>&1 | tee -a /home/pinodexmr/debug.log

#Establish OS 32 or 64 bit
CPU_ARCH=`getconf LONG_BIT`
echo "OS getconf LONG_BIT $CPU_ARCH" >> /home/pinodexmr/debug.log
if [[ $CPU_ARCH -eq 64 ]]
then
  echo "ARCH: 64-bit"
elif [[ $CPU_ARCH -eq 32 ]]
then
  echo "ARCH: 32-bit"
else
  echo "OS Unknown"
fi
sleep 3

whiptail --title "PiNode-XMR Continue Ubuntu LTS Installer" --msgbox "Your PiNode-XMR is taking shape...\n\nThis next part will take ~80 minutes installing Monero and PiNodeXMR \n\nSelect ok to continue setup" 16 60
###Continue as 'pinodexmr'

##Configure temporary Swap file if needed (swap created is not persistant and only for compiling monero. It will unmount on reboot)
if (whiptail --title "PiNode-XMR Ubuntu Installer" --yesno "For Monero to compile successfully 2GB of RAM is required.\n\nIf your device does not have 2GB RAM it can be artificially created with a swap file\n\nDo you have 2GB RAM on this device?\n\n* YES\n* NO - I do not have 2GB RAM (create a swap file)" 18 60); then
	echo -e "\e[32mSwap file unchanged\e[0m"
	sleep 3
		else
			sudo fallocate -l 2G /swapfile 2>&1 | tee -a /home/pinodexmr/debug.log
			sudo chmod 600 /swapfile 2>&1 | tee -a /home/pinodexmr/debug.log
			sudo mkswap /swapfile 2>&1 | tee -a /home/pinodexmr/debug.log
			sudo swapon /swapfile 2>&1 | tee -a /home/pinodexmr/debug.log
			echo -e "\e[32mSwap file of 2GB Configured and enabled\e[0m"
			free -h
			sleep 3
fi

##Hardware configure: Many features and builds only work with 64bit OS/Hardware, but we dont want to exclude older 32bit devices. Configure vaiable $LIGHTMODE for core node functions.
if [[ $CPU_ARCH -eq 64 ]]
then
if (whiptail --title "PiNode-XMR Ubuntu Installer" --yesno "This installer has detected you are running a 64bit OS. This means you can run PiNodeXMR with all features. If however you would prefer to run PiNodeXMR in 'light mode' with only core node functions you may select that option here" --no-button "PiNodeXMR Light" --yes-button "PiNodeXMR Full" 18 60); then
	LIGHTMODE=FALSE
		else
			LIGHTMODE=TRUE
fi
elif [[ $CPU_ARCH -eq 32 ]]
then
if (whiptail --title "PiNode-XMR Ubuntu Installer" --yesno "This installer has detected you are running a 32bit OS. This means you can run PiNodeXMR in 'light mode' with only core node functions. If you believe this is incorrect you can select the Full installer below but it is not recommended. Note: P2Pool is not available for 32bit devices" --no-button "PiNodeXMR Full" --yes-button "PiNodeXMR Light" 18 60); then
	LIGHTMODE=TRUE
		else
			LIGHTMODE=FALSE
fi
else
if (whiptail --title "PiNode-XMR Ubuntu Installer" --yesno "This installer cannot detect if you are using 32/64bit Hardware/OS. You may select below to either use PiNodeXMR Full with all features for 64bit devices or PiNodeXMR Light with only core node functions" --no-button "PiNodeXMR Light" --yes-button "PiNodeXMR Full" 18 60); then
	LIGHTMODE=FALSE
		else
			LIGHTMODE=TRUE
fi
fi
sleep 3


###Continue as 'pinodexmr'
cd
echo -e "\e[32mLock old user 'pi'\e[0m"
sleep 2
sudo passwd --lock pi
echo -e "\e[32mUser 'pi' Locked\e[0m"
sleep 3
echo -e "\e[32mLock old user 'ubuntu'\e[0m"
sleep 2
sudo passwd --lock ubuntu
echo -e "\e[32mUser 'ubuntu' Locked\e[0m"
sleep 3

##Update and Upgrade system (This step repeated due to importance and maybe someone using this installer sript out-of-sequence)
echo -e "\e[32mReceiving and applying Ubuntu updates to latest versions\e[0m"
sleep 3
sudo apt-get update 2>&1 | tee -a /home/pinodexmr/debug.log
sudo apt-get --yes -o Dpkg::Options::="--force-confnew" upgrade 2>&1 | tee -a /home/pinodexmr/debug.log
sudo apt-get --yes -o Dpkg::Options::="--force-confnew" dist-upgrade 2>&1 | tee -a /home/pinodexmr/debug.log
sudo apt-get upgrade -y 2>&1 | tee -a /home/pinodexmr/debug.log

##Installing dependencies for --- Web Interface
	echo "Installing dependencies for --- Web Interface" 2>&1 | tee -a /home/pinodexmr/debug.log
echo -e "\e[32mInstalling dependencies for --- Web Interface\e[0m"
sleep 3
sudo apt-get install apache2 shellinabox php php-common avahi-daemon -y 2>&1 | tee -a /home/pinodexmr/debug.log
sudo usermod -a -G pinodexmr www-data
sleep 3

if [[ $LIGHTMODE = FALSE ]]
then
  echo "ARCH: 64-bit"
##Installing dependencies for --- Monero
	echo "Installing dependencies for --- Monero" 2>&1 | tee -a /home/pinodexmr/debug.log
echo -e "\e[32mInstalling dependencies for --- Monero\e[0m"
sleep 3
sudo apt-get update
sudo apt-get install build-essential cmake pkg-config libssl-dev libzmq3-dev libunbound-dev libsodium-dev libunwind8-dev liblzma-dev libreadline6-dev libldns-dev libexpat1-dev libpgm-dev qttools5-dev-tools libhidapi-dev libusb-1.0-0-dev libprotobuf-dev protobuf-compiler libudev-dev libboost-chrono-dev libboost-date-time-dev libboost-filesystem-dev libboost-locale-dev libboost-program-options-dev libboost-regex-dev libboost-all-dev libboost-serialization-dev libboost-system-dev libboost-thread-dev ccache doxygen graphviz -y 2>&1 | tee -a /home/pinodexmr/debug.log
sleep 2
	echo "manual build of gtest for --- Monero" 2>&1 | tee -a /home/pinodexmr/debug.log
sudo apt-get install libgtest-dev -y 2>&1 | tee -a /home/pinodexmr/debug.log
cd /usr/src/gtest
sudo cmake . 2>&1 | tee -a /home/pinodexmr/debug.log
sudo make
sudo mv lib/libg* /usr/lib/
cd
##Installing dependencies for --- P2Pool
	echo "Installing dependencies for --- P2Pool" 2>&1 | tee -a /home/pinodexmr/debug.log
sudo apt-get install git build-essential cmake libuv1-dev libzmq3-dev libsodium-dev libpgm-dev libnorm-dev libgss-dev -y
sleep 2
fi


##Checking all dependencies are installed for --- miscellaneous (security tools-fail2ban-ufw, menu tool-dialog, screen, mariadb)
	echo "Installing dependencies for --- miscellaneous" 2>&1 | tee -a /home/pinodexmr/debug.log
echo -e "\e[32mChecking all dependencies are installed for --- Miscellaneous\e[0m"
sleep 3
sudo apt-get install git mariadb-client mariadb-server screen fail2ban ufw dialog jq libcurl4-openssl-dev libpthread-stubs0-dev cron -y 2>&1 | tee -a /home/pinodexmr/debug.log
sudo apt-get install exfat-fuse exfat-utils -y 2>&1 | tee -a /home/pinodexmr/debug.log
#libcurl4-openssl-dev & libpthread-stubs0-dev for block-explorer
sleep 3

##Clone PiNode-XMR to device from git
	echo "Clone PiNode-XMR to device from git" 2>&1 | tee -a /home/pinodexmr/debug.log
echo -e "\e[32mDownloading PiNode-XMR files\e[0m"
sleep 3
git clone --single-branch https://github.com/shermand100/PiNodeXMR.git 2>&1 | tee -a /home/pinodexmr/debug.log


##Configure ssh security. Allows only user 'pinodexmr'. Also 'root' login disabled via ssh, restarts config to make changes
	echo "Configure ssh security" 2>&1 | tee -a /home/pinodexmr/debug.log
echo -e "\e[32mConfiguring SSH security\e[0m"
sleep 3
sudo mv /home/pinodexmr/PiNodeXMR/etc/ssh/sshd_config /etc/ssh/sshd_config 2>&1 | tee -a /home/pinodexmr/debug.log
sudo chmod 644 /etc/ssh/sshd_config 2>&1 | tee -a /home/pinodexmr/debug.log
sudo chown root /etc/ssh/sshd_config 2>&1 | tee -a /home/pinodexmr/debug.log
sudo /etc/init.d/ssh restart 2>&1 | tee -a /home/pinodexmr/debug.log
echo -e "\e[32mSSH security config complete\e[0m"
sleep 3


##Copy PiNode-XMR scripts to home folder
echo -e "\e[32mMoving PiNode-XMR scripts into position\e[0m"
sleep 3
mv /home/pinodexmr/PiNodeXMR/home/pinodexmr/* /home/pinodexmr/ 2>&1 | tee -a /home/pinodexmr/debug.log
mv /home/pinodexmr/PiNodeXMR/home/pinodexmr/.profile /home/pinodexmr/ 2>&1 | tee -a /home/pinodexmr/debug.log
sudo chmod 777 -R /home/pinodexmr/* 2>&1 | tee -a /home/pinodexmr/debug.log #Read/write access needed by www-data to action php port, address customisation
echo -e "\e[32mSuccess\e[0m"
sleep 3

##Add PiNode-XMR systemd services
	echo "Add PiNode-XMR systemd services" 2>&1 | tee -a /home/pinodexmr/debug.log
echo -e "\e[32mAdd PiNode-XMR systemd services\e[0m"
sleep 3
sudo mv /home/pinodexmr/PiNodeXMR/etc/systemd/system/*.service /etc/systemd/system/ 2>&1 | tee -a /home/pinodexmr/debug.log
sudo chmod 644 /etc/systemd/system/*.service 2>&1 | tee -a /home/pinodexmr/debug.log
sudo chown root /etc/systemd/system/*.service 2>&1 | tee -a /home/pinodexmr/debug.log
sudo systemctl daemon-reload 2>&1 | tee -a /home/pinodexmr/debug.log
sudo systemctl start moneroStatus.service 2>&1 | tee -a /home/pinodexmr/debug.log
sudo systemctl enable moneroStatus.service 2>&1 | tee -a /home/pinodexmr/debug.log
echo -e "\e[32mSuccess\e[0m"
sleep 3

#Configure apache server for access to monero log file
sudo mv /home/pinodexmr/PiNodeXMR/etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf 2>&1 | tee -a /home/pinodexmr/debug.log
sudo chmod 777 /etc/apache2/sites-enabled/000-default.conf 2>&1 | tee -a /home/pinodexmr/debug.log
sudo chown root /etc/apache2/sites-enabled/000-default.conf 2>&1 | tee -a /home/pinodexmr/debug.log
sudo /etc/init.d/apache2 restart 2>&1 | tee -a /home/pinodexmr/debug.log

echo -e "\e[32mSuccess\e[0m"
sleep 3

##Setup local hostname
	echo "Setup local hostname" 2>&1 | tee -a /home/pinodexmr/debug.log
sudo mv /home/pinodexmr/PiNodeXMR/etc/avahi/avahi-daemon.conf /etc/avahi/avahi-daemon.conf 2>&1 | tee -a /home/pinodexmr/debug.log
sudo /etc/init.d/avahi-daemon restart 2>&1 | tee -a /home/pinodexmr/debug.log

##Configure Web-UI
	echo "Configure Web-UI" 2>&1 | tee -a /home/pinodexmr/debug.log
sleep 3
if [[ $LIGHTMODE = TRUE ]]
then
#First move hidden file specifically .htaccess file then entire directory
sudo mv /home/pinodexmr/PiNodeXMR/HTML/.htaccess /var/www/html/ 2>&1 | tee -a /home/pinodexmr/debug.log
sudo rsync -a /home/pinodexmr/PiNodeXMR/HTML/* /var/www/html/ 2>&1 | tee -a /home/pinodexmr/debug.log
sudo rsync -a /home/pinodexmr/PiNodeXMR/HTML-LIGHT/*.html /var/www/html/ 2>&1 | tee -a /home/pinodexmr/debug.log
sudo chown www-data -R /var/www/html/ 2>&1 | tee -a /home/pinodexmr/debug.log
sudo chmod 777 -R /var/www/html/ 2>&1 | tee -a /home/pinodexmr/debug.log
else
#First move hidden file specifically .htaccess file then entire directory
sudo mv /home/pinodexmr/PiNodeXMR/HTML/.htaccess /var/www/html/ 2>&1 | tee -a /home/pinodexmr/debug.log
sudo rsync -a /home/pinodexmr/PiNodeXMR/HTML/* /var/www/html/ 2>&1 | tee -a /home/pinodexmr/debug.log
sudo chown www-data -R /var/www/html/ 2>&1 | tee -a /home/pinodexmr/debug.log
sudo chmod 777 -R /var/www/html/ 2>&1 | tee -a /home/pinodexmr/debug.log
fi

echo -e "\e[32mSuccess\e[0m"

if [[ $LIGHTMODE = FALSE ]]
then
# ********************************************
# ******START OF MONERO SOURCE BULD******
# ********************************************
##Build Monero and Onion Blockchain Explorer (the simple but time comsuming bit)
	#Download latest Monero release number
#ubuntu /dev/null odd requiremnt to set permissions
sudo chmod 666 /dev/null
sleep 3
wget -q https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/release.sh -O /home/pinodexmr/release.sh
chmod 755 /home/pinodexmr/release.sh
. /home/pinodexmr/release.sh

echo -e "\e[32mDownloading Monero \e[0m"
sleep 3

git clone --recursive https://github.com/monero-project/monero
echo -e "\e[32mBuilding Monero \e[0m"
echo -e "\e[32m****************************************************\e[0m"
echo -e "\e[32m****************************************************\e[0m"
echo -e "\e[32m***This will take a while - Hardware Dependent***\e[0m"
echo -e "\e[32m****************************************************\e[0m"
echo -e "\e[32m****************************************************\e[0m"
sleep 10
cd monero && git submodule init && git submodule update
git checkout $RELEASE
git submodule sync && git submodule update
USE_SINGLE_BUILDDIR=1 make 2>&1 | tee -a /home/pinodexmr/debug.log
cd
#Make dir .bitmonero to hold lmdb. Needs to be added before drive mounted to give mount point. Waiting for monerod to start fails mount.
mkdir .bitmonero 2>&1 | tee -a /home/pinodexmr/debug.log

echo -e "\e[32mBuilding Monero Blockchain Explorer[0m"
echo -e "\e[32m*******************************************************\e[0m"
echo -e "\e[32m***This will take a few minutes - Hardware Dependent***\e[0m"
echo -e "\e[32m*******************************************************\e[0m"
sleep 10
		echo "Build Monero Onion Block Explorer" 2>&1 | tee -a /home/pinodexmr/debug.log
git clone https://github.com/moneroexamples/onion-monero-blockchain-explorer.git 2>&1 | tee -a /home/pinodexmr/debug.log
cd onion-monero-blockchain-explorer
mkdir build
cd build
cmake .. 2>&1 | tee -a /home/pinodexmr/debug.log
make 2>&1 | tee -a /home/pinodexmr/debug.log
cd
rm ~/release.sh

# ********************************************
# ********END OF MONERO SOURCE BULD **********
# ********************************************
fi

if [[ $LIGHTMODE = TRUE ]]
then
# #********************************************
# #**********START OF Monero BINARY USE********
# #********************************************

#Define Install Monero function to reduce repeat script
function f_installMonero {
echo "Downloading pre-built Monero from get.monero" 2>&1 | tee -a /home/pinodexmr/debug.log
#Make standard location for Monero
mkdir -p ~/monero/build/release/bin
if [[ $CPU_ARCH -eq 64 ]]
then
  #Download 64-bit Monero
wget https://downloads.getmonero.org/cli/linuxarm8
#Make temp folder to extract binaries
mkdir temp && tar -xvf linuxarm8 -C ~/temp
#Move Monerod files to standard location
mv /home/pinodexmr/temp/monero-aarch64-linux-gnu-v0.18*/monero* /home/pinodexmr/monero/build/release/bin/
rm linuxarm8
rm -R /home/pinodexmr/temp/
else
  #Download 32-bit Monero
wget https://downloads.getmonero.org/cli/linuxarm7
#Make temp folder to extract binaries
mkdir temp && tar -xvf linuxarm7 -C ~/temp
#Move Monerod files to standard location
mv /home/pinodexmr/temp/monero-arm-linux-gnueabihf-v0.18*/monero* /home/pinodexmr/monero/build/release/bin/
rm linuxarm7
rm -R /home/pinodexmr/temp/
fi
#Make dir .bitmonero to hold lmdb. Needs to be added before drive mounted to give mount point. Waiting for monerod to start fails mount.
mkdir .bitmonero 2>&1 | tee -a /home/pinodexmr/debug.log
#Clean-up used downloaded files
rm -R ~/temp
}


if [[ $CPU_ARCH -ne 64 ]] && [[ $CPU_ARCH -ne 32 ]]
then
  if (whiptail --title "OS version" --yesno "I've tried to auto-detect what version of Monero you need based on your OS but I've not been successful.\n\nPlease select your OS architecture..." 8 78 --no-button "32-bit" --yes-button "64-bit"); then
    CPU_ARCH=64
	f_installMonero
	else
    CPU_ARCH=32
	f_installMonero
  fi
else
 f_installMonero
fi

# #********************************************
# #*******END OF Monero BINARY USE*******
# #********************************************
fi

if [ $LIGHTMODE = FALSE ]
then
	##Install P2Pool (Not available on 32 bit systems)
	if [ $CPU_ARCH -eq 32 ]
	then
	echo -e "\e[33m*********************************************\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
	echo -e "\e[33m*********** ARCH: 32-bit detected ***********\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
	echo -e "\e[33m********** P2Pool Cannot be built ***********\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
	echo -e "\e[33m*********** ARCH: 64-bit required ***********\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
	echo -e "\e[33m*********** SKIPPING P2Pool build ***********\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
	echo -e "\e[33m*********************************************\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
	echo "Install resuming in 20 seconds" 2>&1 | tee -a /home/pinodexmr/debug.log
	sleep "10"
	echo "Install resuming in 10 seconds" 2>&1 | tee -a /home/pinodexmr/debug.log
	sleep "5"
	echo "Install resuming in 5 seconds" 2>&1 | tee -a /home/pinodexmr/debug.log
	sleep "5"
	else
	echo -e "\e[32mInstalling P2Pool\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
	git clone --recursive https://github.com/SChernykh/p2pool 2>&1 | tee -a /home/pinodexmr/debug.log
	cd p2pool
	git checkout tags/v4.3
	mkdir build && cd build
	cmake .. 2>&1 | tee -a /home/pinodexmr/debug.log
	make -j2 2>&1 | tee -a /home/pinodexmr/debug.log
	echo -e "\e[32mSuccess\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
	sleep 3

	#Manage P2pool log file ia log rotate
	sudo mv /home/pinodexmr/PiNodeXMR/etc/logrotate.d/p2pool /etc/logrotate.d/p2pool 2>&1 | tee -a /home/pinodexmr/debug.log
	sudo chmod 644 /etc/logrotate.d/p2pool 2>&1 | tee -a /home/pinodexmr/debug.log
	sudo chown root /etc/logrotate.d/p2pool 2>&1 | tee -a /home/pinodexmr/debug.log
	fi
fi

if [ $LIGHTMODE = FALSE ]
then
	##Install Atomic Swap (Not available on 32 bit systems)
	if [ $CPU_ARCH -eq 32 ]
	then
	echo -e "\e[33m*********************************************\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
	echo -e "\e[33m*********** ARCH: 32-bit detected ***********\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
	echo -e "\e[33m******* Atomic Swap Cannot be built *********\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
	echo -e "\e[33m*********** ARCH: 64-bit required ***********\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
	echo -e "\e[33m******** SKIPPING Atomic Swap build *********\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
	echo -e "\e[33m*********************************************\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
	echo "Install resuming in 20 seconds" 2>&1 | tee -a /home/pinodexmr/debug.log
	sleep "10"
	echo "Install resuming in 10 seconds" 2>&1 | tee -a /home/pinodexmr/debug.log
	sleep "5"
	echo "Install resuming in 5 seconds" 2>&1 | tee -a /home/pinodexmr/debug.log
	sleep "5"
	else
	echo -e "\e[32mInstalling Atomic Swap\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
	#Install Go 1.20 for compatability
	sudo apt install snapd -y
	sudo snap install --classic --channel=1.20/stable go
	#clone Atomic Swap
	git clone https://github.com/athanorlabs/atomic-swap.git 2>&1 | tee -a /home/pinodexmr/debug.log
	cd atomic-swap
	#make Atomic Swap
	make build-release 2>&1 | tee -a /home/pinodexmr/debug.log
	cd
	mkdir .atomicswap
	sudo chmod 777 -R /home/pinodexmr/.atomicswap/
	echo -e "\e[32mSuccess\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
	sleep 3

	fi
fi

##Install log.io (Real-time service monitoring)
#Establish Device IP
. ~/variables/deviceIp.sh
echo -e "\e[32mInstalling log.io\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
sudo apt-get install nodejs npm -y 2>&1 | tee -a /home/pinodexmr/debug.log
sudo npm install -g log.io 2>&1 | tee -a /home/pinodexmr/debug.log
sudo npm install -g log.io-file-input 2>&1 | tee -a /home/pinodexmr/debug.log
mkdir -p ~/.log.io/inputs/ 2>&1 | tee -a /home/pinodexmr/debug.log
mv /home/pinodexmr/PiNodeXMR/.log.io/inputs/file.json ~/.log.io/inputs/file.json 2>&1 | tee -a /home/pinodexmr/debug.log
mv /home/pinodexmr/PiNodeXMR/.log.io/server.json ~/.log.io/server.json 2>&1 | tee -a /home/pinodexmr/debug.log
sed -i "s/127.0.0.1/$DEVICE_IP/g" ~/.log.io/server.json 2>&1 | tee -a /home/pinodexmr/debug.log
sed -i "s/127.0.0.1/$DEVICE_IP/g" ~/.log.io/inputs/file.json 2>&1 | tee -a /home/pinodexmr/debug.log
sudo systemctl start log-io-server.service 2>&1 | tee -a /home/pinodexmr/debug.log
sudo systemctl start log-io-file.service 2>&1 | tee -a /home/pinodexmr/debug.log
sudo systemctl enable log-io-server.service 2>&1 | tee -a /home/pinodexmr/debug.log
sudo systemctl enable log-io-file.service 2>&1 | tee -a /home/pinodexmr/debug.log


##Install crontab
		echo "Install crontab" 2>&1 | tee -a /home/pinodexmr/debug.log
echo -e "\e[32mSetup crontab\e[0m"
sleep 3
crontab /home/pinodexmr/PiNodeXMR/var/spool/cron/crontabs/pinodexmr 2>&1 | tee -a /home/pinodexmr/debug.log
echo -e "\e[32mSuccess\e[0m"
sleep 3

##Set Swappiness lower
		echo "Set RAM Swappiness lower" 2>&1 | tee -a /home/pinodexmr/debug.log
sudo sysctl vm.swappiness=10 2>&1 | tee -a /home/pinodexmr/debug.log

## Remove left over files from git clone actions
	echo "Remove left over files from git clone actions" 2>&1 | tee -a /home/pinodexmr/debug.log
echo -e "\e[32mCleanup leftover directories\e[0m"
sleep 3
sudo rm -r /home/pinodexmr/PiNodeXMR/ 2>&1 | tee -a /home/pinodexmr/debug.log

##Change log in menu to 'main'
wget -O ~/.profile https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/home/pinodexmr/.profile 2>&1 | tee -a /home/pinodexmr/debug.log

#Write value of LIGHTMODE variable
	echo "#!/bin/sh
LIGHTMODE=${LIGHTMODE}" > /home/pinodexmr/variables/light-mode.sh

##End debug log
echo "
####################
" 2>&1 | tee -a /home/pinodexmr/debug.log
echo "End ubuntu-install-continue.sh script $(date)" 2>&1 | tee -a /home/pinodexmr/debug.log
echo "
####################
" 2>&1 | tee -a /home/pinodexmr/debug.log

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
