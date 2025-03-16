#!/bin/bash

echo "
####################
" 2>&1 | tee -a /home/pinodexmr/debug.log
echo "Start setup-update-p2pool.sh script $(date)" 2>&1 | tee -a /home/pinodexmr/debug.log
echo "
####################
" 2>&1 | tee -a /home/pinodexmr/debug.log

#Establish OS 32 or 64 bit
CPU_ARCH=`getconf LONG_BIT`

if [[ $CPU_ARCH -eq 32 ]]
	then
	echo -e "\e[33m*********************************************\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
	echo -e "\e[33m*********** ARCH: 32-bit detected ***********\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
	echo -e "\e[33m********** P2Pool Cannot be built ***********\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
	echo -e "\e[33m*********** ARCH: 64-bit required ***********\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
	echo -e "\e[33m********** SKIPPING P2Pool update ***********\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
	echo -e "\e[33m*********************************************\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
	echo "Returning to Menu in 10 seconds" 2>&1 | tee -a /home/pinodexmr/debug.log
	sleep "5"
	echo "Returning to Menu in 5 seconds" 2>&1 | tee -a /home/pinodexmr/debug.log
	sleep "5"
	else

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
		sudo systemctl stop p2pool.service
		echo "Monero node stop command sent to make system resources available for update, allowing 30 seconds for safe shutdown"
		sleep "10"
		echo "Update starts in 20 seconds"
		sleep "10"
		echo "Update starts in 10 seconds"
		sleep "5"
		echo "Update starts in 5 seconds"
		sleep "5"
		echo -e "\e[32mDelete old version\e[0m"		
		rm -rf /home/pinodexmr/p2pool/
		echo -e "\e[32mSuccess\e[0m"
		sleep "2"
		#Users repot failed P2Pool update (Oct '24) - Fix was missing dependencies update.
		#Update System and P2Pool Dependences
		echo -e "\e[32mUpdating dependencies for P2Pool build\e[0m"
		sleep "2"
		sudo apt update
		sudo apt upgrade -y
		echo -e "\e[32mSuccess\e[0m"
		sleep "2"
		echo -e "\e[32mBuilding new P2Pool\e[0m"
		##Install P2Pool
		git clone --recursive https://github.com/SChernykh/p2pool 2>&1 | tee -a /home/pinodexmr/debug.log
		cd p2pool
		git checkout tags/v4.4
		mkdir build && cd build
		cmake .. 2>&1 | tee -a /home/pinodexmr/debug.log
		make -j2 2>&1 | tee -a /home/pinodexmr/debug.log
		echo -e "\e[32mSuccess\e[0m"
		sleep 3
		cd
		#Update system reference Explorer version number version number
		chmod 755 /home/pinodexmr/p2pool-new-ver.sh
		. /home/pinodexmr/p2pool-new-ver.sh
		echo "#!/bin/bash
CURRENT_VERSION_P2POOL=$NEW_VERSION_P2POOL" > /home/pinodexmr/current-ver-p2pool.sh 2>&1 | tee -a /home/pinodexmr/debug.log

#Define Restart Monero Node
		# Key - BOOT_STATUS
		# 2 = idle
		# 3 || 5 = private node || mining node
		# 4 = tor
		# 6 = Public RPC pay
		# 7 = Public free
		# 8 = I2P
		# 9 tor public

		#Load bootstatus var
		sudo chmod 777 /home/pinodexmr/bootstatus.sh
		. /home/pinodexmr/bootstatus.sh

	if [[ $BOOT_STATUS -eq 2 ]]
then
		whiptail --title "P2Pool Update Complete" --msgbox "Update complete, Node ready for start. See web-ui at $(hostname -I) to select mode." 16 60
	fi

	if [[ $BOOT_STATUS -eq 3 ]]
then
		sudo systemctl start moneroPrivate.service
		whiptail --title "P2Pool Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi

	if [[ $BOOT_STATUS -eq 4 ]]
then
		sudo systemctl start moneroTorPrivate.service
		whiptail --title "P2Pool Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi		

	if [[ $BOOT_STATUS -eq 5 ]]
then
		sudo systemctl start moneroMiningNode.service
		whiptail --title "P2Pool Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi

	if [[ $BOOT_STATUS -eq 6 ]]
then
		sudo systemctl start moneroPublicRPCPay.service
		whiptail --title "P2Pool Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi

	if [[ $BOOT_STATUS -eq 7 ]]
then
		sudo systemctl start moneroPublicFree.service
		whiptail --title "P2Pool Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi

	if [[ $BOOT_STATUS -eq 8 ]]
then
		sudo systemctl start moneroI2PPrivate.service
		whiptail --title "P2Pool Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi

	if [[ $BOOT_STATUS -eq 9 ]]
then
		sudo systemctl start moneroTorPublic.service
		whiptail --title "P2Pool Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi
fi

	##End debug log
echo "Update Script Complete" 2>&1 | tee -a /home/pinodexmr/debug.log
sleep 5
echo "####################" 2>&1 | tee -a /home/pinodexmr/debug.log
echo "End setup-update-p2pool.sh script $(date)" 2>&1 | tee -a /home/pinodexmr/debug.log
echo "####################" 2>&1 | tee -a /home/pinodexmr/debug.log
