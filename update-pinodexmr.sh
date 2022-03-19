#!/bin/bash
#Create/ammend debug file for handling update errors:
touch debug.log
echo "
####################
" >>debug.log
echo "Start update-pinodexmr.sh script $(date)" >>debug.log
echo "
####################
" >>debug.log
sleep 1	
##Update and Upgrade system
	echo "Update and Upgrade system" >>debug.log
echo -e "\e[32mReceiving and applying Raspbian updates to latest versions\e[0m"
sleep 3
sudo apt update 2> >(tee -a debug.log >&2) && sudo apt upgrade -y 2> >(tee -a debug.log >&2)

##Checking all dependencies are installed for --- Web Interface
	echo "Update dependencies for Web interface" >>debug.log
echo -e "\e[32m##Checking all dependencies are installed for --- Web Interface\e[0m"
sleep 3
sudo apt install apache2 shellinabox php php-common -y 2> >(tee -a debug.log >&2)
echo -e "\e[32mSuccess\e[0m"
sleep 3

##Checking all dependencies are installed for --- Monero
	echo "Update dependencies for Monero" >>debug.log
echo -e "\e[32m##Checking all dependencies are installed for --- Monero\e[0m"
sleep 3
sudo apt install git build-essential cmake libpython2.7-dev libboost-all-dev miniupnpc libminiupnpc-dev pkg-config libunbound-dev graphviz doxygen libunwind8-dev libssl-dev libcurl4-openssl-dev libgtest-dev libreadline-dev libzmq3-dev libsodium-dev libhidapi-dev libhidapi-libusb0 -y 2> >(tee -a debug.log >&2)
echo -e "\e[32mSuccess\e[0m"
sleep 3

##Checking all dependencies are installed for --- miscellaneous (security tools-fail2ban-ufw, menu tool-dialog, screen, mariadb)
	echo "Update dependencies for Misc" >>debug.log
echo -e "\e[32mChecking all dependencies are installed for --- Miscellaneous\e[0m"
sleep 3
sudo apt install mariadb-client mariadb-server screen exfat-fuse exfat-utils fail2ban ufw dialog jq ntfs-3g -y 2> >(tee -a debug.log >&2)

		#Download update files

##Replace file /etc/sudoers to set global sudo permissions/rules (required to add new permissions to www-data user for interface buttons)
echo -e "\e[32mDownload and replace /etc/sudoers file\e[0m"
sleep 3
wget https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/ubuntuServer-20.04/etc/sudoers
sudo chmod 0440 /home/pinodexmr/sudoers
sudo chown root /home/pinodexmr/sudoers
sudo mv /home/pinodexmr/sudoers /etc/sudoers
echo -e "\e[32mGlobal permissions changed\e[0m"
sleep 3

##Clone PiNode-XMR to device from git
	echo "Downlaod PiNodeXMR files" >>debug.log
echo -e "\e[32mDownloading PiNode-XMR files\e[0m"
sleep 3
git clone -b ubuntuServer-20.04 --single-branch https://github.com/monero-ecosystem/PiNode-XMR.git 2> >(tee -a debug.log >&2)

			wget https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/ubuntuServer-20.04/new-ver-pi.sh -O /home/pinodexmr/new-ver-pi.sh 2> >(tee -a debug.log >&2)
			chmod 755 /home/pinodexmr/new-ver-pi.sh 2> >(tee -a debug.log >&2)
			. /home/pinodexmr/new-ver-pi.sh
			echo "Latest Version: $NEW_VERSION_PI "
			echo -e "\e[32mDownloading PiNode-XMR files\e[0m"
			sleep 2
		#Download all Armbian PiNodeXMR Files (git clone)			
			git clone -b ubuntuServer-20.04 --single-branch https://github.com/monero-ecosystem/PiNode-XMR.git 2> >(tee -a debug.log >&2)

				#Backup User values
						echo "Backup variables" >>debug.log
					echo -e "\e[32mCreating backups of any settings you have customised\e[0m"
					echo -e "\e[32m*****\e[0m"					
					echo -e "\e[32mIf a setting did not exist on your previous version you may see some errors here for missing files, these can safely be ignored\e[0m"					
					echo -e "\e[32m*****\e[0m"						
					sleep 8
					mv /home/pinodexmr/bootstatus.sh /home/pinodexmr/bootstatus_retain.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/credits.sh /home/pinodexmr/credits_retain.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/current-ver.sh /home/pinodexmr/current-ver_retain.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/current-ver-exp.sh /home/pinodexmr/current-ver-exp_retain.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/current-ver-pi.sh /home/pinodexmr/current-ver-pi_retain.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/difficulty.sh /home/pinodexmr/difficulty_retain.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/error.log /home/pinodexmr/error_retain.log 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/explorer-flag.sh /home/pinodexmr/explorer-flag_retain.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/i2p-address.sh /home/pinodexmr/i2p-address_retain.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/i2p-port.sh /home/pinodexmr/i2p-port_retain.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/i2p-tx-proxy-port.sh /home/pinodexmr/i2p-tx-proxy-port_retain.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/in-peers.sh /home/pinodexmr/in-peers_retain.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/limit-rate-down.sh /home/pinodexmr/limit-rate-down_retain.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/limit-rate-up.sh /home/pinodexmr/limit-rate-up_retain.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/mining-address.sh /home/pinodexmr/mining-address_retain.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/mining-intensity.sh /home/pinodexmr/mining-intensity_retain.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/monero-port.sh /home/pinodexmr/monero-port_retain.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/monero-port-public-free.sh /home/pinodexmr/monero-port-public-free_retain.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/out-peers.sh /home/pinodexmr/out-peers_retain.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/payment-address.sh /home/pinodexmr/payment-address_retain.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/prunestatus.sh /home/pinodexmr/prunestatus_status.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/RPCp.sh /home/pinodexmr/RPCp_retain.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/RPCu.sh /home/pinodexmr/RPCu_retain.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/monero-rpcpay-port.sh /home/pinodexmr/monero-rpcpay-port_retain.s 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/add-i2p-peer.sh /home/pinodexmr/add-i2p-peer_retain.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/add-tor-peer.sh /home/pinodexmr/add-tor-peer_retain.sh 2> >(tee -a debug.log >&2)
					echo -e "\e[32mUser-set configuration saved\e[0m"					
					
				#Remove old html images (prevents error when trying to overwrite non-empty directory)
				rm -R /home/pinodexmr/PiNode-XMR/HTML/images

					
		#Install Update
			echo -e "\e[32mInstalling update\e[0m"
			sleep 2
				##Add PiNode-XMR systemd services
						echo "Update services" >>debug.log
					echo -e "\e[32mAdd PiNode-XMR systemd services\e[0m"
					sleep 3
					sudo mv /home/pinodexmr/PiNode-XMR/etc/systemd/system/*.service /etc/systemd/system/ 2> >(tee -a debug.log >&2)
					sudo chmod 644 /etc/systemd/system/*.service 2> >(tee -a debug.log >&2)
					sudo chown root /etc/systemd/system/*.service 2> >(tee -a debug.log >&2)
					sudo systemctl daemon-reload 2> >(tee -a debug.log >&2)
					sudo systemctl start statusOutputs.service 2> >(tee -a debug.log >&2)
					sudo systemctl enable statusOutputs.service 2> >(tee -a debug.log >&2)
					echo -e "\e[32mSuccess\e[0m"
					sleep 3

				##Updating PiNode-XMR scripts in home directory
						echo "Update PiNodeXMR scripts" >>debug.log
					echo -e "\e[32mUpdating PiNode-XMR scripts in home directory\e[0m"
					sleep 2
					sudo rm -R /home/pinodexmr/flock  2> >(tee -a debug.log >&2) #if folder not removed produces error, cannot be overwritten if not empty
					mv /home/pinodexmr/PiNode-XMR/home/pinodexmr/* /home/pinodexmr/ 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/PiNode-XMR/home/pinodexmr/.profile /home/pinodexmr/ 2> >(tee -a debug.log >&2)
					chmod 777 /home/pinodexmr/* 2> >(tee -a debug.log >&2)
					echo -e "\e[32mSuccess\e[0m"
					sleep 2

				##Add PiNode-XMR php settings
						echo "Update php settings" >>debug.log
					echo -e "\e[32mAdd PiNode-XMR php settings to allow for IP2Geo database upload\e[0m"
					sleep 3
					sudo mv /home/pinodexmr/PiNode-XMR/etc/php/7.3/apache2/php.ini /etc/php/7.3/apache2/ 2> >(tee -a debug.log >&2)
					sudo chmod 644 /etc/systemd/system/*.service 2> >(tee -a debug.log >&2)
					sudo chown root /etc/systemd/system/*.service 2> >(tee -a debug.log >&2)
				#Configure apache server for access to monero log file
					sudo mv /home/pinodexmr/PiNode-XMR/etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf 2> >(tee -a debug.log >&2)
					sudo chmod 777 /etc/apache2/sites-enabled/000-default.conf 2> >(tee -a debug.log >&2)
					sudo chown root /etc/apache2/sites-enabled/000-default.conf 2> >(tee -a debug.log >&2)					
					sudo /etc/init.d/apache2 restart 2> >(tee -a debug.log >&2)
					echo -e "\e[32mSuccess\e[0m"
					sleep 3
				##Setup local hostname
						echo "Update hostname (avahi)" >>debug.log
					echo -e "\e[32mEnable local hostname pinodexmr.local\e[0m"
					sleep 3				
					sudo mv /home/pinodexmr/PiNode-XMR/etc/avahi/avahi-daemon.conf /etc/avahi/avahi-daemon.conf 2> >(tee -a debug.log >&2)
					sudo /etc/init.d/avahi-daemon restart 2> >(tee -a debug.log >&2)
					echo -e "\e[32mSuccess\e[0m"

				##Update html template
						echo "Update html template" >>debug.log	
					echo -e "\e[32mConfiguring Web-UI template with PiNode-XMR pages\e[0m"
					sleep 3
					#First move hidden file specifically .htaccess file then entire directory
					sudo mv /home/pinodexmr/PiNode-XMR/HTML/.htaccess /var/www/html/ 2> >(tee -a debug.log >&2)
					sudo mv /home/pinodexmr/PiNode-XMR/HTML/*.* /var/www/html/ 2> >(tee -a debug.log >&2)
					#Demo Images are installed if a new user to this version. Error of 'directory not empty' suppressed so user created images aren't overwritten.
					sudo mv /home/pinodexmr/PiNode-XMR/HTML/images /var/www/html 2> >(tee -a debug.log >&2)
					sudo chown www-data -R /var/www/html/ 2> >(tee -a debug.log >&2)
					sudo chmod 777 -R /var/www/html/ 2> >(tee -a debug.log >&2)
					echo -e "\e[32mSuccess\e[0m"
										
				#Restore User Values
						echo "Restore user variables" >>debug.log	
					echo -e "\e[32mRestoring your personal settings\e[0m"
					sleep 2
					mv /home/pinodexmr/bootstatus_retain.sh /home/pinodexmr/bootstatus.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/credits_retain.sh /home/pinodexmr/credits.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/current-ver_retain.sh /home/pinodexmr/current-ver.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/current-ver-exp_retain.sh /home/pinodexmr/current-ver-exp.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/current-ver-pi_retain.sh /home/pinodexmr/current-ver-pi.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/difficulty_retain.sh /home/pinodexmr/difficulty.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/error_retain.log /home/pinodexmr/error.log 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/explorer-flag_retain.sh /home/pinodexmr/explorer-flag.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/i2p-address_retain.sh /home/pinodexmr/i2p-address.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/i2p-port_retain.sh /home/pinodexmr/i2p-port.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/i2p-tx-proxy-port_retain.sh /home/pinodexmr/i2p-tx-proxy-port.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/in-peers_retain.sh /home/pinodexmr/in-peers.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/limit-rate-down_retain.sh /home/pinodexmr/limit-rate-down.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/limit-rate-up_retain.sh /home/pinodexmr/limit-rate-up.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/mining-address_retain.sh /home/pinodexmr/mining-address.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/mining-intensity_retain.sh /home/pinodexmr/mining-intensity.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/monero-port_retain.sh /home/pinodexmr/monero-port.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/monero-port-public-free_retain.sh /home/pinodexmr/monero-port-public-free.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/out-peers_retain.sh /home/pinodexmr/out-peers.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/payment-address_retain.sh /home/pinodexmr/payment-address.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/prunestatus_status.sh /home/pinodexmr/prunestatus.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/RPCp_retain.sh /home/pinodexmr/RPCp.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/RPCu_retain.sh /home/pinodexmr/RPCu.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/monero-rpcpay-port_retain.sh /home/pinodexmr/monero-rpcpay-port.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/add-i2p-peer_retain.sh /home/pinodexmr/add-i2p-peer.sh 2> >(tee -a debug.log >&2)
					mv /home/pinodexmr/add-tor-peer_retain.sh /home/pinodexmr/add-tor-peer.sh 2> >(tee -a debug.log >&2)
					echo -e "\e[32mUser configuration restored\e[0m"
				
				##Set Swappiness lower
						echo "Set swappiness" >>debug.log
					echo -e "\e[32mDecreasing swappiness\e[0m"
					sleep 3				
					sudo sysctl vm.swappiness=10 2> >(tee -a debug.log >&2)
					echo -e "\e[32mSuccess\e[0m"
					sleep 3						
				##Update crontab
						echo "Update crontabs" >>debug.log
					echo -e "\e[32mUpdating crontab tasks\e[0m"
					sleep 3
					sudo crontab /home/pinodexmr/PiNode-XMR/var/spool/cron/crontabs/root 2> >(tee -a debug.log >&2)
					crontab /home/pinodexmr/PiNode-XMR/var/spool/cron/crontabs/pinodexmr 2> >(tee -a debug.log >&2)
					echo -e "\e[32mSuccess\e[0m"
					sleep 3
		
				#Attempt update of tor hidden service settings
						echo "Update torrc settings - if installed" >>debug.log
					echo -e "\e[32mUpdate of tor hidden service settings - If you have not installed tor this process will fail - this is expected\e[0m"
					sleep 6
			wget https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/ubuntuServer-20.04/etc/tor/torrc 2> >(tee -a debug.log >&2)
					echo -e "\e[32mApplying Settings...\e[0m"
					sleep 3
					sudo mv /home/pinodexmr/torrc /etc/tor/torrc 2> >(tee -a debug.log >&2)
					sudo chmod 644 /etc/tor/torrc 2> >(tee -a debug.log >&2)
					sudo chown root /etc/tor/torrc 2> >(tee -a debug.log >&2)
				#Insert user specific local IP for correct hiddenservice redirect (line 73 overwrite)
					sudo sed -i "73s/.*/HiddenServicePort 18081 $(hostname -I | awk '{print $1}'):18081/" /etc/tor/torrc
					echo -e "\e[32mRestarting tor service...\e[0m"
					sudo service tor restart 2> >(tee -a debug.log >&2)
					sleep 3

				#Restart statusOutputs script service for changes to take effect
				sudo systemctl restart statusOutputs

				#Delete unused torrc file on event of update fail (tor not installed by user)
					sudo rm /home/pinodexmr/torrc 2> >(tee -a debug.log >&2)

#Update system version number to new one installed
				echo "Update PiNodeXMR version number" >>debug.log
					wget https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/ubuntuServer-20.04/new-ver-pi.sh -O /home/pinodexmr/new-ver-pi.sh 2> >(tee -a debug.log >&2)
					chmod 755 /home/pinodexmr/new-ver-pi.sh 2> >(tee -a debug.log >&2)
					. /home/pinodexmr/new-ver-pi.sh 2> >(tee -a debug.log >&2)
					echo -e "\e[32mUpdate system version number\e[0m"
					echo "#!/bin/bash
CURRENT_VERSION_PI=$NEW_VERSION_PI" > /home/pinodexmr/current-ver-pi.sh 2> >(tee -a debug.log >&2)
					echo -e "\e[32mSuccess\e[0m"
					sleep 2
					
				#Clean up files
				echo "Cleanup leftover files" >>debug.log
					echo -e "\e[32mCleanup leftover directories\e[0m"
					sleep 2

					sudo rm -r /home/pinodexmr/PiNode-XMR/ 2> >(tee -a debug.log >&2)
					rm /home/pinodexmr/new-ver-pi.sh 2> >(tee -a debug.log >&2)
					echo -e "\e[32mSuccess\e[0m"
					sleep 2

				##End debug log
echo "
####################
" >>debug.log
echo "End update-pinodexmr.sh script $(date)" >>debug.log
echo "
####################
" >>debug.log
					
			whiptail --title "PiNode-XMR Updater" --msgbox "\n\nYour PiNode-XMR has been updated to version ${NEW_VERSION_PI}" 12 78
					
			sleep 5
	else
		#Don't update (return to menu)
    		. /home/pinodexmr/setup.sh
	fi

#Update complete - Return to menu
./setup.sh
