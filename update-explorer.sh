#!/bin/bash

echo "
####################
" 2>&1 | tee -a /home/pinodexmr/debug.log
echo "Start setup-update-explorer.sh script $(date)" 2>&1 | tee -a /home/pinodexmr/debug.log
echo "
####################
" 2>&1 | tee -a /home/pinodexmr/debug.log


#(1) Define variables and updater functions

#Permission Setting
chmod 755 /home/pinodexmr/current-ver-exp.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
chmod 755 /home/pinodexmr/exp-new-ver.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
#Load Variables
. /home/pinodexmr/current-ver-exp.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
. /home/pinodexmr/exp-new-ver.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
#Load boot status - what condition was node last run
. /home/pinodexmr/bootstatus.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)


		#Stop Node to make system resources available.
		sudo systemctl stop blockExplorer.service 2> >(tee -a /home/pinodexmr/debug.log >&2)
		sudo systemctl stop moneroPrivate.service 2> >(tee -a /home/pinodexmr/debug.log >&2)
		sudo systemctl stop moneroMiningNode.service 2> >(tee -a /home/pinodexmr/debug.log >&2)
		sudo systemctl stop moneroTorPrivate.service 2> >(tee -a /home/pinodexmr/debug.log >&2)
		sudo systemctl stop moneroTorPublic.service 2> >(tee -a /home/pinodexmr/debug.log >&2)
		sudo systemctl stop moneroPublicFree.service 2> >(tee -a /home/pinodexmr/debug.log >&2)
		sudo systemctl stop moneroI2PPrivate.service 2> >(tee -a /home/pinodexmr/debug.log >&2)
		sudo systemctl stop moneroCustomNode.service 2> >(tee -a /home/pinodexmr/debug.log >&2)
		sudo systemctl stop moneroPublicRPCPay.service 2> >(tee -a /home/pinodexmr/debug.log >&2)
		echo "Monero node stop command sent to make system resources available for update, allowing 30 seconds for safe shutdown"
		sleep "30"
		echo "Deleting Old Version"
		rm -rf /home/pinodexmr/onion-monero-blockchain-explorer/ 2> >(tee -a /home/pinodexmr/debug.log >&2)
		sleep "2"
		echo -e "\e[32mBuilding Monero Blockchain Explorer[0m"
		echo -e "\e[32m*******************************************************\e[0m"
		echo -e "\e[32m***This will take a few minutes - Hardware Dependent***\e[0m"
		echo -e "\e[32m*******************************************************\e[0m"
		sleep 10
		git clone -b master https://github.com/moneroexamples/onion-monero-blockchain-explorer.git 2> >(tee -a /home/pinodexmr/debug.log >&2)
		cd onion-monero-blockchain-explorer
		mkdir build && cd build
		cmake .. 2> >(tee -a /home/pinodexmr/debug.log >&2)
		make 2> >(tee -a /home/pinodexmr/debug.log >&2)
		cd
		#Update system reference Explorer version number version number
		echo "#!/bin/bash
		CURRENT_VERSION_EXP=$NEW_VERSION_EXP" > /home/pinodexmr/current-ver-exp.sh



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
		whiptail --title "Block Explorer Update Complete" --msgbox "Update complete, Node ready for start. See web-ui at $(hostname -I) to select mode." 16 60
	fi

	if [ $BOOT_STATUS -eq 3 ]
then
		sudo systemctl start moneroPrivate.service
		whiptail --title "Block Explorer Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi

	if [ $BOOT_STATUS -eq 4 ]
then
		sudo systemctl start moneroTorPrivate.service
		whiptail --title "Block Explorer Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi		

	if [ $BOOT_STATUS -eq 5 ]
then
		sudo systemctl start moneroMiningNode.service
		whiptail --title "Block Explorer Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi

	if [ $BOOT_STATUS -eq 6 ]
then
		sudo systemctl start moneroPublicRPCPay.service
		whiptail --title "Block Explorer Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi

	if [ $BOOT_STATUS -eq 7 ]
then
		sudo systemctl start moneroPublicFree.service
		whiptail --title "Block Explorer Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi

	if [ $BOOT_STATUS -eq 8 ]
then
		sudo systemctl start moneroI2PPrivate.service
		whiptail --title "Block Explorer Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi

	if [ $BOOT_STATUS -eq 9 ]
then
		sudo systemctl start moneroTorPublic.service
		whiptail --title "Block Explorer Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi



rm /home/pinodexmr/new-ver-exp.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)


##End debug log
echo "
####################
" 2>&1 | tee -a /home/pinodexmr/debug.log
echo "End setup-update-explorer.sh script $(date)" 2>&1 | tee -a /home/pinodexmr/debug.log
echo "
####################
" 2>&1 | tee -a /home/pinodexmr/debug.log