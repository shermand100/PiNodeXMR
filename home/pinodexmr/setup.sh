#!/bin/bash

		#HEIGHT=20
		#WIDTH=60
		#CHOICE_HEIGHT=8
		CHOICE=$(whiptail --backtitle "Welcome" --title "PiNode-XMR Settings" --menu "\n\nWhat would you like to configure?" 20 60 10 \
	"1)" "Exit to Command line" \
    "2)" "System Settings" \
	"3)" "Update Tools" \
	"4)" "Node Tools" \
	"5)" "Extra Network Tools" 2>&1 >/dev/tty)
	
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
		
					"1)")	whiptail --title "PiNode-XMR Support Scripts" --yesno "This will download and run the PiNodeXMR support script #1 from https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/ubuntuServer-20.04/supportScript1.sh\n\nWould you like to continue?" 12 78); then
					wget -O - https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/ubuntuServer-20.04/supportScript1.sh | bash
							else
					sleep 2
							fi
					;;
				
					"2)") 	if (whiptail --title "PiNode-XMR Support Scripts" --yesno "This will download and run the PiNodeXMR support script #2 from https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/ubuntuServer-20.04/supportScript2.sh\n\nWould you like to continue?" 12 78); then
					wget -O - https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/ubuntuServer-20.04/supportScript2.sh | bash
							else
					sleep 2
							fi
					;;
					
					"3)") 	if (whiptail --title "PiNode-XMR Support Scripts" --yesno "This will download and run the PiNodeXMR support script #3 from https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/ubuntuServer-20.04/supportScript3.sh\n\nWould you like to continue?" 12 78); then
					wget -O - https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/ubuntuServer-20.04/supportScript3.sh | bash
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
				"6)" "Update system packages and dependencies" 2>&1 >/dev/tty)
				
				case $CHOICE3 in
		
					"1)")	if (whiptail --title "PiNode-XMR Update Monero" --yesno "This will run a check to see if a Monero update is available\n\nIf an update is found PiNode-XMR will perform the update.\n\n***This will take several hours***\n\nWould you like to continue?" 12 78); then
							. /home/pinodexmr/setupMenuScripts/setup-update-monero.sh
							else
							sleep 2
							fi
						;;
				
					"2)")	if (whiptail --title "Update PiNode-XMR" --yesno "This will check for updates to PiNode-XMR Including performance, features and web interface\n\nWould you like to continue?" 12 78); then
							. /home/pinodexmr/setupMenuScripts/setup-update-pinodexmr.sh
							else
							sleep 2
							fi
						;;
			
					"3)")	if (whiptail --title "Update Onion-Blockchain-Explorer" --yesno "This will check for and install updates to your Blockchain Explorer\n\nIf updates are found they will be installed\n\nWould you like to continue?" 12 78); then
							. /home/pinodexmr/setupMenuScripts/setup-update-explorer.sh
							else
							sleep 2
							fi
						;;

					"4)")	if (whiptail --title "Update P2Pool" --yesno "This will check for and install updates to P2Pool\n\nIf updates are found they will be installed\n\nWould you like to continue?" 12 78); then
							. /home/pinodexmr/setupMenuScripts/setup-update-p2pool.sh
							else
							sleep 2
							fi
						;;

					"5)")	if (whiptail --title "Update Monero-LWS" --yesno "Monero-LWS is still in development and as such has no version number. I can delete the version on this device and install the latest from source?\nSSL Certificates will be preserved\n\n**Note: To install Monero-LWS for the first time please use the installer found in the 'Node Tools' Menu\n\nWould you like to continue?" 12 78); then
							. /home/pinodexmr/setupMenuScripts/setup-update-monero-lws.sh
							else
							sleep 2
							fi
						;;											
						
					"6)")	if (whiptail --title "Update System" --yesno "PiNode-XMR will perform a check for background system updates of your OS's packages and dependencies.\n\nWould you like to continue?" 12 78); then
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
				"4)" "Monero-LWS Install" \
				"5)" "Monero-LWS Admin" \
				"6)" "Generate SSL self-signed certificates" 2>&1 >/dev/tty)
				
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
							"4)") if (whiptail --title "Monero-LWS Install" --yesno "This will install the functional but developing Monero-LWS service\nOnce complete, the generated SSL cert will also need installing on your wallet device\n\nWould you like to continue?" 14 78); then
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
								"5)") if (whiptail --title "PiNode-XMR Monero-LWS Admin" --yesno "This tool is for adding your wallet address and view key so Monero-LWS can scan for your transactions in the background.\n\nMonero-LWS must be installed first\n\nWould you like to continue?" 14 78); then
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
								"6)") if (whiptail --title "SSL Certificate generation" --yesno "This will now generate self-signed SSL certifictes for this device.\n\nNote that the certificate is bound to this local device IP $(hostname -I | awk '{print $1}'), a change to this address will render this certificate invalid.\n\nYou will also be asked to create an 'export password', this will be used by you to add the generated certificates to your other devices\n\nWould you like to continue?" 18 78); then
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

		"5)")CHOICE5=$(whiptail --backtitle "Welcome" --title "PiNode-XMR Settings" --menu "\n\nExtra Network Tools" 30 60 15 \
				"1)" "Install tor" \
				"2)" "View tor NYX interface" \
				"3)" "Start/Stop tor Service" \
				"4)" "Install I2P Server/Router" \
				"5)" "Start/Stop I2P Server/Router" \
				"6)" "Install PiVPN" \
				"7)" "Web Interface Password set/enable/disable" \
				"8)" "Install NoIP.com Dynamic DNS" 2>&1 >/dev/tty)
				
				case $CHOICE5 in
		
							"1)")	if (whiptail --title "PiNode-XMR Install tor" --yesno "Some countries for censorship, political or legal reasons do not look favorably on tor and other anonymity services, so tor is not installed on this device by default. However this option can install it now for you.\n\nWould you like to continue?" 14 78); then
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
								

							"7)")	CHOICE6=$(whiptail --backtitle "PiNode-XMR Settings" --title "Web Interface Password Set/Enable/Disable" --menu "\n\nWeb Interface Password Set/Enable/Disable" 30 60 15 \
										"1)" "Set Web Interface Password" \
										"2)" "Enable Web Interface Password" \
										"3)" "Disable Web Interface Password" 2>&1 >/dev/tty)
				
									case $CHOICE6 in

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

							"8)")	if (whiptail --title "PiNode-XMR Configure Dynamic DNS" --yesno "This will configure Dynamic DNS from NoIP.com\n\nFirst create a free account with them and have your username and password before continuing\n\nWould you like to continue?" 12 78); then
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
