#!/bin/bash

#Establish IP
echo "PiNode-XMR is checking for available updates"
sleep "1"
#Download update file
sleep "1"
wget -q https://raw.githubusercontent.com/shermand100/pinode-xmr/master/xmr-new-ver.sh -O /home/pinodexmr/xmr-new-ver.sh
echo "Version Info file received:"
#Download variable for current monero version
wget -q https://raw.githubusercontent.com/shermand100/pinode-xmr/master/release.sh -O /home/pinodexmr/release.sh
#Permission Setting
chmod 755 /home/pinodexmr/current-ver.sh
chmod 755 /home/pinodexmr/xmr-new-ver.sh
chmod 755 /home/pinodexmr/release.sh
#Load Variables
. /home/pinodexmr/current-ver.sh
. /home/pinodexmr/xmr-new-ver.sh
. /home/pinodexmr/release.sh
echo $NEW_VERSION 'New Version'
echo $CURRENT_VERSION 'Current Version'
sleep "3"
	if [ $CURRENT_VERSION -lt $NEW_VERSION ]
		then
		echo -e "\e[32mNew Monero version available...Proceeding with download\e[0m"
		sleep "2"
		sudo systemctl stop monerod-start.service
		sudo systemctl stop monerod-start-mining.service
		sudo systemctl stop monerod-start-tor.service
		sudo systemctl stop monerod-start-public.service
		sudo systemctl stop explorer-start.service
		echo "Monerod stop command sent, allowing 30 seconds for safe shutdown"
		sleep "30"
		echo "Deleting Old Version"
		rm -rf /home/pinodexmr/monero/
		sleep "2"
		echo "Ensuring swap-file enabled for Monero build"
		sudo dphys-swapfile swapon
		echo "Downloading latest Monero version"
		git clone --recursive -b $RELEASE https://github.com/monero-project/monero.git
		cd monero
		USE_SINGLE_BUILDDIR=1 make
		cd
		
		echo "Software Update Complete - Resuming Node"
		sleep 2
		. /home/pinodexmr/init.sh
		echo "Monero Node Started in background"

		#Update system version number
		echo "#!/bin/bash
		CURRENT_VERSION=$NEW_VERSION" > /home/pinodexmr/current-ver.sh
		#Remove downloaded version check files
		rm /home/pinodexmr/release.sh
		rm /home/pinodexmr/xmr-new-ver.sh
		whiptail --title "PiNode-XMR Monero Update Complete" --msgbox "Your PiNode-XMR has completed updating to the latest version of Monero" 16 60
		sleep 3
else
		rm /home/pinodexmr/xmr-new-ver.sh
		whiptail --title "PiNode-XMR Up-to-date" --msgbox "Your PiNode-XMR is running the latest version of Monero" 16 60

fi
./setup.sh
