#!/bin/bash

					whiptail --title "PiNode-XMR Updater" --msgbox "\n\nPerforming PiNode-XMR update to version ${NEW_VERSION_PI}" 12 78
					
##Update and Upgrade system
echo -e "\e[32mReceiving and applying Raspberry OS updates to latest versions\e[0m"
sleep 3
sudo apt update && sudo apt upgrade -y
echo -e "\e[32mSuccess\e[0m"
sleep 3

##Checking all dependencies are installed for --- Web Interface
echo -e "\e[32m##Checking all dependencies are installed for --- Web Interface\e[0m"
sleep 3
sudo apt install apache2 shellinabox php7.3 php7.3-cli php7.3-common php7.3-curl php7.3-gd php7.3-json php7.3-mbstring php7.3-mysql php7.3-xml -y
echo -e "\e[32mSuccess\e[0m"
sleep 3

##Checking all dependencies are installed for --- Monero
echo -e "\e[32m##Checking all dependencies are installed for --- Monero\e[0m"
sleep 3
sudo apt install git build-essential cmake libpython2.7-dev libboost-all-dev miniupnpc pkg-config libunbound-dev graphviz doxygen libunwind8-dev libssl-dev libcurl4-openssl-dev libgtest-dev libreadline-dev libzmq3-dev libsodium-dev libhidapi-dev libhidapi-libusb0 -y
echo -e "\e[32mSuccess\e[0m"
sleep 3

##Checking all dependencies are installed for --- miscellaneous (security tools-fail2ban-ufw, menu tool-dialog, screen, mariadb)
echo -e "\e[32m##Checking all dependencies are installed for --- Miscellaneous\e[0m"
sleep 3
sudo apt install mariadb-client-10.0 mariadb-server-10.0 screen exfat-fuse exfat-utils fail2ban ufw dialog python3-pip -y
	## Installing new dependencies for IP2Geo map creation
sudo apt install python3-numpy python3-matplotlib libgeos-dev python3-geoip2 python3-mpltoolkits.basemap -y
	##More IP2Geo dependencies
sudo pip3 install ip2geotools
echo -e "\e[32mSuccess\e[0m"
sleep 3

##Check config of Swap file
echo -e "\e[32mChecking configuration of 2GB Swap file (required for Monero build and IP2Geo Mapping)\e[0m"
sleep 3
wget https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/Development-Raspbian/etc/dphys-swapfile
sudo mv /home/pinodexmr/dphys-swapfile /etc/dphys-swapfile
sudo chmod 664 /etc/dphys-swapfile
sudo chown root /etc/dphys-swapfile
sudo dphys-swapfile setup
sleep 5
sudo dphys-swapfile swapon
echo -e "\e[32mSwap file of 2GB Configured and enabled\e[0m"
sleep 3

					
		#Download update files

##Clone PiNode-XMR to device from git
echo -e "\e[32mDownloading PiNode-XMR files\e[0m"
sleep 3
git clone -b Development-Raspbian --single-branch https://github.com/monero-ecosystem/PiNode-XMR.git

					#Backup User values
					echo -e "\e[32mCreating backups of any settings you have customised\e[0m"
					echo -e "\e[32m*****\e[0m"					
					echo -e "\e[32mIf a setting did not exist on your previous version you may see some errors here for missing files, these can safely be ignored\e[0m"					
					echo -e "\e[32m*****\e[0m"						
					sleep 8
					mv /home/pinodexmr/add-peer.sh /home/pinodexmr/add-peer_retain.sh
					mv /home/pinodexmr/bootstatus.sh /home/pinodexmr/bootstatus_retain.sh
					mv /home/pinodexmr/credits.sh /home/pinodexmr/credits_retain.sh
					mv /home/pinodexmr/current-ver.sh /home/pinodexmr/current-ver_retain.sh
					mv /home/pinodexmr/current-ver-exp.sh /home/pinodexmr/current-ver-exp_retain.sh
					mv /home/pinodexmr/current-ver-pi.sh /home/pinodexmr/current-ver-pi_retain.sh
					mv /home/pinodexmr/difficulty.sh /home/pinodexmr/difficulty_retain.sh
					mv /home/pinodexmr/error.log /home/pinodexmr/error_retain.log
					mv /home/pinodexmr/explorer-flag.sh /home/pinodexmr/explorer-flag_retain.sh
					mv /home/pinodexmr/i2p-address.sh /home/pinodexmr/i2p-address_retain.sh
					mv /home/pinodexmr/i2p-port.sh /home/pinodexmr/i2p-port_retain.sh
					mv /home/pinodexmr/i2p-tx-proxy-port.sh /home/pinodexmr/i2p-tx-proxy-port_retain.sh
					mv /home/pinodexmr/in-peers.sh /home/pinodexmr/in-peers_retain.sh
					mv /home/pinodexmr/limit-rate-down.sh /home/pinodexmr/limit-rate-down_retain.sh
					mv /home/pinodexmr/limit-rate-up.sh /home/pinodexmr/limit-rate-up_retain.sh
					mv /home/pinodexmr/mining-address.sh /home/pinodexmr/mining-address_retain.sh
					mv /home/pinodexmr/mining-intensity.sh /home/pinodexmr/mining-intensity_retain.sh
					mv /home/pinodexmr/monero-port.sh /home/pinodexmr/monero-port_retain.sh
					mv /home/pinodexmr/monero-port-public-free.sh /home/pinodexmr/monero-port-public-free_retain.sh
					mv /home/pinodexmr/monero-stats-port.sh /home/pinodexmr/monero-stats-port_retain.sh
					mv /home/pinodexmr/out-peers.sh /home/pinodexmr/out-peers_retain.sh
					mv /home/pinodexmr/payment-address.sh /home/pinodexmr/payment-address_retain.sh
					mv /home/pinodexmr/prunestatus.sh /home/pinodexmr/prunestatus_status.sh
					mv /home/pinodexmr/RPCp.sh /home/pinodexmr/RPCp_retain.sh
					mv /home/pinodexmr/RPCu.sh /home/pinodexmr/RPCu_retain.sh
					echo -e "\e[32mUser-set configuration saved\e[0m"					
					
				#Install Update
					echo -e "\e[32mInstalling update\e[0m"
					sleep 2
					
				##Add PiNode-XMR systemd services
					echo -e "\e[32mAdd PiNode-XMR systemd services\e[0m"
					sleep 3
					sudo mv /home/pinodexmr/PiNode-XMR/etc/systemd/system/*.service /etc/systemd/system/
					sudo chmod 644 /etc/systemd/system/*.service
					sudo chown root /etc/systemd/system/*.service
					echo -e "\e[32mSuccess\e[0m"
					sleep 3
					
				##Add PiNode-XMR php settings
					echo -e "\e[32mAdd PiNode-XMR php settings to allow for IP2Geo database upload\e[0m"
					sleep 3
					sudo mv /home/pinodexmr/PiNode-XMR/etc/php/7.3/apache2/php.ini /etc/php/7.3/apache2/
					sudo chmod 644 /etc/systemd/system/*.service
					sudo chown root /etc/systemd/system/*.service
					sudo /etc/init.d/apache2 restart
					echo -e "\e[32mSuccess\e[0m"
					sleep 3
					
				##Setup local hostname
					echo -e "\e[32mEnable local hostname pinodexmr.local\e[0m"
					sleep 3				
					sudo mv /home/pinodexmr/PiNode-XMR/etc/avahi/avahi-daemon.conf /etc/avahi/avahi-daemon.conf
					sudo /etc/init.d/avahi-daemon restart
					echo -e "\e[32mSuccess\e[0m"					
					
				##Copy PiNode-XMR scripts to home folder
					echo -e "\e[32mMoving PiNode-XMR scripts into possition\e[0m"
					sleep 3
					mv /home/pinodexmr/PiNode-XMR/home/pinodexmr/* /home/pinodexmr/
					mv /home/pinodexmr/PiNode-XMR/home/pinodexmr/.profile /home/pinodexmr/
					sudo chmod 777 -R /home/pinodexmr/*
					echo -e "\e[32mSuccess\e[0m"
					sleep 3					
					

				##Download (git clone) Web-UI template
					echo -e "\e[32mDownloading Web-UI template\e[0m"
					sleep 3
					git clone https://github.com/designmodo/Flat-UI.git
					
					echo -e "\e[32mInstalling Web-UI template\e[0m"
					sleep 3
					sudo mv /home/pinodexmr/Flat-UI/app/ /var/www/html/
					sudo mv /home/pinodexmr/Flat-UI/dist/ /var/www/html/
					
					echo -e "\e[32mConfiguring Web-UI template with PiNode-XMR pages\e[0m"
					sleep 3
					sudo mv /home/pinodexmr/PiNode-XMR/HTML/*.* /var/www/html/
					sudo cp -R /home/pinodexmr/PiNode-XMR/HTML/docs/ /var/www/html/
					sudo chown www-data -R /var/www/html/
					sudo chmod 777 -R /var/www/html/
					echo -e "\e[32mSuccess\e[0m"
										
					#Restore User Values
					echo -e "\e[32mRestoring your personal settings\e[0m"
					sleep 2
					mv /home/pinodexmr/add-peer_retain.sh /home/pinodexmr/add-peer.sh
					mv /home/pinodexmr/bootstatus_retain.sh /home/pinodexmr/bootstatus.sh
					mv /home/pinodexmr/credits_retain.sh /home/pinodexmr/credits.sh
					mv /home/pinodexmr/current-ver_retain.sh /home/pinodexmr/current-ver.sh
					mv /home/pinodexmr/current-ver-exp_retain.sh /home/pinodexmr/current-ver-exp.sh
					mv /home/pinodexmr/current-ver-pi_retain.sh /home/pinodexmr/current-ver-pi.sh
					mv /home/pinodexmr/difficulty_retain.sh /home/pinodexmr/difficulty.sh
					mv /home/pinodexmr/error_retain.log /home/pinodexmr/error.log
					mv /home/pinodexmr/explorer-flag_retain.sh /home/pinodexmr/explorer-flag.sh
					mv /home/pinodexmr/i2p-address_retain.sh /home/pinodexmr/i2p-address.sh
					mv /home/pinodexmr/i2p-port_retain.sh /home/pinodexmr/i2p-port.sh
					mv /home/pinodexmr/i2p-tx-proxy-port_retain.sh /home/pinodexmr/i2p-tx-proxy-port.sh
					mv /home/pinodexmr/in-peers_retain.sh /home/pinodexmr/in-peers.sh
					mv /home/pinodexmr/limit-rate-down_retain.sh /home/pinodexmr/limit-rate-down.sh
					mv /home/pinodexmr/limit-rate-up_retain.sh /home/pinodexmr/limit-rate-up.sh
					mv /home/pinodexmr/mining-address_retain.sh /home/pinodexmr/mining-address.sh
					mv /home/pinodexmr/mining-intensity_retain.sh /home/pinodexmr/mining-intensity.sh
					mv /home/pinodexmr/monero-port_retain.sh /home/pinodexmr/monero-port.sh
					mv /home/pinodexmr/monero-port-public-free_retain.sh /home/pinodexmr/monero-port-public-free.sh
					mv /home/pinodexmr/monero-stats-port_retain.sh /home/pinodexmr/monero-stats-port.sh
					mv /home/pinodexmr/out-peers_retain.sh /home/pinodexmr/out-peers.sh
					mv /home/pinodexmr/payment-address_retain.sh /home/pinodexmr/payment-address.sh
					mv /home/pinodexmr/prunestatus_status.sh /home/pinodexmr/prunestatus.sh
					mv  /home/pinodexmr/RPCp_retain.sh/home/pinodexmr/RPCp.sh
					mv /home/pinodexmr/RPCu_retain.sh /home/pinodexmr/RPCu.sh
					echo -e "\e[32mUser configuration restored\e[0m"
					
					
				##Update crontab
					echo -e "\e[32mUpdating crontab tasks\e[0m"
					sleep 3
					sudo crontab /home/pinodexmr/PiNode-XMR/var/spool/cron/crontabs/root
					crontab /home/pinodexmr/PiNode-XMR/var/spool/cron/crontabs/pinodexmr
					echo -e "\e[32mSuccess\e[0m"
					sleep 3

					#Update system version number to new one installed
					echo -e "\e[32mUpdate system version number\e[0m"
					echo "#!/bin/bash
CURRENT_VERSION_PI=$NEW_VERSION_PI" > /home/pinodexmr/current-ver-pi.sh
					echo -e "\e[32mSuccess\e[0m"
					sleep 2
					
					#Clean up files
					echo -e "\e[32mCleanup leftover directories\e[0m"
					sleep 2
					sudo rm -r /home/pinodexmr/pinode-xmr/
					rm /home/pinodexmr/new-ver-pi.sh
					echo -e "\e[32mSuccess\e[0m"
					sleep 2
					
					whiptail --title "PiNode-XMR Updater" --msgbox "\n\nYour PiNode-XMR has been updated to version ${NEW_VERSION_PI}" 12 78
					


#Return to menu
./setup.sh
