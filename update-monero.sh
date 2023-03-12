#!/bin/bash

#Error Log:
touch /home/nanode/debug.log
echo "
####################
" 2>&1 | tee -a /home/nanode/debug.log
echo "Start setup-update-monero.sh script $(date)" 2>&1 | tee -a /home/nanode/debug.log
echo "
####################
" 2>&1 | tee -a /home/nanode/debug.log

#Download variable for current monero release version
wget -q https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/master/release.sh -O /home/nanode/release.sh
#Permission Setting
chmod 755 /home/nanode/release.sh
#Load boot status - condition the node was last run
. /home/nanode/bootstatus.sh
#Load Variables
. /home/nanode/release.sh

echo "Assuming 64-bit"

	##Configure temporary Swap file if needed (swap created is not persistant and only for compiling monero. It will unmount on reboot)
if (whiptail --title "Nanode Monero Updater" --yesno "For Monero to compile successfully 2GB of RAM is required.\n\nIf your device does not have 2GB RAM it can be artificially created with a swap file\n\nDo you have 2GB RAM on this device?\n\n* YES\n* NO - I do not have 2GB RAM (create a swap file)" 18 60); then
	echo -e "\e[32mSwap file unchanged\e[0m"
		else
			sudo fallocate -l 2G /swapfile 2>&1 | tee -a /home/nanode/debug.log
			sudo chmod 600 /swapfile 2>&1 | tee -a /home/nanode/debug.log
			sudo mkswap /swapfile 2>&1 | tee -a /home/nanode/debug.log
			sudo swapon /swapfile 2>&1 | tee -a /home/nanode/debug.log
			echo -e "\e[32mSwap file of 2GB Configured and enabled\e[0m"
			free -h
fi


		#ubuntu /dev/null odd requiremnt to set permissions
		sudo chmod 666 /dev/null

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
		echo "Deleting Old Version"
		rm -rf /home/nanode/monero/

# ********************************************
# ******START OF MONERO SOURCE BULD******
# ********************************************
echo "manual build of gtest for --- Monero" 2>&1 | tee -a /home/nanode/debug.log
sudo apt-get install libgtest-dev -y 2>&1 | tee -a /home/nanode/debug.log
cd /usr/src/gtest
sudo cmake .  2>&1 | tee -a /home/nanode/debug.log
sudo make 2>&1 | tee -a /home/nanode/debug.log
sudo mv lib/libg* /usr/lib/
cd
echo "Check dependencies installed for --- Monero" 2>&1 | tee -a /home/nanode/debug.log
sudo apt-get update
sudo apt-get install build-essential cmake pkg-config libssl-dev libzmq3-dev libunbound-dev libsodium-dev libunwind8-dev liblzma-dev libreadline6-dev libldns-dev libexpat1-dev libpgm-dev qttools5-dev-tools libhidapi-dev libusb-1.0-0-dev libprotobuf-dev protobuf-compiler libudev-dev libboost-chrono-dev libboost-date-time-dev libboost-filesystem-dev libboost-locale-dev libboost-program-options-dev libboost-regex-dev libboost-all-dev libboost-serialization-dev libboost-system-dev libboost-thread-dev ccache doxygen graphviz -y 2>&1 | tee -a /home/nanode/debug.log


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

# ********************************************
# ********END OF MONERO SOURCE BUILD **********
# ********************************************

#Make dir .bitmonero to hold lmdb. Needs to be added before drive mounted to give mount point. Waiting for monerod to start fails mount.
mkdir .bitmonero 2>&1 | tee -a /home/nanode/debug.log
#Clean-up used downloaded files
rm -R ~/temp

		#Update system version number
		echo "#!/bin/bash
		CURRENT_VERSION=$NEW_VERSION" > /home/nanode/current-ver.sh
		#cleanup old version number file
		rm /home/nanode/xmr-new-ver.sh



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
echo "Update Complete" 2>&1 | tee -a /home/nanode/debug.log
echo "####################" 2>&1 | tee -a /home/nanode/debug.log
echo "End setup-update-monero.sh script $(date)" 2>&1 | tee -a /home/nanode/debug.log
echo "####################" 2>&1 | tee -a /home/nanode/debug.log

rm ~/release.sh

./setup.sh
