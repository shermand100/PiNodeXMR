#!/bin/bash

#Download update file
sleep "1"
wget -q https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/master/exp-new-ver.sh -O /home/pinodexmr/exp-new-ver.sh

#Permission Setting
chmod 755 /home/pinodexmr/current-ver-exp.sh
chmod 755 /home/pinodexmr/exp-new-ver.sh
#Load Variables
. /home/pinodexmr/current-ver-exp.sh
. /home/pinodexmr/exp-new-ver.sh
#Load boot status - what condition was node last run
. /home/pinodexmr/bootstatus.sh

# Display versions
echo -e "\e[32mVersion Info file received:\e[0m"
echo -e "\e[36mCurrent Version: ${CURRENT_VERSION_EXP}\e[0m"
echo -e "\e[36mAvailable Version: ${NEW_VERSION_EXP}\e[0m"
sleep "3"
	if [ $CURRENT_VERSION_EXP -lt $NEW_VERSION_EXP ]
		then
		echo -e "\e[32mNew Explorer version available...Proceeding with download\e[0m"
		sleep "2"
		sudo systemctl stop monerod-start.service
		sudo systemctl stop monerod-start-mining.service
		sudo systemctl stop monerod-start-tor.service
		sudo systemctl stop monerod-start-public.service
		sudo systemctl stop explorer-start.service
		echo "Monerod stop command sent, allowing 30 seconds for safe shutdown"
		sleep "30"
		echo "Deleting Old Version"
		rm -rf /home/pinodexmr/onion-monero-blockchain-explorer/
		sleep "2"
		echo "Ensuring swap-file enabled for build"
		sudo dphys-swapfile swapon
		echo -e "\e[32mBuilding Monero Blockchain Explorer[0m"
		echo -e "\e[32m*******************************************************\e[0m"
		echo -e "\e[32m***This will take a few minutes - Hardware Dependent***\e[0m"
		echo -e "\e[32m*******************************************************\e[0m"
		sleep 10
		git clone https://github.com/moneroexamples/onion-monero-blockchain-explorer.git
		cd onion-monero-blockchain-explorer
		mkdir build && cd build
		cmake ..
		make
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
		CURRENT_VERSION_EXP=$NEW_VERSION_EXP" > /home/pinodexmr/current-ver-exp.sh
		#Remove downloaded version check file
		whiptail --title "Blockchain Explorer Update Complete" --msgbox "Your PiNode-XMR has completed updating to the latest version of the Monero Onion Blockchain Explorer" 16 60
		sleep 3
else

		if (whiptail --title "Monero Onion Block Explorer Update" --yesno "This device thinks it's running the latest version of Monero Onion Block Explorer.\n\nIf you think this is incorrect you may force an update below.\n\n*Note that a force update can also be used as a reset tool if you think your version is not functioning properly" --yes-button "Force PiNode-XMR Update" --no-button "Return to Main Menu"  14 78); then

		echo -e "\e[32mForcing update/re-install of Monero Onion Block Explorer\e[0m"
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
		rm -rf /home/pinodexmr/onion-monero-blockchain-explorer/
		sleep "2"
		echo "Ensuring swap-file enabled for build"
		sudo dphys-swapfile swapon
		echo -e "\e[32mBuilding Monero Blockchain Explorer[0m"
		echo -e "\e[32m*******************************************************\e[0m"
		echo -e "\e[32m***This will take a few minutes - Hardware Dependent***\e[0m"
		echo -e "\e[32m*******************************************************\e[0m"
		sleep 10
		git clone https://github.com/moneroexamples/onion-monero-blockchain-explorer.git
		cd onion-monero-blockchain-explorer
		mkdir build && cd build
		cmake ..
		make
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
		CURRENT_VERSION_EXP=$NEW_VERSION_EXP" > /home/pinodexmr/current-ver-exp.sh
		#Remove downloaded version check file
		whiptail --title "Blockchain Explorer Update Complete" --msgbox "Your PiNode-XMR has completed updating to the latest version of the Monero Onion Blockchain Explorer" 16 60
		sleep 3
		
									else
									whiptail --title "Monero Onion Block Explorer Update" --msgbox "Returning to Main Menu. No changes have been made." 12 78;
									rm /home/pinodexmr/new-ver-exp.sh
									. /home/pinodexmr/setup.sh
									fi

fi
./setup.sh
