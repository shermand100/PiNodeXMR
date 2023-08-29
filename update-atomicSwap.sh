#!/bin/bash

#Error Log:
touch /home/pinodexmr/debug.log
echo "
####################
" 2>&1 | tee -a /home/pinodexmr/debug.log
echo "Start setup-update-Atomic Swap.sh script $(date)" 2>&1 | tee -a /home/pinodexmr/debug.log
echo "
####################
" 2>&1 | tee -a /home/pinodexmr/debug.log

#Establish OS 32 or 64 bit
CPU_ARCH=`getconf LONG_BIT`

if [[ $CPU_ARCH -eq 32 ]]
	then
	echo -e "\e[33m*********************************************\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
	echo -e "\e[33m*********** ARCH: 32-bit detected ***********\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
	echo -e "\e[33m******** Atomic Swap Cannot be built ********\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
	echo -e "\e[33m*********** ARCH: 64-bit required ***********\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
	echo -e "\e[33m******* SKIPPING Atomic Swap update *********\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
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
		rm -rf /home/pinodexmr/atomic-swap/
		echo -e "\e[32mSuccess - if present\e[0m"
		sleep "2"
		echo -e "\e[32mBuilding new Atomic Swap utility from AthanorLabs\e[0m"
		echo -e "\e[32mInstalling Atomic Swap\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log

		#Install Go 1.20 for compatability
		sudo apt install snapd -y
		sudo snap install --classic --channel=1.20/stable go
		#clone Atomic Swap
		git clone https://github.com/athanorlabs/atomic-swap.git 2>&1 | tee -a /home/pinodexmr/debug.log
		cd atomic-swap
		#make Atomic Swap
		make build-release 2>&1 | tee -a /home/pinodexmr/debug.log
		cd
		mkdir .atomicswap
		sudo chmod 777 -R /home/pinodexmr/.atomicswap/

		#Update system reference Atomic Swap version number
		chmod 755 /home/pinodexmr/new-ver-atomicSwap.sh
		. /home/pinodexmr/new-ver-atomicSwap.sh
		echo "#!/bin/bash
CURRENT_VERSION_P2POOL=$NEW_VERSION_ATOMICSWAP" > /home/pinodexmr/current-ver-atomicSwap.sh 2>&1 | tee -a /home/pinodexmr/debug.log

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
		whiptail --title "Atomic Swap Update Complete" --msgbox "Update complete, Monero Node ready for start. See web-ui at $(hostname -I)" 16 60
	fi

	if [[ $BOOT_STATUS -eq 3 ]]
then
		sudo systemctl start moneroPrivate.service
		whiptail --title "Atomic Swap Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi

	if [[ $BOOT_STATUS -eq 4 ]]
then
		sudo systemctl start moneroTorPrivate.service
		whiptail --title "Atomic Swap Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi		

	if [[ $BOOT_STATUS -eq 5 ]]
then
		sudo systemctl start moneroMiningNode.service
		whiptail --title "Atomic Swap Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi

	if [[ $BOOT_STATUS -eq 6 ]]
then
		sudo systemctl start moneroPublicRPCPay.service
		whiptail --title "Atomic Swap Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi

	if [[ $BOOT_STATUS -eq 7 ]]
then
		sudo systemctl start moneroPublicFree.service
		whiptail --title "Atomic Swap Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi

	if [[ $BOOT_STATUS -eq 8 ]]
then
		sudo systemctl start moneroI2PPrivate.service
		whiptail --title "Atomic Swap Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi

	if [[ $BOOT_STATUS -eq 9 ]]
then
		sudo systemctl start moneroTorPublic.service
		whiptail --title "Atomic Swap Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi
fi

	##End debug log
echo "Update Script Complete" 2>&1 | tee -a /home/pinodexmr/debug.log
sleep 5
echo "####################" 2>&1 | tee -a /home/pinodexmr/debug.log
echo "End setup-update-p2pool.sh script $(date)" 2>&1 | tee -a /home/pinodexmr/debug.log
echo "####################" 2>&1 | tee -a /home/pinodexmr/debug.log