#!/bin/bash

		#HEIGHT=20
		#WIDTH=60
		#CHOICE_HEIGHT=8
		CHOICE=$(whiptail --backtitle "Welcome" --title "PiNode-XMR Settings" --menu "\n\nWhat would you like to configure?" 20 60 10 \
	"1)" "Exit to Command line" \
    "2)" "System Settings" \
	"3)" "Update Tools" \
	"4)" "Node Tools" \
	"5)" "Atomic Swap" \
	"6)" "Extra Network Tools" 2>&1 >/dev/tty)
	
	case $CHOICE in
		
		"1)")
		;;
				
		"2)")CHOICE2=$(whiptail --backtitle "Welcome" --title "PiNode-XMR Settings" --menu "\n\nSystem Settings" 20 60 10 \
				"1)" "Hardware & WiFi Settings (Ubuntu-config)" \
				"2)" "Master Login Password Set" \
				"3)" "Monero RPC Username and Password setup" \
				"4)" "USB storage setup" \
				"5)" "Support Scripts" \
				"6)" "PWM Fan Control tool" 2>&1 >/dev/tty)
				
				case $CHOICE2 in
		
					"1)")	whiptail --title "PiNode-XMR Settings" --msgbox "You will now be taken to the Ubuntu menu to configure your hardware" 8 78;
							sudo armbian-config
					;;
				
					"2)") 	if (whiptail --title "PiNode-XMR Set Password" --yesno "This will change your SSH/Web terminal log in password\n\nWould you like to continue?" 12 78); then
					. /home/pinodexmr/setupMenuScripts/setup-password-master.sh
							else
					sleep 2
							fi
					;;
					
					"3)") 	if (whiptail --title "PiNode-XMR Set Password" --yesno "This will set your credentials needed to connect your wallet to your node\n\nWould you like to continue?" 12 78); then
					. /home/pinodexmr/setupMenuScripts/setup-password-monerorpc.sh
							else
					sleep 2
							fi
					;;
			
					"4)")	if (whiptail --title "PiNode-XMR configure storage" --yesno "This will allow you to add USB storage for the Monero blockchain.\n\nConnect your device now.\n\nWould you like to continue?" 16 78); then
					. /home/pinodexmr/setupMenuScripts/setup-usb-select-device.sh
							else
					sleep 2
							fi
					;;
					#Section 5 "PiNode-XMR Support Scripts" created to give ability of giving support to a user that requires complex or unique commands that they may not be able to action themselves. 3 scripts will be available, with default script action of no changes. User will be directed to activate the relevent script to assist them.
					"5)")	if (whiptail --title "PiNode-XMR Support Scripts" --yesno "This section allows for personalised support to be given to a PiNodeXMR user. Only continue if directed to by this project dev. \n\nWould you like to continue?" 16 78); then
					CHOICE2a=$(whiptail --backtitle "Welcome" --title "PiNode-XMR Settings" --menu "\n\nSystem Settings" 20 60 10 \
						"1)" "Support Script Channel 1" \
						"2)" "Support Script Channel 2" \
						"3)" "Support Script Channel 3" 2>&1 >/dev/tty)

						case $CHOICE2a in
		
					"1)")	if (whiptail --title "PiNode-XMR Support Scripts" --yesno "This will download and run the PiNodeXMR support script #1 from https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/supportScript1.sh\n\nWould you like to continue?" 12 78); then
					wget -O - https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/supportScript1.sh | bash
							else
					sleep 2
							fi
					;;
				
					"2)") 	if (whiptail --title "PiNode-XMR Support Scripts" --yesno "This will download and run the PiNodeXMR support script #2 from https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/supportScript2.sh\n\nWould you like to continue?" 12 78); then
					wget -O - https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/supportScript2.sh | bash
							else
					sleep 2
							fi
					;;
					
					"3)") 	if (whiptail --title "PiNode-XMR Support Scripts" --yesno "This will download and run the PiNodeXMR support script #3 from https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/supportScript3.sh\n\nWould you like to continue?" 12 78); then
					wget -O - https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/supportScript3.sh | bash
							else
					sleep 2
							fi
					;;
					esac
							else
					sleep 2
							fi
					;;
					
					"6)")	if (whiptail --title "ATS : by tuxd3v | https://github.com/tuxd3v/ats#credits" --yesno "This utility is only for devices that have a PWM fan plugged directly into the SBC (ie The RockPro64). This tool will read system temps and attempt to adjust fan speed accordingly\n\nWould you like to continue?" 16 78); then
					sudo apt-get update
					sudo apt-get install lua5.3 lua5.3-dev gcc make -y
					git clone https://github.com/tuxd3v/ats.git
					cd ats
					make
					sudo make install
					sleep 10
					whiptail --title "ATS : by tuxd3v" --msgbox "The ATS (Active Thermal Service) tool has been installed on your device\nCheck the service is functioning with 'sudo systemctl status ats'" 8 78;
							else
					sleep 2
							fi
					;;
				esac
				. /home/pinodexmr/setup.sh
				;;
				
		"3)")CHOICE3=$(whiptail --backtitle "Welcome" --title "PiNode-XMR Settings" --menu "\n\nUpdate Tools" 20 60 10 \
				"1)" "Update Monero" \
				"2)" "Update PiNode-XMR" \
				"3)" "Update Blockchain Explorer" \
				"4)" "Update P2Pool" \
				"5)" "Update Monero-LWS" \
				"6)" "Update Atomic Swap" \
				"7)" "Update system packages and dependencies" 2>&1 >/dev/tty)
				
				case $CHOICE3 in
		
					"1)")	if (whiptail --title "PiNode-XMR Update Monero" --yesno "This will run a check to see if a Monero update is available\n\nIf an update is found PiNode-XMR will perform the update.\n\n***This will take several hours***\n\nWould you like to continue?" 12 78); then
							wget -q https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/xmr-new-ver.sh -O /home/pinodexmr/xmr-new-ver.sh
							#Permission Setting
							chmod 755 /home/pinodexmr/current-ver.sh
							chmod 755 /home/pinodexmr/xmr-new-ver.sh
							#Load Variables
							. /home/pinodexmr/current-ver.sh
							. /home/pinodexmr/xmr-new-ver.sh
							echo "\e[36mVersion Info file received: \e[0m"
							echo -e "\e[36mCurrent Version: $CURRENT_VERSION \e[0m"
							echo -e "\e[36mAvailable Version: $NEW_VERSION \e[0m"
							sleep "3"
								if [ $CURRENT_VERSION -lt $NEW_VERSION ]; then
									if (whiptail --title "PiNode-XMR Update Monero" --yesno "A Monero update has been found for your PiNode-XMR. To continue will install it now.\n\nWould you like to Continue?" 12 78); then
					
									wget -O - https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/update-monero.sh | bash

									else
									whiptail --title "PiNode-XMR Update Monero" --msgbox "Returning to Main Menu. No changes have been made." 12 78;
									fi

								else
									if (whiptail --title "PiNode-XMR Update Monero" --yesno "This device thinks it's running the latest version of Monero.\n\nIf you think this is incorrect you may force an update below.\n\n*Note that a force update can also be used as a reset tool if you think your version is not functioning properly" --yes-button "Force Monero Update" --no-button "Return to Main Menu"  14 78); then

									wget -O - https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/update-monero.sh | bash
		
									else
									whiptail --title "PiNode-XMR Update Monero" --msgbox "Returning to Main Menu. No changes have been made." 12 78;
									fi
								fi
	
							#clean up
							rm /home/pinodexmr/xmr-new-ver.sh
							else
							whiptail --title "PiNode-XMR Update" --msgbox "Returning to Main Menu. No changes have been made." 12 78;
							fi
						;;
				
					"2)")	if (whiptail --title "Update PiNode-XMR" --yesno "This will check for updates to PiNode-XMR Including performance, features and web interface\n\nWould you like to continue?" 12 78); then
							wget https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/new-ver-pi.sh -O /home/pinodexmr/new-ver-pi.sh
							#Permission Setting
							chmod 755 /home/pinodexmr/current-ver-pi.sh
							chmod 755 /home/pinodexmr/new-ver-pi.sh
							#Load Variables
							. /home/pinodexmr/current-ver-pi.sh
							. /home/pinodexmr/new-ver-pi.sh
							echo "\e[36mVersion Info file received: \e[0m"
							echo -e "\e[36mCurrent Version: $CURRENT_VERSION_PI \e[0m"
							echo -e "\e[36mAvailable Version: $NEW_VERSION_PI \e[0m"
							sleep "3"
								if [ $CURRENT_VERSION_PI -lt $NEW_VERSION_PI ]; then
									if (whiptail --title "PiNode-XMR Updater" --yesno "An update has been found for your PiNode-XMR. To continue will install it now.\n\nWould you like to Continue?" 12 78); then
					
									wget -O - https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/update-pinodexmr.sh | bash

									else
									whiptail --title "PiNode-XMR Update" --msgbox "Returning to Main Menu. No changes have been made." 12 78;
									fi

								else
									if (whiptail --title "PiNode-XMR Update" --yesno "This device thinks it's running the latest version of PiNode-XMR.\n\nIf you think this is incorrect you may force an update below.\n\n*Note that a force update can also be used as a reset tool if you think your version is not functioning properly" --yes-button "Force PiNode-XMR Update" --no-button "Return to Main Menu"  14 78); then

									wget -O - https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/update-pinodexmr.sh | bash
		
									else
									whiptail --title "PiNode-XMR Update" --msgbox "Returning to Main Menu. No changes have been made." 12 78;
									fi
								fi
	
							#clean up
							rm /home/pinodexmr/new-ver-pi.sh
							else
							whiptail --title "PiNode-XMR Update" --msgbox "Returning to Main Menu. No changes have been made." 12 78;
							fi
						;;
			
					"3)")	if (whiptail --title "Update Onion-Blockchain-Explorer" --yesno "This will check for and install updates to your Blockchain Explorer\n\nIf updates are found they will be installed\n\nWould you like to continue?" 12 78); then
							wget -q https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/exp-new-ver.sh -O /home/pinodexmr/exp-new-ver.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
							#Permission Setting
							chmod 755 /home/pinodexmr/current-ver-exp.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
							chmod 755 /home/pinodexmr/exp-new-ver.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
							#Load Variables
							. /home/pinodexmr/current-ver-exp.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
							. /home/pinodexmr/exp-new-ver.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
							# Display versions
							echo -e "\e[32mVersion Info file received:\e[0m"
							echo -e "\e[36mCurrent Version: $CURRENT_VERSION_EXP \e[0m"
							echo -e "\e[36mAvailable Version: $NEW_VERSION_EXP \e[0m"
							sleep 3
								if [ $CURRENT_VERSION_EXP -lt $NEW_VERSION_EXP ]; then
									if (whiptail --title "Monero Onion Block Explorer Update" --yesno "An update to the Monero Block Explorer is available, would you like to download and install it now?" --yes-button "Update Now" --no-button "Return to Main Menu"  14 78); then
					
									wget -O - https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/update-explorer.sh | bash

									else
									whiptail --title "Monero Onion Block Explorer Update" --msgbox "Returning to Main Menu. No changes have been made." 12 78;
									fi

								else
									if (whiptail --title "Monero Onion Block Explorer Update" --yesno "This device thinks it's running the latest version of the Block Explorer.\n\nIf you think this is incorrect you may force an update below.\n\n*Note that a force update can also be used as a reset tool if you think your version is not functioning properly" --yes-button "Force Explorer Update" --no-button "Return to Main Menu"  14 78); then

									wget -O - https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/update-explorer.sh | bash
		
									else
									whiptail --title "Monero Onion Block Explorer Update" --msgbox "Returning to Main Menu. No changes have been made." 12 78;
									fi
								fi
	
							#clean up
							rm /home/pinodexmr/exp-new-ver.sh
							else
							whiptail --title "Monero Onion Block Explorer Update" --msgbox "Returning to Main Menu. No changes have been made." 12 78;
							fi
						;;

					"4)")	if (whiptail --title "Update P2Pool" --yesno "This will check for and install updates to P2Pool\n\nIf updates are found they will be installed\n\nWould you like to continue?" 12 78); then
							wget https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/p2pool-new-ver.sh -O /home/pinodexmr/p2pool-new-ver.sh
							#Permission Setting
							chmod 755 /home/pinodexmr/current-ver-p2pool.sh
							chmod 755 /home/pinodexmr/p2pool-new-ver.sh
							#Load Variables
							. /home/pinodexmr/current-ver-p2pool.sh
							. /home/pinodexmr/p2pool-new-ver.sh
							echo "\e[36mVersion Info file received: \e[0m"
							echo -e "\e[36mCurrent Version: $CURRENT_VERSION_P2POOL \e[0m"
							echo -e "\e[36mAvailable Version: $NEW_VERSION_P2POOL \e[0m"
							sleep "3"
								if [ $CURRENT_VERSION_P2POOL -lt $NEW_VERSION_P2POOL ]; then
									if (whiptail --title "P2POOL UPDATER" --yesno "An update has been found for P2Pool. To continue will install it now.\n\nWould you like to Continue?" 12 78); then
					
									wget -O - https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/update-p2pool.sh | bash

									else
									whiptail --title "P2POOL UPDATER" --msgbox "Returning to Main Menu. No changes have been made." 12 78;
									fi

								else
									if (whiptail --title "P2POOL UPDATER" --yesno "This device thinks it's running the latest version of P2Pool.\n\nIf you think this is incorrect you may force an update below.\n\n*Note that a force update can also be used as a reset tool if you think your version is not functioning properly" --yes-button "Force PiNode-XMR Update" --no-button "Return to Main Menu"  14 78); then

									wget -O - https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/update-p2pool.sh | bash
		
									else
									whiptail --title "P2POOL UPDATER" --msgbox "Returning to Main Menu. No changes have been made." 12 78;
									fi
								fi
	
							#clean up
							rm /home/pinodexmr/p2pool-new-ver.sh
							else
							whiptail --title "P2POOL UPDATER" --msgbox "Returning to Main Menu. No changes have been made." 12 78;
							fi
						;;

					"5)")	if (whiptail --title "Update Monero-LWS" --yesno "Monero-LWS is still in development and as such has no version number. I can delete the version on this device and install the latest from source?\nSSL Certificates will be preserved\n\n**Note: To install Monero-LWS for the first time please use the installer found in the 'Node Tools' Menu\n\nWould you like to continue?" 12 78); then
							wget https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/new-ver-lws.sh -O /home/pinodexmr/new-ver-lws.sh
							#Permission Setting
							chmod 755 /home/pinodexmr/current-ver-lws.sh
							chmod 755 /home/pinodexmr/new-ver-lws.sh
							#Load Variables
							. /home/pinodexmr/current-ver-lws.sh
							. /home/pinodexmr/new-ver-lws.sh
							echo "\e[36mVersion Info file received: \e[0m"
							echo -e "\e[36mCurrent Version: $CURRENT_VERSION_LWS \e[0m"
							echo -e "\e[36mAvailable Version: $NEW_VERSION_LWS \e[0m"
							sleep "3"
								if [ $CURRENT_VERSION_LWS -lt $NEW_VERSION_LWS ]; then
									if (whiptail --title "Update Monero-LWS" --yesno "An update has been found for Monero-LWS. To continue will install it now.\n\nWould you like to Continue?" 12 78); then
					
									wget -O - https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/update-monero-lws.sh | bash

									else
									whiptail --title "Update Monero-LWS" --msgbox "Returning to Main Menu. No changes have been made." 12 78;
									fi

								else
									if (whiptail --title "Update Monero-LWS" --yesno "This device thinks it's running the latest version of Monero-LWS.\n\nIf you think this is incorrect you may force an update below.\n\n*Note that a force update can also be used as a reset tool if you think your version is not functioning properly" --yes-button "Force PiNode-XMR Update" --no-button "Return to Main Menu"  14 78); then

									wget -O - https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/update-monero-lws.sh | bash
		
									else
									whiptail --title "Update Monero-LWS" --msgbox "Returning to Main Menu. No changes have been made." 12 78;
									fi
								fi
	
							#clean up
							rm /home/pinodexmr/new-ver-lws.sh
							else
							whiptail --title "Update Monero-LWS" --msgbox "Returning to Main Menu. No changes have been made." 12 78;
							fi
						;;											

					"6)")	if (whiptail --title "Update Atomic Swap Utility" --yesno "This setting will check for and update (re-install) the latest XMR->ETH Atomic utility from AthanorLabs\n\nNote that this tool is currently in Beta, it may be possible to lose funds\nWould you like to continue?" 12 78); then
							wget https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/new-ver-atomicSwap.sh -O /home/pinodexmr/new-ver-atomicSwap.sh
							#Permission Setting
							chmod 755 /home/pinodexmr/current-ver-atomicSwap.sh
							chmod 755 /home/pinodexmr/new-ver-atomicSwap.sh
							#Load Variables
							. /home/pinodexmr/current-ver-atomicSwap.sh
							. /home/pinodexmr/new-ver-atomicSwap.sh
							echo "\e[36mVersion Info file received: \e[0m"
							echo -e "\e[36mCurrent Version: $CURRENT_VERSION_ATOMICSWAP \e[0m"
							echo -e "\e[36mAvailable Version: $NEW_VERSION_ATOMICSWAP \e[0m"
							sleep "3"
								if [ $CURRENT_VERSION_ATOMICSWAP -lt $NEW_VERSION_ATOMICSWAP ]; then
									if (whiptail --title "Update Atomic Swap Utility" --yesno "An update has been found for the Atomic Swap utility. To continue will install it now.\n\nWould you like to Continue?" 12 78); then
					
									wget -O - https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/update-atomicSwap.sh | bash

									else
									whiptail --title "Update Atomic Swap Utility" --msgbox "Returning to Main Menu. No changes have been made." 12 78;
									fi

								else
									if (whiptail --title "Update Atomic Swap Utility" --yesno "This device thinks it's running the latest version of the Atomic Swap utility.\n\nIf you think this is incorrect you may force an update below.\n\n*Note that a force update can also be used as a clean install/reset tool if you think your version is not functioning properly" --yes-button "Force Atomic Swap Update" --no-button "Return to Main Menu"  14 78); then

									wget -O - https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/update-atomicSwap.sh | bash
		
									else
									whiptail --title "Update Atomic Swap Utility" --msgbox "Returning to Main Menu. No changes have been made." 12 78;
									fi
								fi
	
							#clean up
							rm /home/pinodexmr/new-ver-atomicSwap.sh
							else
							whiptail --title "Update Atomic Swap Utility" --msgbox "Returning to Main Menu. No changes have been made." 12 78;
							fi
						;;	

					"7)")	if (whiptail --title "Update System" --yesno "PiNode-XMR will perform a check for background system updates of your OS's packages and dependencies.\n\nWould you like to continue?" 12 78); then
							clear; 
							##Update and Upgrade system
							echo -e "\e[32mReceiving and applying Ubuntu updates to latest versions\e[0m"
							sudo apt-get update 2>&1 | tee -a debug.log
							sudo apt-get --yes -o Dpkg::Options::="--force-confnew" upgrade 2>&1 | tee -a debug.log
							sudo apt-get --yes -o Dpkg::Options::="--force-confnew" dist-upgrade 2>&1 | tee -a debug.log
							##Auto remove any obsolete packages
							sudo apt-get autoremove -y 2>&1 | tee -a debug.log
							sleep 2
							else
							sleep 2
							fi
						;;
				esac
				. /home/pinodexmr/setup.sh
				;;

		"4)")CHOICE4=$(whiptail --backtitle "Welcome" --title "PiNode-XMR Settings" --menu "\n\nNode Tools" 20 60 10 \
				"1)" "Start/Stop Blockchain Explorer" \
				"2)" "Prune Node" \
				"3)" "Pop Blocks" \
				"4)" "Clear Peer List" \
				"5)" "Monero-LWS Install" \
				"6)" "Monero-LWS Admin" \
				"7)" "Generate SSL self-signed certificates" 2>&1 >/dev/tty)
				
				case $CHOICE4 in
							"1)") . /home/pinodexmr/setupMenuScripts/setup-explorer.sh	#Has functional legacy script, will change this format one day.
								;;
								
							"2)")	if (whiptail --title "PiNode-XMR Prune Monero Node" --yesno "This will configure your node to run 'pruned' to reduce storage space required for the blockchain\n\n***This command only be run once and cannot be undone***\n\nAre you sure you want to continue?" 12 78); then
									. /home/pinodexmr/setupMenuScripts/setup-prune-node.sh
									else
									sleep 2
									fi
								;;
				
							"3)")	if (whiptail --title "PiNode-XMR Pop Blocks" --yesno "If you have errors for duplicate transactions in your log file, you may be able to 'pop' off the last blocks from the chain to un-freeze the sync process without syncing from scratch\n\nStop your Monero node before performing this action\n\nWould you like to continue?" 14 78); then
									. /home/pinodexmr/setupMenuScripts/pop-blocks.sh
									else
									sleep 2
									fi
								;;
							"4)")	if (whiptail --title "PiNode-XMR Clear Peer List" --yesno "There are occassions where the group of nodes you are connected to incorrectly report the top block height or otherwise prevent normal node operation. This option deletes p2pstate.bin and will allow Monero to build a fresh peer list on next node start.\n\nStop your Monero node before performing this action\n\nWould you like to continue?" 14 78); then
									rm ~/.bitmonero/p2pstate.bin
									echo -e "\e[32mDeleteing Peer list...\e[0m"
									sleep 3
									whiptail --title "PiNode-XMR Clear Peer List" --msgbox "The peer list (p2pstate.bin) has been deleted. When you restart your node a fresh list will be created." 20 78
									else
									whiptail --title "PiNode-XMR Clear Peer List" --msgbox "No changes have been made" 20 78
									sleep 2
									fi
								;;								
							"5)") if (whiptail --title "Monero-LWS Install" --yesno "This will install the functional but developing Monero-LWS service\nOnce complete, the generated SSL cert will also need installing on your wallet device\n\nWould you like to continue?" 14 78); then
									echo -e "\e[32mChecking dependencies\e[0m"
									sleep 2
									#Check dependencies (Should be installed already from Monero install)
									sudo apt update && sudo apt install build-essential cmake libboost-all-dev libssl-dev libzmq3-dev doxygen graphviz -y
									echo -e "\e[32mDownloading VTNerd Monero-LWS\e[0m"
									sleep 2
									git clone --recursive https://github.com/vtnerd/monero-lws.git;
									echo -e "\e[32mConfiguring install\e[0m"
									sleep 2									
									cd monero-lws
									git checkout release-v0.2_0.18
									mkdir build && cd build
									cmake -DMONERO_SOURCE_DIR=/home/pinodexmr/monero -DMONERO_BUILD_DIR=/home/pinodexmr/monero/build/release ..
									echo -e "\e[32mBuilding VTNerd Monero-LWS\e[0m"
									sleep 2								
									make
									cd
									echo -e "\e[32mCreating SSL Certificates for wallet device bound to this local IP\e[0m"
									sleep 2	
									mkdir ~/lwsSslCert && cd lwsSslCert
									#Generate cert and key
									. /home/pinodexmr/setupMenuScripts/antelleGenrateIpCert.sh $(hostname -I)
									sleep 2
									#Generate Android Cert and Key pair
									openssl pkcs12 -export -in cert.pem -inkey key.pem -out androidCert.p12
									sleep 2
									#Set IP for systemd monero-lws
									. /home/pinodexmr/variables/IPforLWS.sh
									#Install complete
									whiptail --title "Monero-LWS installer" --msgbox "\nThe Monero-LWS installation is complete and SSL certificates have been generated.\n\nA copy of the generated /home/pinodexmr/lwsSslCert/cert.pem should be added to (windows) 'LocalComputer\Trusted Root Certification Authorities\Certificates' for use with MyMonero desktop... " 20 78
									whiptail --title "Monero-LWS installer" --msgbox "\nFor Android Lightweight Wallets the\n/home/pinodexmr/lwsSslCert/androidCert.p12 should be installed via\n'Settings>Security>Encryption&Credentials>Install certificates from storage'..." 20 78
											if (whiptail --title "Monero-LWS Install" --yesno "\nWould you like to start Monero-LWS on PiNodeXMR boot?" 14 78); then
											sudo systemctl enable monero-lws.service
											else
											sleep 1
											fi
											if (whiptail --title "Monero-LWS Install" --yesno "\nWould you like to start Monero-LWS now?" 14 78); then
											sudo systemctl start monero-lws.service
											else
											sleep 1
											fi
									whiptail --title "Monero-LWS install complete" --msgbox "\nInstallation and configuration is now complete\n\nUSe the 'Monero-LWS Admin' tool to add your address and view key pair" 12 78
									else
									sleep 2
									fi
								;;
								"6)") if (whiptail --title "PiNode-XMR Monero-LWS Admin" --yesno "This tool is for adding your wallet address and view key so Monero-LWS can scan for your transactions in the background.\n\nMonero-LWS must be installed first\n\nWould you like to continue?" 14 78); then
								# use temp file 
								_temp="./dialog.$$"
								#Wallet Address - set
								whiptail --title "Monero-LWS Wallet Address" --inputbox "Enter the Wallet address you would like to monitor:" 10 60 2>$_temp
								# set wallet addres var
								walletadd=$( cat $_temp )
								shred $_temp
								whiptail --title "Monero-LWS Wallet View Key" --msgbox "\nYou will next be asked for the view key for the address you have just provided. Take care to ensure you provide the VIEW KEY, NOT THE PRIVATE KEY" 12 78
								whiptail --title "Monero-LWS Wallet View Key" --inputbox "VIEW KEY:" 10 60 2>$_temp
								# set wallet addres var
								viewkey=$( cat $_temp )
								shred $_temp
								echo -e "\e[32mConfiguring Monero_LWS with the provided Wallet address and View Key...\e[0m"
								sleep 2
								/home/pinodexmr/monero-lws/build/src/monero-lws-admin add_account $walletadd $viewkey
								##Rescan address: (Tell lws-admin to rescan from block <0> (change as required) for tx belonging to address and continue to monitor)
								/home/pinodexmr/monero-lws/build/src/monero-lws-admin rescan 0 $walletadd
								whiptail --title "Monero-LWS Wallet added" --msgbox "\nThe credentials you supplied have been passed to Monero-LWS for monitoring. The service is scanning for historic outputs that belong to that wallet which will take some time on this first run." 12 78
								else
									. /home/pinodexmr/setup.sh
									fi
								;;
								"7)") if (whiptail --title "SSL Certificate generation" --yesno "This will now generate self-signed SSL certifictes for this device.\n\nNote that the certificate is bound to this local device IP $(hostname -I | awk '{print $1}'), a change to this address will render this certificate invalid.\n\nYou will also be asked to create an 'export password', this will be used by you to add the generated certificates to your other devices\n\nWould you like to continue?" 18 78); then
								cd
								echo -e "\e[32mCreating SSL Certificates for wallet device bound to this local IP\e[0m"
								sleep 2	
								mkdir ~/lwsSslCert && cd lwsSslCert
								#Generate cert and key
								. /home/pinodexmr/setupMenuScripts/antelleGenrateIpCert.sh $(hostname -I)
								sleep 2
								#Generate Android Cert and Key pair
								openssl pkcs12 -export -in cert.pem -inkey key.pem -out androidCert.p12
								sleep 2
								#Generation complete
								whiptail --title "SSL Certificate generation" --msgbox "\nSSL certificates have been generated.\n\nA copy of the generated\n/home/pinodexmr/lwsSslCert/cert.pem\nshould be added to (windows)\n'LocalComputer\Trusted Root Certification Authorities\Certificates'\nfor use with desktop devices... " 20 78
								whiptail --title "SSL Certificate generation" --msgbox "\nFor Android devices the\n/home/pinodexmr/lwsSslCert/androidCert.p12\nshould be installed via\n'Settings>Security>Encryption&Credentials>Install certificates from storage'...\n\nReturning to setup menu" 20 78
								else
									sleep 2
									fi
								;;									
				esac
				. /home/pinodexmr/setup.sh
				;;

			"5)")CHOICE5=$(whiptail --backtitle "Athanor Labs" --title "Atomic Swap" --menu "\n\nSystem Settings" 20 60 10 \
				"1)" "View Balances" \
				"2)" "View Monero Address + QR" \
				"3)" "View Etherum Address + QR" \
				"4)" "View Past Swaps" \
				"5)" "View Status of Ongoing Swaps" \
				"6)" "Clear All Offers" \
				"7)" "Show My Offers" \
				"8)" "Discover available XMR->ETH Offers" \
				"9)" "Suggested XMR ETH Exchange rate" \
				"10)" "Make XMR Swap Offer" \
				"11)" "Take XMR Swap Offer" 2>&1 >/dev/tty)
				
				case $CHOICE5 in
		
					"1)") 	whiptail --title "Atomic Swap" --msgbox "Shows addresses and balances including blocks until unlock\n\nThe Swap service must be running before using this option." 8 78;
							~/atomic-swap/bin/swapcli balances
							read -p "Press enter to continue"
					;;
					
					"2)") 	whiptail --title "Atomic Swap" --msgbox "Shows Monero Address and QR code\n\nThe Swap service must be running before using this option.\nQR code may require large resolution display" 8 78;
							~/atomic-swap/bin/swapcli xmr-address
							read -p "Press enter to continue"
					;;
			
					"3)")	whiptail --title "Atomic Swap" --msgbox "Shows Ethereum Address and QR code\n\nThe Swap service must be running before using this option.\nQR code may require large resolution display" 8 78;
							~/atomic-swap/bin/swapcli eth-address
							read -p "Press enter to continue"
					;;

					"4)")	whiptail --title "Atomic Swap" --msgbox "Shows past swaps summary and status." 8 78;
							~/atomic-swap/bin/swapcli past
							read -p "Press enter to continue"
					;;

					"5)")	whiptail --title "Atomic Swap" --msgbox "Shows status of ongoing swaps." 8 78;
							~/atomic-swap/bin/swapcli ongoing
							read -p "Press enter to continue"
					;;					
					
					"6)")	whiptail --title "Atomic Swap" --msgbox "If you have any offers published, this command will revoke them if not yet taken." 8 78;
							~/atomic-swap/bin/swapcli clear-offers
							read -p "Press enter to continue"
					;;
					"7)")	whiptail --title "Atomic Swap" --msgbox "If you have any offers published, this command will display them." 8 78;
							~/atomic-swap/bin/swapcli get-offers
							read -p "Press enter to continue"
					;;
					"8)")	whiptail --title "Atomic Swap" --msgbox "This will show all available offers your node is aware of" 8 78;
							~/atomic-swap/bin/swapcli query-all
							read -p "Press enter to continue"
					;;
					"9)")	whiptail --title "Atomic Swap" --msgbox "This will show the current market XMR ETH exchange rate from Chainlink oracle" 8 78;
							~/atomic-swap/bin/swapcli suggested-exchange-rate
							read -p "Press enter to continue"							
					;;
					"10)")	if (whiptail --title "Atomic Swap" --yesno "This will create an offer to sell your XMR and recieve Ethereum\n\nYou can set the Min/Max Quantity and Exchange rate\n\nWould you like to continue?" 14 78); then
								# use temp file for setting Quantity and exchange rate storage (value shredded after use)
								_temp="./dialog.$$"
								#XMR Quantity Min - set
								whiptail --title "" --inputbox "Enter the MINIMUM quantity of XMR you would like to offer to sell in this trade:\n*Note must be above 0.01 ETH in value" 10 60 2>$_temp
								# set XMR Quantity var
								XMRQMIN=$( cat $_temp )
								shred $_temp
								#XMR Quantity Max - set
								whiptail --title "" --inputbox "Enter the MAXIMUM quantity of XMR you would like to offer to sell in this trade:\n*Note must be above 0.01 ETH in value" 10 60 2>$_temp
								# set XMR Quantity var
								XMRQMAX=$( cat $_temp )
								shred $_temp
								# set XMR Exchange rate var
								whiptail --title "Atomic Swap" --msgbox "You will next be asked for the exchange rate you are willing to swap your XMR to ETH at.\nNote that if you hold an ETH balance of less than 0.01 your conversion will be carried out by a relayer on your behalf. In this case a relayer will subtract their fee of 0.01 ETH from your swap.\n\nContinue to see the current exchange rate" 12 78
								~/atomic-swap/bin/swapcli suggested-exchange-rate
								echo -e "\e[32mThe above rate is sourced from Chainlink Oracle. Please do your research thoroughly of the correct rate before ofering your XMR trade publicly. Atomic Swaps cannot be reversed!\e[0m"
								read -p "Press enter to continue"
								whiptail --title "Atomic Swap" --inputbox "XMR ETH Exchange rate:" 10 60 2>$_temp
								XMRX=$( cat $_temp )
								shred $_temp
										#CONFIRM EXCHANGE
										if (whiptail --title "Atomic Swap Confirmation" --yesno "You are offering to sell XMR with the following conditions to the buyer:\nMinium XMR buyer can request:${XMRQMIN}\nMaximum XMR buyer can request:${XMRQMAX}\n\nAt Exchange rate of 1XMR to ${XMRX} ETH\n\nSelecting Yes to this box will publish the trade!\nAre you Sure you want to continue?" 14 78); then
											sleep 2
											~/atomic-swap/bin/swapcli make --min-amount $XMRQMIN --max-amount $XMRQMAX --exchange-rate $XMRX --detached --swapd-port 5000
											read -p "Press enter to continue"
										else
										whiptail --title "Atomic Swap" --msgbox "*****TRADE ABORTED*****\n\nXMR TO ETH trade has been cancelled" 12 78
										sleep 2
										fi

							else
							sleep 2
							fi
					;;
					"11)")	if (whiptail --title "Atomic Swap" --yesno "This will allow you to take a publicised offer from the Web-Ui\n\nYou can review your offer in the last step\n\nWould you like to continue?" 14 78); then
								# use temp file for setting Quantity and exchange rate storage (value shredded after use)
								_temp="./dialog.$$"
								# Set ETH Quantity var
								whiptail --title "" --inputbox "Enter the quantity of ETH you would like to swap for XMR in this trade:\n*Note must be between sellers minimum/maximum" 10 60 2>$_temp
								ETHAMOUNT=$( cat $_temp )
								shred $_temp
								#Peer ID - set
								whiptail --title "" --inputbox "Enter the 'PEER ID' for this trade:\n*Note this is from the sellers listing in Web-Ui" 10 60 2>$_temp
								PEERID=$( cat $_temp )
								shred $_temp
								#Offer ID - set
								whiptail --title "" --inputbox "Lastly enter the 'OFFER ID' for this trade:\n*Note this is from the sellers listing in Web-Ui" 10 60 2>$_temp
								OFFERID=$( cat $_temp )
								shred $_temp
										#CONFIRM EXCHANGE
										if (whiptail --title "Atomic Swap Confirmation" --yesno "You are offering to swap your ETH for a providers XMR with the following conditions:\nYou are supplying:${ETHAMOUNT}ETH\nTo:${PEERID}\n\nFor Offer ID ${OFFERID}\n\nSelecting Yes to this box will action the swap!\nLast change to double check the exchange rate.\nAre you Sure you want to continue?" 14 78); then
											sleep 2
											~/atomic-swap/bin/swapcli take --peer-id $PEERID --offer-id $OFFERID --provides-amount $ETHAMOUNT
											read -p "Press enter to continue"
										else
										whiptail --title "Atomic Swap" --msgbox "*****TRADE ABORTED*****\n\nETH TO XMR trade has been cancelled" 12 78
										sleep 2
										fi

							else
							sleep 2
							fi
					;;
													
				esac
				. /home/pinodexmr/setup.sh
				;;		

		"6)")CHOICE6=$(whiptail --backtitle "Welcome" --title "PiNode-XMR Settings" --menu "\n\nExtra Network Tools" 20 60 10 \
				"1)" "Install/Update tor" \
				"2)" "View tor NYX interface" \
				"3)" "Start/Stop tor Service" \
				"4)" "Install I2P Server/Router" \
				"5)" "Start/Stop I2P Server/Router" \
				"6)" "Install PiVPN" \
				"7)" "Web Interface Password set/enable/disable" \
				"8)" "Configure Monero Peer Ban List" \
				"9)" "Install NoIP.com Dynamic DNS" 2>&1 >/dev/tty)
				
				case $CHOICE6 in
		
							"1)")	if (whiptail --title "PiNode-XMR Install tor" --yesno "Some countries for censorship, political or legal reasons do not look favorably on tor and other anonymity services, so tor is not installed on this device by default. However this option can install or update it now for you.\n\nWould you like to continue?" 14 78); then
									. /home/pinodexmr/setupMenuScripts/setup-tor.sh
									else
									sleep 2
									fi
								;;

							"2)")	if (whiptail --title "PiNode-XMR tor NYX" --yesno "This tool will allow you to monitor tor bandwidth usage\n\nWhen prompted for a password, enter 'PiNodeXMR'\nAnd to exit the utility press 'CTRL+C' \n\nWould you like to continue?" 12 78); then
									nyx
									else
									sleep 2
									fi
								;;
								
							"3)")	if (whiptail --title "PiNode-XMR Start/Stop tor" --yesno "Manually Start or Stop the service." --yes-button "Start tor" --no-button "Stop tor"  14 78); then
									sudo systemctl start tor
									sudo systemctl enable tor
									whiptail --title "PiNode-XMR tor" --msgbox "The tor service has been started" 12 78;
									sleep 2
									else
									sudo systemctl stop tor
									sudo systemctl disable tor
									whiptail --title "PiNode-XMR tor" --msgbox "The tor service has been stopped" 12 78;
									sleep 2
									fi
								;;
								
							"4)")	if (whiptail --title "PiNode-XMR Install I2P" --yesno "This will install the I2P server/router onto your PiNode-XMR\n\nWould you like to continue?" 14 78); then
									. /home/pinodexmr/setupMenuScripts/setup-i2p.sh
									else
									sleep 2
									fi
								;;
							
							"5)")	if (whiptail --title "PiNode-XMR Start/Stop I2P" --yesno "Manually Start or Stop the service." --yes-button "Start I2P" --no-button "Stop I2P"  14 78); then
									i2prouter start;
									sudo systemctl start i2p;
									sudo systemctl enable i2p;
									whiptail --title "PiNode-XMR I2P" --msgbox "I2P server has been started\n\nYou now have access to the I2P config menu found at $(hostname -I | awk '{print $1}'):7657" 12 78;
									sleep 2
									else
									i2prouter stop;
									sudo systemctl stop i2p;
									sudo systemctl disable i2p;
									whiptail --title "PiNode-XMR I2P" --msgbox "I2P server has been stopped" 12 78;
									sleep 2
									fi
								;;
								
							"6)")	if (whiptail --title "PiNode-XMR PiVPN Install" --yesno "This feature will install PiVPN on your PiNode-XMR\n\nPiVPN is a simple to configure openVPN server.\n\nFor more info see https://pivpn.dev/\n\nWould you like to continue?" 12 78); then
									. /home/pinodexmr/setupMenuScripts/setup-PiVPN.sh
									else
									sleep 2
									fi
								;;
								

							"7)")	CHOICE7=$(whiptail --backtitle "PiNode-XMR Settings" --title "Web Interface Password Set/Enable/Disable" --menu "\n\nWeb Interface Password Set/Enable/Disable" 20 60 10 \
										"1)" "Set Web Interface Password" \
										"2)" "Enable Web Interface Password" \
										"3)" "Disable Web Interface Password" 2>&1 >/dev/tty)
				
									case $CHOICE7 in

								"1)")	if (whiptail --title "Web Interface Password Set" --yesno "Set the password used to access the Web Interface" --yes-button "Set Password" --no-button "Cancel" 14 78); then
									sudo htpasswd -c /etc/apache2/.htpasswd pinodexmr
									sleep 3
									whiptail --title "Web Interface Password Set" --msgbox "The PiNodeXMR Web Interface Password has been configured" 12 78;
									else
									sleep 2
									fi
								;;

								"2)")	if (whiptail --title "Web Interface Password Enable" --yesno "This will enable the requirement for password authentication to access the Web Interface\n\nWould you like to continue?" 12 78); then
									sudo cp /home/pinodexmr/variables/000-default-passwordAuthEnabled.conf /etc/apache2/sites-enabled/000-default.conf
									sudo chown root /etc/apache2/sites-enabled/000-default.conf
									sudo chmod 777 /etc/apache2/sites-enabled/000-default.conf
									sudo systemctl restart apache2
									#Update htmlPasswordRequired flag for use with PiNodeXMR updater script
	echo "#!/bin/sh
HTMLPASSWORDREQUIRED=TRUE" > /home/pinodexmr/variables/htmlPasswordRequired.sh
									sleep 2
									whiptail --title "Web Interface Password Enable" --msgbox "The PiNodeXMR Web Interface Password has been enabled" 12 78;
									else
									sleep 2
									fi
								;;

								"3)")	if (whiptail --title "Web Interface Password Disable" --yesno "This will disable the requirement for password authentication to access the Web Interface\n\nWould you like to continue?" 12 78); then
									sudo cp /home/pinodexmr/variables/000-default-passwordAuthDisabled.conf /etc/apache2/sites-enabled/000-default.conf
									sudo chown root /etc/apache2/sites-enabled/000-default.conf
									sudo chmod 777 /etc/apache2/sites-enabled/000-default.conf
									sudo systemctl restart apache2
									#Update htmlPasswordRequired flag for use with PiNodeXMR updater script
	echo "#!/bin/sh
HTMLPASSWORDREQUIRED=FALSE" > /home/pinodexmr/variables/htmlPasswordRequired.sh									
									sleep 2
									whiptail --title "Web Interface Password Disable" --msgbox "The PiNodeXMR Web Interface Password has been disabled" 12 78;
									else
									sleep 2
									fi
								;;

									esac
								;;

							"8)")	NUM_BAN_LIST_ENTRIES="$(wc -l ~/ban_list_InUse.txt | awk '{print $1}')"
									CHOICE8=$(whiptail --backtitle "PiNode-XMR Settings" --title "Monero Peer Ban List conifg" --menu "\n\nMonero Peer Ban List conifg:\n\nBan List currently holds $NUM_BAN_LIST_ENTRIES ENTRIES" 20 60 10 \
										"1)" "Add 'Boog900' Ban List" \
										"2)" "Add gui.xmr.pm Ban List" \
										"3)" "Add list of banned IPs from local source" \
										"4)" "Remove all entries from ban list" 2>&1 >/dev/tty)
				
									case $CHOICE8 in

								"1)")	if (whiptail --title "Monero Peer Ban List conifg" --yesno "This will merge the 'spy node' ban list from https://github.com/Boog900/monero-ban-list into your local ban list" --yes-button "Merge Ban List" --no-button "Cancel" 14 78); then
									wget https://raw.githubusercontent.com/Boog900/monero-ban-list/refs/heads/main/ban_list.txt
									cat ban_list.txt >> ban_list_InUse.txt
									rm ban_list.txt
									NUM_BAN_LIST_ENTRIES="$(wc -l ~/ban_list_InUse.txt | awk '{print $1}')"
									sleep 3
									whiptail --title "Monero Peer Ban List conifg" --msgbox "The IPs listed in Boog900 Ban List have been added to your local ban list.\nYour list now contains $NUM_BAN_LIST_ENTRIES ENTRIES\nStop&Start your node to take effect." 12 78;
									else
									sleep 2
									fi
								;;

								"2)")	if (whiptail --title "Monero Peer Ban List conifg" --yesno "This will merge the malicious node IP list from https://gui.xmr.pm/files/block.txt into your local ban list" --yes-button "Merge Ban List" --no-button "Cancel" 14 78); then
									wget https://gui.xmr.pm/files/block.txt
									cat block.txt >> ban_list_InUse.txt
									rm block.txt
									NUM_BAN_LIST_ENTRIES="$(wc -l ~/ban_list_InUse.txt | awk '{print $1}')"
									sleep 3
									whiptail --title "Monero Peer Ban List conifg" --msgbox "The IPs listed gui.xmr.pm have been added to your local ban list.\nYour list now contains $NUM_BAN_LIST_ENTRIES ENTRIES\nStop&Start your node to take effect." 12 78;
									else
									sleep 2
									fi
								;;

								"3)")	if (whiptail --title "Monero Peer Ban List conifg" --yesno "This option allos you to add a list of Banned IPs from a local file or URL\nSee https://github.com/shermand100/PiNodeXMR/wiki/Use-of-IP-Ban-Lists for instructions" --yes-button "Continue" --no-button "Cancel" 14 78); then
									BAN_LIST_PATH=$(whiptail --inputbox "Enter URL or file path of Ban List" 8 39 --title "Monero Peer Ban List conifg" 3>&1 1>&2 2>&3);
									#Detect if path is either URL or local file
									REGEX='(https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]'
									if [[ $BAN_LIST_PATH =~ $REGEX ]]
									then
									wget $BAN_LIST_PATH -O ban_list.txt
									cat ban_list.txt >> ban_list_InUse.txt
									rm ban_list.txt
									 else
 									cat $BAN_LIST_PATH >> ban_list_InUse.txt
									rm $BAN_LIST_PATH
									fi
									
									NUM_BAN_LIST_ENTRIES="$(wc -l ~/ban_list_InUse.txt | awk '{print $1}')"
									sleep 3
									whiptail --title "Monero Peer Ban List conifg" --msgbox "Your list now contains $NUM_BAN_LIST_ENTRIES ENTRIES\n\nStop&Start your node to take effect." 12 78;
									else
									sleep 2
									fi
								;;								

								"4)")	if (whiptail --title "Monero Peer Ban List conifg" --yesno "This will delete the entire contents of your local IP Ban list.\nAfter which you can then re-populate the list from an option in the previous menu." --yes-button "Clear Ban List" --no-button "Cancel" 14 78); then
									> ban_list_InUse.txt
									NUM_BAN_LIST_ENTRIES="$(wc -l ~/ban_list_InUse.txt | awk '{print $1}')"
									sleep 3
									whiptail --title "Monero Peer Ban List conifg" --msgbox "The localy held list of banned IPs has been cleared.\nYour list now contains $NUM_BAN_LIST_ENTRIES ENTRIES\nStop&Start your node to take effect." 12 78;
									else
									sleep 2
									fi

									esac
								;;								

							"9)")	if (whiptail --title "PiNode-XMR Configure Dynamic DNS" --yesno "This will configure Dynamic DNS from NoIP.com\n\nFirst create a free account with them and have your username and password before continuing\n\nWould you like to continue?" 12 78); then
									. /home/pinodexmr/setupMenuScripts/setup-noip.sh
									else
									sleep 2
									fi
								;;								
				esac
				. /home/pinodexmr/setup.sh
				;;
esac
clear
echo -e "\e[32mReturn to the settings menu at any time by typing 'setup'\e[0m";
