#!/bin/bash

#Error Log:
touch /home/pinodexmr/debug.log
echo "
####################
" 2>&1 | tee -a /home/pinodexmr/debug.log
echo "Start setup-update-monero.sh script $(date)" 2>&1 | tee -a /home/pinodexmr/debug.log
echo "
####################
" 2>&1 | tee -a /home/pinodexmr/debug.log

#Load boot status - condition the node was last run
. /home/pinodexmr/bootstatus.sh
#Import Variable: Light-mode true/false
. /home/pinodexmr/variables/light-mode.sh
echo "Light-Mode value is: $LIGHTMODE" >>/home/pinodexmr/debug.log

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

	##Configure temporary Swap file if needed (swap created is not persistant and only for compiling monero. It will unmount on reboot)
if (whiptail --title "PiNode-XMR Monero Updater" --yesno "For Monero to compile successfully 2GB of RAM is required.\n\nIf your device does not have 2GB RAM it can be artificially created with a swap file\n\nDo you have 2GB RAM on this device?\n\n* YES\n* NO - I do not have 2GB RAM (create a swap file)" 18 60); then
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


		#ubuntu /dev/null odd requiremnt to set permissions
		sudo chmod 666 /dev/null
		sleep 2

		#Stop Node to make system resources available.
		sudo systemctl stop blockExplorer.service
		sudo systemctl stop moneroPrivate.service
		sudo systemctl stop moneroMiningNode.service
		sudo systemctl stop moneroTorPrivate.service
		sudo systemctl stop moneroTorPublic.service
		sudo systemctl stop moneroPublicFree.service
		sudo systemctl stop moneroI2PPrivate.service
		sudo systemctl stop moneroCustomNode.service
		sudo systemctl stop moneroPublicRPCPay.service
		echo "Monero node stop command sent, allowing 30 seconds for safe shutdown"
		sleep "30"
		echo "Deleting Old Version"
		rm -rf /home/pinodexmr/monero/
		sleep "2"


if [[ $LIGHTMODE = FALSE ]]
then
# ********************************************
# ******START OF MONERO SOURCE BULD******
# ********************************************
echo "manual build of gtest for --- Monero" 2>&1 | tee -a /home/pinodexmr/debug.log
sudo apt-get install libgtest-dev -y 2>&1 | tee -a /home/pinodexmr/debug.log
cd /usr/src/gtest
sudo cmake .  2>&1 | tee -a /home/pinodexmr/debug.log
sudo make 2>&1 | tee -a /home/pinodexmr/debug.log
sudo mv lib/libg* /usr/lib/
cd
echo "Check dependencies installed for --- Monero" 2>&1 | tee -a /home/pinodexmr/debug.log
sudo apt-get update
sudo apt-get install build-essential cmake pkg-config libssl-dev libzmq3-dev libunbound-dev libsodium-dev libunwind8-dev liblzma-dev libreadline6-dev libldns-dev libexpat1-dev libpgm-dev qttools5-dev-tools libhidapi-dev libusb-1.0-0-dev libprotobuf-dev protobuf-compiler libudev-dev libboost-chrono-dev libboost-date-time-dev libboost-filesystem-dev libboost-locale-dev libboost-program-options-dev libboost-regex-dev libboost-all-dev libboost-serialization-dev libboost-system-dev libboost-thread-dev ccache doxygen graphviz -y 2>&1 | tee -a /home/pinodexmr/debug.log


echo -e "\e[32mDownloading Monero \e[0m"
sleep 2

git clone --recursive https://github.com/monero-project/monero
echo -e "\e[32mBuilding Monero \e[0m"
echo -e "\e[32m****************************************************\e[0m"
echo -e "\e[32m****************************************************\e[0m"
echo -e "\e[32m***This will take a while - Hardware Dependent***\e[0m"
echo -e "\e[32m****************************************************\e[0m"
echo -e "\e[32m****************************************************\e[0m"
sleep 10
cd monero && git submodule init && git submodule update
#fetch all Monero tagged releases, then list in reverse order and count=1 to only define the latest tag. 
git fetch --tags
RELEASE=$(git describe --tags `git rev-list --tags --max-count=1`)
git checkout $RELEASE -b latest
git submodule sync && git submodule update
USE_SINGLE_BUILDDIR=1 make 2>&1 | tee -a /home/pinodexmr/debug.log
cd
#Make dir .bitmonero to hold lmdb. Needs to be added before drive mounted to give mount point. Waiting for monerod to start fails mount.
mkdir .bitmonero 2>&1 | tee -a /home/pinodexmr/debug.log

# ********************************************
# ********END OF MONERO SOURCE BULD **********
# ********************************************

fi

if [[ $LIGHTMODE = TRUE ]]
then
	#********************************************
	#**********START OF Monero BINARY USE********
	#********************************************

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
			rm -R ~/temp/
		fi

	#********************************************
	#*******END OF Monero BINARY USE*******
	#********************************************

fi

#Make dir .bitmonero to hold lmdb. Needs to be added before drive mounted to give mount point. Waiting for monerod to start fails mount.
mkdir .bitmonero 2>&1 | tee -a /home/pinodexmr/debug.log
#Clean-up used downloaded files
rm -R ~/temp

		#Update system version number
		echo "#!/bin/bash
		CURRENT_VERSION=$NEW_VERSION" > /home/pinodexmr/current-ver.sh
		#cleanup old version number file
		rm /home/pinodexmr/xmr-new-ver.sh



#Define Restart Monero Node
		# Key - BOOT_STATUS
		# 2 = idle
		# 3 || 5 = private node || mining node
		# 4 = tor
		# 6 = Public RPC pay
		# 7 = Public free
		# 8 = I2P
		# 9 tor public
	if [ $BOOT_STATUS -eq 2 ]
then
		whiptail --title "Monero Update Complete" --msgbox "Update complete, Node ready for start. See web-ui at $(hostname -I) to select mode." 16 60
	fi

	if [ $BOOT_STATUS -eq 3 ]
then
		sudo systemctl start moneroPrivate.service
		whiptail --title "Monero Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi

	if [ $BOOT_STATUS -eq 4 ]
then
		sudo systemctl start moneroTorPrivate.service
		whiptail --title "Monero Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi		

	if [ $BOOT_STATUS -eq 5 ]
then
		sudo systemctl start moneroMiningNode.service
		whiptail --title "Monero Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi

	if [ $BOOT_STATUS -eq 6 ]
then
		sudo systemctl start moneroPublicRPCPay.service
		whiptail --title "Monero Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi

	if [ $BOOT_STATUS -eq 7 ]
then
		sudo systemctl start moneroPublicFree.service
		whiptail --title "Monero Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi

	if [ $BOOT_STATUS -eq 8 ]
then
		sudo systemctl start moneroI2PPrivate.service
		whiptail --title "Monero Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi

	if [ $BOOT_STATUS -eq 9 ]
then
		sudo systemctl start moneroTorPublic.service
		whiptail --title "Monero Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi

##End debug log
echo "Update Complete" 2>&1 | tee -a /home/pinodexmr/debug.log
sleep 5
echo "####################" 2>&1 | tee -a /home/pinodexmr/debug.log
echo "End setup-update-monero.sh script $(date)" 2>&1 | tee -a /home/pinodexmr/debug.log
echo "####################" 2>&1 | tee -a /home/pinodexmr/debug.log

./setup.sh
