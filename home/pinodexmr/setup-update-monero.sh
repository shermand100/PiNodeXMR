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
		echo "Ensuring swap-file enabled for Monero build"
		sudo dphys-swapfile swapon
		echo "Downloading latest Monero version"
		git clone --recursive -b $RELEASE https://github.com/monero-project/monero.git
		cd monero
		USE_SINGLE_BUILDDIR=1 make
		cd
		
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
		echo "Downloading latest Monero version"
		git clone --recursive -b $RELEASE https://github.com/monero-project/monero.git
		cd monero
		USE_SINGLE_BUILDDIR=1 make
		cd
		
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
