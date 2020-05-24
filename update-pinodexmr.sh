#!/bin/bash

if (whiptail --title "PiNode-XMR Updater" --yesno "This will force update PiNode-XMR to the newest version\n\nContinue?" 12 78); then
		
		#Download update files

					https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/Raspbian-install/new-ver-pi.sh -O /home/pinodexmr/new-ver-pi.sh
					chmod 755 /home/pinodexmr/new-ver-pi.sh
					. /home/pinodexmr/new-ver-pi.sh
					echo "Latest Version: $NEW_VERSION_PI "
					echo -e "\e[32mDownloading PiNode-XMR files\e[0m"
					sleep 2
					
					git clone -b Raspbian-install --single-branch https://github.com/monero-ecosystem/PiNode-XMR.git

					#Backup User values
					echo -e "\e[32mCreating backups of your configuration\e[0m"
					sleep 2
					mv /home/pinodexmr/bootstatus.sh /home/pinodexmr/bootstatus_retain.sh
					mv /home/pinodexmr/credits.sh /home/pinodexmr/credits_retain.sh
					mv /home/pinodexmr/current-ver.sh /home/pinodexmr/current-ver_retain.sh
					mv /home/pinodexmr/current-ver-exp.sh /home/pinodexmr/current-ver-exp_retain.sh
					mv /home/pinodexmr/current-ver-pi.sh /home/pinodexmr/current-ver-pi_retain.sh
					mv /home/pinodexmr/difficulty.sh /home/pinodexmr/difficulty_retain.sh
					mv /home/pinodexmr/error.log /home/pinodexmr/error_retain.log
					mv /home/pinodexmr/explorer-flag.sh /home/pinodexmr/explorer-flag_retain.sh
					mv /home/pinodexmr/in-peers.sh /home/pinodexmr/in-peers_retain.sh
					mv /home/pinodexmr/limit-rate-down.sh /home/pinodexmr/limit-rate-down_retain.sh
					mv /home/pinodexmr/limit-rate-up.sh /home/pinodexmr/limit-rate-up_retain.sh
					mv /home/pinodexmr/mining-address.sh /home/pinodexmr/mining-address_retain.sh
					mv /home/pinodexmr/mining-intensity.sh /home/pinodexmr/mining-intensity_retain.sh
					mv /home/pinodexmr/monero-port.sh /home/pinodexmr/monero-port_retain.sh
					mv /home/pinodexmr/monero-stats-port.sh /home/pinodexmr/monero-stats-port_retain.sh
					mv /home/pinodexmr/out-peers.sh /home/pinodexmr/out-peers_retain.sh
					mv /home/pinodexmr/payment-address.sh /home/pinodexmr/payment-address_retain.sh
					mv /home/pinodexmr/prunestatus.sh /home/pinodexmr/prunestatus_status.sh
					mv /home/pinodexmr/RPCp.sh /home/pinodexmr/RPCp_retain.sh
					mv /home/pinodexmr/RPCu.sh /home/pinodexmr/RPCu_retain.sh
					
						#Install Update
					echo -e "\e[32mInstalling update\e[0m"
					sleep 2
						##Update PiNode-XMR systemd services
					echo -e "\e[32mUpdating PiNode-XMR systemd services\e[0m"
					sleep 2
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
						##Update web interface
					echo -e "\e[32mUpdating your Web Interface\e[0m"
					sleep 2
					sudo mv /home/pinodexmr/PiNode-XMR/HTML/*.* /var/www/html/
					sudo cp -R /home/pinodexmr/PiNode-XMR/HTML/docs/ /var/www/html/
					sudo chown www-data -R /var/www/html/
					sudo chmod 777 -R /var/www/html/
					echo -e "\e[32mSuccess\e[0m"
										
					#Restore User Values
					echo -e "\e[32mRestoring your configuration\e[0m"
					sleep 2
					mv /home/pinodexmr/bootstatus_retain.sh /home/pinodexmr/bootstatus.sh
					mv /home/pinodexmr/credits_retain.sh /home/pinodexmr/credits.sh
					mv /home/pinodexmr/current-ver_retain.sh /home/pinodexmr/current-ver.sh
					mv /home/pinodexmr/current-ver-exp_retain.sh /home/pinodexmr/current-ver-exp.sh
					mv /home/pinodexmr/current-ver-pi_retain.sh /home/pinodexmr/current-ver-pi.sh
					mv /home/pinodexmr/difficulty_retain.sh /home/pinodexmr/difficulty.sh
					mv /home/pinodexmr/error_retain.log /home/pinodexmr/error.log
					mv /home/pinodexmr/explorer-flag_retain.sh /home/pinodexmr/explorer-flag.sh
					mv /home/pinodexmr/in-peers_retain.sh /home/pinodexmr/in-peers.sh
					mv /home/pinodexmr/limit-rate-down_retain.sh /home/pinodexmr/limit-rate-down.sh
					mv /home/pinodexmr/limit-rate-up_retain.sh /home/pinodexmr/limit-rate-up.sh
					mv /home/pinodexmr/mining-address_retain.sh /home/pinodexmr/mining-address.sh
					mv /home/pinodexmr/mining-intensity_retain.sh /home/pinodexmr/mining-intensity.sh
					mv /home/pinodexmr/monero-port_retain.sh /home/pinodexmr/monero-port.sh
					mv /home/pinodexmr/monero-stats-port_retain.sh /home/pinodexmr/monero-stats-port.sh
					mv /home/pinodexmr/out-peers_retain.sh /home/pinodexmr/out-peers.sh
					mv /home/pinodexmr/payment-address_retain.sh /home/pinodexmr/payment-address.sh
					mv /home/pinodexmr/prunestatus_status.sh /home/pinodexmr/prunestatus.sh
					mv /home/pinodexmr/RPCp_retain.sh /home/pinodexmr/RPCp.sh
					mv /home/pinodexmr/RPCu_retain.sh /home/pinodexmr/RPCu.sh
					echo -e "\e[32mSuccess\e[0m"
					
					
					##Update crontab
					echo -e "\e[32mSetup crontab\e[0m"
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
					
					whiptail --title "PiNode-XMR Updater" --msgbox "\n\nYour PiNode-XMR has been updated to version ${NEW_VERSION_PI}" 12 78
					
else
    . /home/pinodexmr/setup.sh
fi

#Return to menu
./setup.sh
