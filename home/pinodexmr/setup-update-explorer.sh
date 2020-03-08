#!/bin/bash

#Download update file
sleep "1"
wget -q https://raw.githubusercontent.com/shermand100/pinode-xmr/master/exp-new-ver.sh -O /home/pinodexmr/exp-new-ver.sh

#Permission Setting
chmod 755 /home/pinodexmr/current-ver-exp.sh
chmod 755 /home/pinodexmr/exp-new-ver.sh
#Load Variables
. /home/pinodexmr/current-ver-exp.sh
. /home/pinodexmr/exp-new-ver.sh

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
		echo "Software Update Complete - Resuming Node if required"
		sleep 2
		. /home/pinodexmr/init.sh

		#Update system version number
		echo "#!/bin/bash
		CURRENT_VERSION_EXP=$NEW_VERSION_EXP" > /home/pinodexmr/current-ver-exp.sh
		#Remove downloaded version check file
		whiptail --title "Blockchain Explorer Update Complete" --msgbox "Your PiNode-XMR has completed updating to the latest version of the Monero Onion Blockchain Explorer" 16 60
		sleep 3
else
		rm /home/pinodexmr/new-ver-exp.sh
		whiptail --title "PiNode-XMR" --msgbox "Monero Onion Blockchain Explorer is Up-to-date" 16 60

fi
./setup.sh
