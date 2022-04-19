#!/bin/bash

#Establish IP
echo "PiNode-XMR is checking for available updates"
sleep "1"
#Download update file
sleep "1"
wget -q https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/master/xmr-new-ver.sh -O /home/pinodexmr/xmr-new-ver.sh
echo "Version Info file received:"
#Download variable for current monero version
wget -q https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/master/release.sh -O /home/pinodexmr/release.sh
#Permission Setting
chmod 755 /home/pinodexmr/current-ver.sh
chmod 755 /home/pinodexmr/xmr-new-ver.sh
chmod 755 /home/pinodexmr/release.sh
#Load boot status - what condition was node last run
. /home/pinodexmr/bootstatus.sh
#Load Variables
. /home/pinodexmr/current-ver.sh
. /home/pinodexmr/xmr-new-ver.sh
. /home/pinodexmr/release.sh
echo $NEW_VERSION 'New Version'
echo $CURRENT_VERSION 'Current Version'

#Define update function:

function fn_updateMonero () {

	##Configure temporary Swap file if needed (swap created is not persistant and only for compiling monero. It will unmount on reboot)
if (whiptail --title "PiNode-XMR Monero Updater" --yesno "For Monero to compile successfully 2GB of RAM is required.\n\nIf your device does not have 2GB RAM it can be artificially created with a swap file\n\nDo you have 2GB RAM on this device?\n\n* YES\n* NO - I do not have 2GB RAM (create a swap file)" 18 60); then
	echo -e "\e[32mSwap file unchanged\e[0m"
	sleep 3
		else
			sudo fallocate -l 2G /swapfile 2>&1 | tee -a debug.log
			sudo chmod 600 /swapfile 2>&1 | tee -a debug.log
			sudo mkswap /swapfile 2>&1 | tee -a debug.log
			sudo swapon /swapfile 2>&1 | tee -a debug.log
			echo -e "\e[32mSwap file of 2GB Configured and enabled\e[0m"
			free -h
			sleep 3
fi

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
	# ********************************************
# ******START OF MONERO SOURCE BULD******
# ********************************************
##Build Monero and Onion Blockchain Explorer (the simple but time comsuming bit)
	#Download latest Monero release number
#ubuntu /dev/null odd requiremnt to set permissions
sudo chmod 666 /dev/null
sleep 3
wget -q https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/master/release.sh -O /home/pinodexmr/release.sh
chmod 755 /home/pinodexmr/release.sh
. /home/pinodexmr/release.sh
rm /home/pinodexmr/release.sh
echo -e "\e[32mDownloading Monero \e[0m"
sleep 3

git clone --recursive https://github.com/monero-project/monero
echo -e "\e[32m****************************************************\e[0m"
echo -e "\e[32m*****************Building Monero********************\e[0m"
echo -e "\e[32m****************************************************\e[0m"
echo -e "\e[32m****************************************************\e[0m"
echo -e "\e[32m****This will take a while - Hardware Dependent****\e[0m"
echo -e "\e[32m****************************************************\e[0m"
echo -e "\e[32m****************************************************\e[0m"
sleep 10
cd monero && git submodule init && git submodule update
git checkout $RELEASE
git submodule sync && git submodule update
USE_SINGLE_BUILDDIR=1 make 2>&1 | tee -a debug.log
cd

# ********************************************
# ********END OF MONERO SOURCE BULD **********
# ********************************************

# #********************************************
# #**********START OF Monero BINARY USE********
# #********************************************

# echo "Downloading pre-built Monero from get.monero" 2>&1 | tee -a debug.log
# #Make standard location for Monero
# mkdir -p ~/monero/build/release/bin
# if [[ $CPU_ARCH -eq 64 ]]
# then
#   #Download 64-bit Monero
# wget https://downloads.getmonero.org/cli/linuxarm8
# #Make temp folder to extract binaries
# mkdir temp && tar -xvf linuxarm8 -C ~/temp
# #Move Monerod files to standard location
# mv /home/pinodexmr/temp/monero-aarch64-linux-gnu-v0.17.3.0/monero* /home/pinodexmr/monero/build/release/bin/
# rm linuxarm8
# rm -R /home/pinodexmr/temp/
# else
#   #Download 32-bit Monero
# wget https://downloads.getmonero.org/cli/linuxarm7
# #Make temp folder to extract binaries
# mkdir temp && tar -xvf linuxarm7 -C ~/temp
# #Move Monerod files to standard location
# mv /home/pinodexmr/temp/monero-arm-linux-gnueabihf-v0.17.3.0/monero* /home/pinodexmr/monero/build/release/bin/
# rm linuxarm7
# rm -R /home/pinodexmr/temp/
# fi
# #Make dir .bitmonero to hold lmdb. Needs to be added before drive mounted to give mount point. Waiting for monerod to start fails mount.
# mkdir .bitmonero 2>&1 | tee -a debug.log
# #Clean-up used downloaded files
# rm -R ~/temp
# }


# if [[ $CPU_ARCH -ne 64 ]] && [[ $CPU_ARCH -ne 32 ]]
# then
#   if (whiptail --title "OS version" --yesno "I've tried to auto-detect what version of Monero you need based on your OS but I've not been successful.\n\nPlease select your OS architecture..." 8 78 --no-button "32-bit" --yes-button "64-bit"); then
#     CPU_ARCH=64
# 	f_installMonero
# 	else
#     CPU_ARCH=32
# 	f_installMonero
#   fi
# else
#  f_installMonero
# fi

# #********************************************
# #*******END OF Monero BINARY USE*******
# #********************************************

		#Update system version number
		echo "#!/bin/bash
		CURRENT_VERSION=$NEW_VERSION" > /home/pinodexmr/current-ver.sh
		#cleanup old version number file
		rm /home/pinodexmr/xmr-new-ver.sh
}

fn_restartMoneroNode () {
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
}

sleep "2"
	#(2)Start of Updater logic

	if [ $CURRENT_VERSION -lt $NEW_VERSION ]
		then
		if (whiptail --title "Monero Updater" --yesno "An update to the Monero is available, would you like to download and install it now?" --yes-button "Update Now" --no-button "Return to Main Menu"  14 78); then
			sleep "2"
			fn_updateMonero
			fn_restartMoneroNode
		else
			whiptail --title "Monero Updater" --msgbox "Returning to Main Menu. No changes have been made." 12 78;
			rm /home/pinodexmr/new-ver.sh
		fi
	

	else

		if (whiptail --title "Monero Update" --yesno "This device thinks it's running the latest version of Monero.\n\nIf you think this is incorrect you may force an update below.\n\n*Note that a force update can also be used as a reset tool if you think your version is not functioning properly" --yes-button "Force Update" --no-button "Return to Main Menu"  14 78); then
			sleep "2"
			fn_updateBlockExplorer
			fn_restartMoneroNode
		else
			whiptail --title "Monero Updater" --msgbox "Returning to Main Menu. No changes have been made." 12 78;
			rm /home/pinodexmr/new-ver-exp.sh
	fi
./setup.sh
