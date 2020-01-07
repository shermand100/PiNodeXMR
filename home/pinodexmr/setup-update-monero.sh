#!/bin/bash

#Establish IP
DEVICE_IP="$(hostname -I)"
echo "PiNode-XMR on ${DEVICE_IP} is checking for available updates"
sleep "1"
#Download update file
sleep "1"
wget -q https://raw.githubusercontent.com/shermand100/pinode-xmr/master/xmr-new-ver.sh -O /home/pinodexmr/xmr-new-ver.sh
echo "Version Info file recieved:"
#Permission Setting
chmod 755 /home/pinodexmr/current-ver.sh
chmod 755 /home/pinodexmr/xmr-new-ver.sh
#Load Variables
. /home/pinodexmr/current-ver.sh
. /home/pinodexmr/xmr-new-ver.sh
. /home/pinodexmr/strip.sh
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
		echo "Monerod stop command sent, allowing 30 seconds for safe shutdown"
		sleep "30"
		echo "Deleting Old Version"
		rm -rf /home/pinodexmr/monero/
		sleep "2"
		echo "Ensuring swap-file enabled for Monero build"
		sudo dphys-swapfile swapon
		echo "Downloading latest Monero version"
		git clone --recursive https://github.com/monero-project/monero.git
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
		#Remove downloaded version check file
		echo "Update complete"
		sleep 3
else
	echo "Your node is up to date!"
sleep 3

fi

./setup.sh
