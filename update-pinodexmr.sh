#!/bin/bash


					whiptail --title "PiNode-XMR Updater" --msgbox "\n\nPerforming PiNode-XMR update to latest version" 12 78
					
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
echo -e "\e[32mChecking all dependencies are installed for --- Miscellaneous\e[0m"
sleep 3
sudo apt install mariadb-client-10.0 mariadb-server-10.0 screen exfat-fuse exfat-utils fail2ban ufw dialog python3-pip jq -y
	## Installing new dependencies for IP2Geo map creation
sudo apt install python3-numpy libgeos-dev python3-geoip2 libatlas-base-dev python3-mpltoolkits.basemap -y
	##More IP2Geo dependencies - matplotlibv3.2.1 required for basemap support - post v3.3 basemap depreciated
sudo pip3 install ip2geotools matplotlib==3.2.1

		#Download update files

##Clone PiNode-XMR to device from git
echo -e "\e[32mDownloading PiNode-XMR files\e[0m"
sleep 3
git clone -b Raspbian-install --single-branch https://github.com/monero-ecosystem/PiNode-XMR.git


					#Backup User values
					echo -e "\e[32mCreating backups of any settings you have customised\e[0m"
					echo -e "\e[32m*****\e[0m"					
					echo -e "\e[32mIf a setting did not exist on your previous version you may see some errors here for missing files, these can safely be ignored\e[0m"					
					echo -e "\e[32m*****\e[0m"						
					sleep 8
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
					mv /home/pinodexmr/out-peers.sh /home/pinodexmr/out-peers_retain.sh
					mv /home/pinodexmr/payment-address.sh /home/pinodexmr/payment-address_retain.sh
					mv /home/pinodexmr/prunestatus.sh /home/pinodexmr/prunestatus_status.sh
					mv /home/pinodexmr/RPCp.sh /home/pinodexmr/RPCp_retain.sh
					mv /home/pinodexmr/RPCu.sh /home/pinodexmr/RPCu_retain.sh
					mv /home/pinodexmr/monero-rpcpay-port.sh /home/pinodexmr/monero-rpcpay-port_retain.sh
					mv /home/pinodexmr/add-i2p-peer.sh /home/pinodexmr/add-i2p-peer_retain.sh
					mv /home/pinodexmr/add-tor-peer.sh /home/pinodexmr/add-tor-peer_retain.sh					
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
					sleep 2
						##Updating PiNode-XMR scripts in home directory
					echo -e "\e[32mUpdating PiNode-XMR scripts in home directory\e[0m"
					sleep 2
					sudo rm -R /home/pinodexmr/flock #if folder not removed produces error, cannot be overwritten if not empty
					mv /home/pinodexmr/PiNode-XMR/home/pinodexmr/* /home/pinodexmr/
					mv /home/pinodexmr/PiNode-XMR/home/pinodexmr/.profile /home/pinodexmr/
					chmod 777 /home/pinodexmr/*
					echo -e "\e[32mSuccess\e[0m"
					sleep 2
					
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
					echo -e "\e[32mMoving PiNode-XMR scripts into position\e[0m"
					sleep 3
					#error suppressed from failed to copy directories as lock files don't require update
					mv /home/pinodexmr/PiNode-XMR/home/pinodexmr/* /home/pinodexmr/ 2>/dev/null 
					mv /home/pinodexmr/PiNode-XMR/home/pinodexmr/.profile /home/pinodexmr/
					sudo chmod 777 -R /home/pinodexmr/*
					echo -e "\e[32mSuccess\e[0m"
					sleep 3
		
					echo -e "\e[32mConfiguring Web-UI template with PiNode-XMR pages\e[0m"
					sleep 3
					sudo mv /home/pinodexmr/PiNode-XMR/HTML/*.* /var/www/html/
					sudo mv /home/pinodexmr/PiNode-XMR/HTML/images /var/www/html
					sudo chown www-data -R /var/www/html/
					sudo chmod 777 -R /var/www/html/
					echo -e "\e[32mSuccess\e[0m"
										
					#Restore User Values
					echo -e "\e[32mRestoring your personal settings\e[0m"
					sleep 2
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
					mv /home/pinodexmr/out-peers_retain.sh /home/pinodexmr/out-peers.sh
					mv /home/pinodexmr/payment-address_retain.sh /home/pinodexmr/payment-address.sh
					mv /home/pinodexmr/prunestatus_status.sh /home/pinodexmr/prunestatus.sh
					mv /home/pinodexmr/RPCp_retain.sh /home/pinodexmr/RPCp.sh
					mv /home/pinodexmr/RPCu_retain.sh /home/pinodexmr/RPCu.sh
					mv /home/pinodexmr/monero-rpcpay-port_retain.sh /home/pinodexmr/monero-rpcpay-port.sh
					mv /home/pinodexmr/add-i2p-peer_retain.sh /home/pinodexmr/add-i2p-peer.sh
					mv /home/pinodexmr/add-tor-peer_retain.sh /home/pinodexmr/add-tor-peer.sh					
					echo -e "\e[32mUser configuration restored\e[0m"
					
				##Add Selta's ban list
					echo -e "\e[32mAdding Selstas Ban List\e[0m"
					sleep 3
					wget -O block.txt https://gui.xmr.pm/files/block_tor.txt
					echo -e "\e[32mSuccess\e[0m"
					sleep 3

				##Set Swappiness lower
				echo -e "\e[32mDecreasing swappiness\e[0m"
				sleep 3				
				sudo sysctl vm.swappiness=10
				echo -e "\e[32mSuccess\e[0m"
				sleep 3				

				##Update crontab
					echo -e "\e[32mUpdating crontab tasks\e[0m"
					sleep 3
					sudo crontab /home/pinodexmr/PiNode-XMR/var/spool/cron/crontabs/root
					crontab /home/pinodexmr/PiNode-XMR/var/spool/cron/crontabs/pinodexmr
					echo -e "\e[32mSuccess\e[0m"
					sleep 3
					
					#Attempt update of tor hidden service settings
					echo -e "\e[32mUpdate of tor hidden service settings - If you have not installed tor this process will fail - this is expected\e[0m"
					sleep 6
					wget https://github.com/monero-ecosystem/PiNode-XMR/blob/Raspbian-install/etc/tor/torrc
					echo -e "\e[32mApplying Settings...\e[0m"
					sleep 3
					sudo mv /home/pinodexmr/torrc /etc/tor/torrc
					sudo chmod 644 /etc/tor/torrc
					sudo chown root /etc/tor/torrc
					echo -e "\e[32mRestarting tor service...\e[0m"
					sudo service tor restart
					sleep 3
					#Delete unused torrc file on event of update fail (tor not installed by user)
					sudo rm /home/pinodexmr/torrc 2>/dev/null

					#Update system version number to new one installed
					wget https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/Raspbian-install/new-ver-pi.sh -O /home/pinodexmr/new-ver-pi.sh
					chmod 755 /home/pinodexmr/new-ver-pi.sh
					. /home/pinodexmr/new-ver-pi.sh
					echo -e "\e[32mUpdate system version number\e[0m"
					echo "#!/bin/bash
CURRENT_VERSION_PI=$NEW_VERSION_PI" > /home/pinodexmr/current-ver-pi.sh
					echo -e "\e[32mSuccess\e[0m"
					sleep 2
					
					#Update Monero version number to new one installed
					echo -e "\e[32mUpdate Monero version number to allow manual update\e[0m"
					echo "#!/bin/bash
CURRENT_VERSION=0" > /home/pinodexmr/current-ver.sh
					echo -e "\e[32mSuccess\e[0m"
					sleep 2
					
					#Clean up files
					echo -e "\e[32mCleanup leftover directories\e[0m"
					sleep 2

					sudo rm -r /home/pinodexmr/PiNode-XMR/
					rm /home/pinodexmr/new-ver-pi.sh
					echo -e "\e[32mSuccess\e[0m"
					sleep 2
					
					whiptail --title "PiNode-XMR Updater" --msgbox "\n\nYour PiNode-XMR has been updated" 12 78
					


#Return to menu
./setup.sh
