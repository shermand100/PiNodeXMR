#!/bin/bash

echo "
####################
" 2>&1 | tee -a /home/pinodexmr/debug.log
echo "Start setup-update-p2pool.sh script $(date)" 2>&1 | tee -a /home/pinodexmr/debug.log
echo "
####################
" 2>&1 | tee -a /home/pinodexmr/debug.log

#(1) Define variables and updater functions
#Download update file
sleep "1"
wget -q https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/master/p2pool-new-ver.sh -O /home/pinodexmr/p2pool-new-ver.sh 2>&1 | tee -a /home/pinodexmr/debug.log

#Permission Setting
chmod 755 /home/pinodexmr/current-ver-p2pool.sh 2>&1 | tee -a /home/pinodexmr/debug.log
chmod 755 /home/pinodexmr/p2pool-new-ver.sh 2>&1 | tee -a /home/pinodexmr/debug.log
#Load Variables
. /home/pinodexmr/current-ver-p2pool.sh 2>&1 | tee -a /home/pinodexmr/debug.log
. /home/pinodexmr/p2pool-new-ver.sh 2>&1 | tee -a /home/pinodexmr/debug.log
#Load boot status - what condition was node last run
. /home/pinodexmr/bootstatus.sh 2>&1 | tee -a /home/pinodexmr/debug.log

# Display versions
echo -e "\e[32mVersion Info file received:\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
echo -e "\e[36mCurrent Version: ${CURRENT_VERSION_P2POOL}\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
echo -e "\e[36mAvailable Version: ${NEW_VERSION_P2POOL}\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
sleep "3"

#Define update function:

fn_updateP2Pool () {
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
		echo -e "\e[32mBuilding new P2Pool\e[0m"
		##Install P2Pool
		git clone --recursive https://github.com/SChernykh/p2pool 2>&1 | tee -a /home/pinodexmr/debug.log
		cd p2pool
		mkdir build && cd build
		cmake .. 2>&1 | tee -a /home/pinodexmr/debug.log
		make -j2 2>&1 | tee -a /home/pinodexmr/debug.log
		echo -e "\e[32mSuccess\e[0m"
		sleep 3
		cd
		#Update system reference Explorer version number version number
		echo "#!/bin/bash
CURRENT_VERSION_P2POOL=$NEW_VERSION_P2POOL" > /home/pinodexmr/current-ver-p2pool.sh 2>&1 | tee -a /home/pinodexmr/debug.log
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
		whiptail --title "P2Pool Update Complete" --msgbox "Update complete, Node ready for start. See web-ui at $(hostname -I) to select mode." 16 60
	fi

	if [ $BOOT_STATUS -eq 3 ]
then
		sudo systemctl start moneroPrivate.service
		whiptail --title "P2Pool Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi

	if [ $BOOT_STATUS -eq 4 ]
then
		sudo systemctl start moneroTorPrivate.service
		whiptail --title "P2Pool Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi		

	if [ $BOOT_STATUS -eq 5 ]
then
		sudo systemctl start moneroMiningNode.service
		whiptail --title "P2Pool Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi

	if [ $BOOT_STATUS -eq 6 ]
then
		sudo systemctl start moneroPublicRPCPay.service
		whiptail --title "P2Pool Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi

	if [ $BOOT_STATUS -eq 7 ]
then
		sudo systemctl start moneroPublicFree.service
		whiptail --title "P2Pool Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi

	if [ $BOOT_STATUS -eq 8 ]
then
		sudo systemctl start moneroI2PPrivate.service
		whiptail --title "P2Pool Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi

	if [ $BOOT_STATUS -eq 9 ]
then
		sudo systemctl start moneroTorPublic.service
		whiptail --title "P2Pool Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
	fi
}

#(2)Start of Updater logic

	if [ $CURRENT_VERSION_P2POOL -lt $NEW_VERSION_P2POOL ]
		then
		if (whiptail --title "P2Pool Update" --yesno "An update to the P2Pool is available, would you like to download and install it now?" --yes-button "Update Now" --no-button "Return to Main Menu"  14 78); then
			sleep "2"
			fn_updateP2Pool
			fn_restartMoneroNode
			rm /home/pinodexmr/p2pool-new-ver.sh 2>&1 | tee -a /home/pinodexmr/debug.log
		else
			whiptail --title "P2Pool Update" --msgbox "Returning to Main Menu. No changes have been made." 12 78;
			rm /home/pinodexmr/p2pool-new-ver.sh
		fi
	

	else

		if (whiptail --title "P2Pool Update" --yesno "This device thinks it's running the latest version of P2Pool.\n\nIf you think this is incorrect you may force an update below.\n\n*Note that a force update can also be used as a reset tool if you think your version is not functioning properly" --yes-button "Force Update" --no-button "Return to Main Menu"  14 78); then
			fn_updateP2Pool
			fn_restartMoneroNode
			rm /home/pinodexmr/p2pool-new-ver.sh 2>&1 | tee -a /home/pinodexmr/debug.log
		else
			whiptail --title "P2Pool Update" --msgbox "Returning to Main Menu. No changes have been made." 12 78;
			rm /home/pinodexmr/p2pool-new-ver.sh 2>&1 | tee -a /home/pinodexmr/debug.log
		fi
	fi

	##End debug log
echo "Update Complete" 2>&1 | tee -a /home/pinodexmr/debug.log
sleep 5
echo "####################" 2>&1 | tee -a /home/pinodexmr/debug.log
echo "End setup-update-p2pool.sh script $(date)" 2>&1 | tee -a /home/pinodexmr/debug.log
echo "####################" 2>&1 | tee -a /home/pinodexmr/debug.log


./setup.sh