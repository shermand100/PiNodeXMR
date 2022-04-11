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

fn_updateMonero () {
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
	#Download latest Monero release number
wget -q https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/master/release.sh -O /home/pinodexmr/release.sh
chmod 755 /home/pinodexmr/release.sh
. /home/pinodexmr/release.sh

#ubuntu /dev/null requirement to set permission
sudo chmod 666 /dev/null
sleep 1

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
USE_SINGLE_BUILDDIR=1 make 2>&1 | tee -a debug.log
cd
		#Update system version number
		echo "#!/bin/bash
		CURRENT_VERSION=$NEW_VERSION" > /home/pinodexmr/current-ver.sh
}

sleep "3"
	if [ $CURRENT_VERSION -lt $NEW_VERSION ]
		then
		echo -e "\e[32mNew Monero version available...Proceeding with download\e[0m"
		sleep "2"
		sudo systemctl stop monerod-start.service
		sudo systemctl stop monerod-prune.service
		sudo systemctl stop monerod-start-free.service
		sudo systemctl stop monerod-start-mining.service
		sudo systemctl stop monerod-start-tor.service
		sudo systemctl stop monerod-start-tor-public.service		
		sudo systemctl stop monerod-start-i2p.service
		sudo systemctl stop monerod-start-public.service
		sudo systemctl stop explorer-start.service
		echo "Monerod stop command sent, allowing 30 seconds for safe shutdown"
		sleep "30"
		echo "Deleting Old Version"
		rm -rf /home/pinodexmr/monero/
		sleep "2"

		
		sleep 2
		if [ $BOOT_STATUS -eq 2 ]
then
		echo "Update complete, Node ready for start. See web-ui at $(hostname -I) to select mode."
else
		. /home/pinodexmr/init.sh
		echo "Resuming Node"	
fi
		#Update system version number
		echo "#!/bin/bash
		CURRENT_VERSION=$NEW_VERSION" > /home/pinodexmr/current-ver.sh
		#Remove downloaded version check files
		rm /home/pinodexmr/release.sh
		rm /home/pinodexmr/xmr-new-ver.sh
		whiptail --title "PiNode-XMR Monero Update Complete" --msgbox "Your PiNode-XMR has completed updating to the latest version of Monero" 16 60
		sleep 3
else
				
		if (whiptail --title "PiNode-XMR Monero Update" --yesno "This device thinks it's running the latest version of Monero (that has been tested with PiNode-XMR).\n\nIf you think this is incorrect or require a clean Monero install you may force an update below." --yes-button "Force Monero Update" --no-button "Return to Main Menu"  14 78); then

		echo -e "\e[32mSystem will now install the latest available of Monero.\e[0m"
		sleep "2"

#Establish OS 32 or 64 bit
CPU_ARCH=`getconf LONG_BIT`
echo "OS getconf LONG_BIT $CPU_ARCH" >> debug.log
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

		sudo systemctl stop monerod-start.service
		sudo systemctl stop monerod-prune.service
		sudo systemctl stop monerod-start-free.service
		sudo systemctl stop monerod-start-mining.service
		sudo systemctl stop monerod-start-tor.service
		sudo systemctl stop monerod-start-i2p.service
		sudo systemctl stop monerod-start-public.service
		sudo systemctl stop explorer-start.service
		echo "Monerod stop command sent, allowing 30 seconds for safe shutdown"
		sleep "30"
		echo "Deleting Old Version"
		rm -rf /home/pinodexmr/monero/
		sleep "2"
		echo "Ensuring swap-file enabled for Monero build"
		sudo dphys-swapfile swapon
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
# #*******START OF TEMP BINARY USE*******
# #**************(Disabled)********************

# #Define Install Monero function to reduce repeat script
# function f_installMonero {
# echo "Downloading pre-built Monero from get.monero" >>debug.log
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
# else
#   #Download 32-bit Monero
# wget https://downloads.getmonero.org/cli/linuxarm7
# #Make temp folder to extract binaries
# mkdir temp && tar -xvf linuxarm7 -C ~/temp
# #Move Monerod files to standard location
# mv /home/pinodexmr/temp/monero-arm-linux-gnueabihf-v0.17.3.0/monero* /home/pinodexmr/monero/build/release/bin/
# rm linuxarm7
# fi
# #Make dir .bitmonero to hold lmdb. Needs to be added before drive mounted to give mount point. Waiting for monerod to start fails mount.
# mkdir .bitmonero 2> >(tee -a debug.log >&2)
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
# #*******END OF TEMP BINARY USE*******
# #**************(Disabled)********************
		
		if [ $BOOT_STATUS -eq 2 ]
then
		echo "Update complete, Node ready for start. See web-ui at $(hostname -I) to select mode."
else
		. /home/pinodexmr/init.sh
		echo "Resuming Node"	
fi

		#Update system version number
		echo "#!/bin/bash
		CURRENT_VERSION=$NEW_VERSION" > /home/pinodexmr/current-ver.sh
		#Remove downloaded version check files
		rm /home/pinodexmr/release.sh
		rm /home/pinodexmr/xmr-new-ver.sh
		whiptail --title "PiNode-XMR Monero Update Complete" --msgbox "Your PiNode-XMR has completed updating to the latest version of Monero" 16 60
		sleep 3
									else
										rm /home/pinodexmr/release.sh
										rm /home/pinodexmr/xmr-new-ver.sh
									whiptail --title "PiNode-XMR Monero Update" --msgbox "Returning to Main Menu. No changes have been made." 12 78;
									. /home/pinodexmr/setup.sh
									fi

fi
./setup.sh
