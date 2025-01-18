#!/bin/bash
#Create/ammend debug file for handling update errors:
touch /home/pinodexmr/debug.log
echo "
####################
" >>/home/pinodexmr/debug.log
echo "Start update-pinodexmr.sh script $(date)" >>/home/pinodexmr/debug.log
echo "
####################
" >>/home/pinodexmr/debug.log
sleep 1

#Import Variable: Light-mode true/false
. /home/pinodexmr/variables/light-mode.sh
echo "Light-Mode value is: $LIGHTMODE" >>/home/pinodexmr/debug.log
#Import Variable: htmlPasswordRequired
. /home/pinodexmr/variables/htmlPasswordRequired.sh
echo "HMTL Password Required set to: $HTMLPASSWORDREQUIRED" >>/home/pinodexmr/debug.log

##Update and Upgrade systemhtac
echo -e "\e[32mReceiving and applying Ubuntu updates to latest versions\e[0m"
sudo apt-get update 2>&1 | tee -a /home/pinodexmr/debug.log
sudo apt-get --yes -o Dpkg::Options::="--force-confnew" upgrade 2>&1 | tee -a /home/pinodexmr/debug.log
sudo apt-get --yes -o Dpkg::Options::="--force-confnew" dist-upgrade 2>&1 | tee -a /home/pinodexmr/debug.log

##Auto remove any obsolete packages
sudo apt-get autoremove -y 2>&1 | tee -a /home/pinodexmr/debug.log
#Clear the apt package cache (Cleared 1.3GB of space for me)
sudo apt-get clean -y 2>&1 | tee -a /home/pinodexmr/debug.log

##Installing dependencies for --- Web Interface
	echo "Installing dependencies for --- Web Interface" 2>&1 | tee -a /home/pinodexmr/debug.log
echo -e "\e[32mInstalling dependencies for --- Web Interface\e[0m"
sleep 3
sudo apt-get install apache2 shellinabox php php-common avahi-daemon -y 2>&1 | tee -a /home/pinodexmr/debug.log
sleep 3

if [ "$LIGHTMODE" = FALSE ]
then
  echo "ARCH: 64-bit"
##Installing dependencies for --- Monero
	echo "Installing dependencies for --- Monero" 2>&1 | tee -a /home/pinodexmr/debug.log
echo -e "\e[32mInstalling dependencies for --- Monero\e[0m"
sleep 3
sudo apt-get update && sudo apt-get install build-essential cmake pkg-config libssl-dev libzmq3-dev libunbound-dev libsodium-dev libunwind8-dev liblzma-dev libreadline6-dev libldns-dev libexpat1-dev libpgm-dev qttools5-dev-tools libhidapi-dev libusb-1.0-0-dev libprotobuf-dev protobuf-compiler libudev-dev libboost-chrono-dev libboost-date-time-dev libboost-filesystem-dev libboost-locale-dev libboost-program-options-dev libboost-regex-dev libboost-serialization-dev libboost-system-dev libboost-thread-dev ccache doxygen graphviz -y 2>&1 | tee -a /home/pinodexmr/debug.log
sleep 2

##Installing dependencies for --- P2Pool
	echo "Installing dependencies for --- P2Pool" 2>&1 | tee -a /home/pinodexmr/debug.log
sudo apt-get install git build-essential cmake libuv1-dev libzmq3-dev libsodium-dev libpgm-dev libnorm-dev libgss-dev -y
sleep 2
fi

##Checking all dependencies are installed for --- miscellaneous (security tools-fail2ban-ufw, menu tool-dialog, screen, mariadb)
	echo "Installing dependencies for --- miscellaneous" 2>&1 | tee -a /home/pinodexmr/debug.log
echo -e "\e[32mChecking all dependencies are installed for --- Miscellaneous\e[0m"
sleep 3
sudo apt-get install git mariadb-client mariadb-server screen fail2ban ufw dialog jq libcurl4-openssl-dev libpthread-stubs0-dev -y 2>&1 | tee -a /home/pinodexmr/debug.log
sudo apt-get install exfat-fuse -y 2>&1 | tee -a /home/pinodexmr/debug.log
#libcurl4-openssl-dev & libpthread-stubs0-dev for block-explorer
sleep 3
		#Download update files

##Replace file /etc/sudoers to set global sudo permissions/rules (required to add  new permissions to www-data user for interface buttons)
echo -e "\e[32mDownload and replace /etc/sudoers file\e[0m"
sleep 3
wget https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/etc/sudoers -O /home/pinodexmr/sudoers
sudo chmod 0440 /home/pinodexmr/sudoers
sudo chown root /home/pinodexmr/sudoers
sudo mv /home/pinodexmr/sudoers /etc/sudoers

#ubuntu /dev/null odd requirment to set permissions
sudo chmod 777 /dev/null
echo -e "\e[32mGlobal permissions changed\e[0m"
sleep 3

##Clone PiNode-XMR to device from git
	echo "Clone PiNode-XMR to device from git" 2>&1 | tee -a /home/pinodexmr/debug.log
echo -e "\e[32mDownloading PiNode-XMR files\e[0m"
sleep 3
git clone --single-branch https://github.com/shermand100/PiNodeXMR.git 2>&1 | tee -a /home/pinodexmr/debug.log

				#Backup User values
						echo "Backup variables" >>/home/pinodexmr/debug.log
					echo -e "\e[32mCreating backups of any settings you have customised\e[0m"
					echo -e "\e[32m*****\e[0m"					
					echo -e "\e[32mIf a setting did not exist on your previous version you may see some errors here for missing files, these can safely be ignored\e[0m"					
					echo -e "\e[32m*****\e[0m"						
					sleep 8
					#home dir
					mv /home/pinodexmr/ban_list_InUse.txt /home/pinodexmr/ban_list_InUse_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/bootstatus.sh /home/pinodexmr/bootstatus_retain.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/current-ver.sh /home/pinodexmr/current-ver_retain.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/current-ver-exp.sh /home/pinodexmr/current-ver-exp_retain.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/current-ver-pi.sh /home/pinodexmr/current-ver-pi_retain.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/current-ver-p2pool.sh /home/pinodexmr/current-ver-p2pool_retain.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/current-ver-lws.sh /home/pinodexmr/current-ver-lws_retain.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/current-ver-atomicSwap.sh /home/pinodexmr/current-ver-atomicSwap_retain.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					#variables dir
					mv /home/pinodexmr/variables/credits.sh /home/pinodexmr/variables/credits_retain.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/difficulty.sh /home/pinodexmr/variables/difficulty_retain.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/i2p-address.sh /home/pinodexmr/variables/i2p-address_retain.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/i2p-port.sh /home/pinodexmr/variables/i2p-port_retain.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/i2p-tx-proxy-port.sh /home/pinodexmr/variables/i2p-tx-proxy-port_retain.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/in-peers.sh /home/pinodexmr/variables/in-peers_retain.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/limit-rate-down.sh /home/pinodexmr/variables/limit-rate-down_retain.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/limit-rate-up.sh /home/pinodexmr/variables/limit-rate-up_retain.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/mining-address.sh /home/pinodexmr/variables/mining-address_retain.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/mining-intensity.sh /home/pinodexmr/variables/mining-intensity_retain.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/monero-port.sh /home/pinodexmr/variables/monero-port_retain.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/monero-port-public-free.sh /home/pinodexmr/variables/monero-port-public-free_retain.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/monero-rpcpay-port.sh /home/pinodexmr/variables/monero-rpcpay-port_retain.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/monero-stats-port.sh /home/pinodexmr/variables/monero-stats-port_retain.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/out-peers.sh /home/pinodexmr/variables/out-peers_retain.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/payment-address.sh /home/pinodexmr/variables/payment-address_retain.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/pruneStatus.sh /home/pinodexmr/variables/pruneStatus_status.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/RPCp.sh /home/pinodexmr/variables/RPCp_retain.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/RPCu.sh /home/pinodexmr/variables/RPCu_retain.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/light-mode.sh /home/pinodexmr/variables/light-mode_retain.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/htmlPasswordRequired.sh /home/pinodexmr/variables/htmlPasswordRequired_retain.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					echo -e "\e[32mUser-set configuration saved\e[0m"

								
		#Install Update
			echo -e "\e[32mInstalling update\e[0m"
			sleep 2
				##Add PiNode-XMR systemd services
						echo "Update services" >>/home/pinodexmr/debug.log
					echo -e "\e[32mAdd PiNode-XMR systemd services\e[0m"
					sleep 3
					sudo mv /home/pinodexmr/PiNodeXMR/etc/systemd/system/*.service /etc/systemd/system/ 2> >(tee -a /home/pinodexmr/debug.log >&2)
					sudo chmod 644 /etc/systemd/system/*.service 2> >(tee -a /home/pinodexmr/debug.log >&2)
					sudo chown root /etc/systemd/system/*.service 2> >(tee -a /home/pinodexmr/debug.log >&2)
					sudo systemctl daemon-reload 2> >(tee -a /home/pinodexmr/debug.log >&2)
					sudo systemctl start moneroStatus.service 2> >(tee -a /home/pinodexmr/debug.log >&2)
					sudo systemctl enable moneroStatus.service 2> >(tee -a /home/pinodexmr/debug.log >&2)
					echo -e "\e[32mSuccess\e[0m"
					sleep 3

				##Updating PiNode-XMR scripts in home directory
						echo "Update PiNodeXMR scripts" >>/home/pinodexmr/debug.log
					echo -e "\e[32mUpdating PiNodeXMR scripts in home directory\e[0m"
					sleep 2
					cp -afr /home/pinodexmr/PiNodeXMR/home/pinodexmr/* /home/pinodexmr/ 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/PiNodeXMR/home/pinodexmr/.profile /home/pinodexmr/ 2> >(tee -a /home/pinodexmr/debug.log >&2)
					sudo chmod -R 777 /home/pinodexmr/* 2> >(tee -a /home/pinodexmr/debug.log >&2)
					echo -e "\e[32mSuccess\e[0m"
					sleep 2

				#Configure apache server for access to monero log file
					echo -e "\e[32mConfigure apache server for access to monero log file\e[0m"
					sudo mv /home/pinodexmr/PiNodeXMR/etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf 2> >(tee -a /home/pinodexmr/debug.log >&2)
					sudo chmod 777 /etc/apache2/sites-enabled/000-default.conf 2> >(tee -a /home/pinodexmr/debug.log >&2)
					sudo chown root /etc/apache2/sites-enabled/000-default.conf 2> >(tee -a /home/pinodexmr/debug.log >&2)					
					sudo /etc/init.d/apache2 restart 2> >(tee -a /home/pinodexmr/debug.log >&2)
					echo -e "\e[32mSuccess\e[0m"
					sleep 3
				##Setup local hostname
						echo "Update hostname (avahi)" >>/home/pinodexmr/debug.log
					echo -e "\e[32mEnable local hostname pinodexmr.local\e[0m"
					sleep 3				
					sudo mv /home/pinodexmr/PiNodeXMR/etc/avahi/avahi-daemon.conf /etc/avahi/avahi-daemon.conf 2> >(tee -a /home/pinodexmr/debug.log >&2)
					sudo /etc/init.d/avahi-daemon restart 2> >(tee -a /home/pinodexmr/debug.log >&2)
					echo -e "\e[32mSuccess\e[0m"

				##Update html template
						echo "Update html template" >>/home/pinodexmr/debug.log	
					echo -e "\e[32mConfiguring Web-UI template with PiNodeXMR pages\e[0m"
					sleep 3
					if [ "$LIGHTMODE" = TRUE ]
					then
					#First move hidden file specifically .htaccess file then entire directory
					sudo mv /home/pinodexmr/PiNodeXMR/HTML/.htaccess /var/www/html/ 2>&1 | tee -a /home/pinodexmr/debug.log					
					#Remove .php file clutter, see PiNodeXMR PR66 for context.
					rm -R /var/www/html/*.php
					#Preserve user variables (custom ports, hidden service onion address, miningrpc pay address etc). Updater script overwrites/merges all files, this renames them temporarily to avoid merge.
					mv /var/www/html/credits.txt /var/www/html/credits_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/difficulty.txt /var/www/html/difficulty_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/i2p-address.txt /var/www/html/i2p-address_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/i2p-port.txt /var/www/html/i2p-port_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/i2p-tx-proxy-port.txt /var/www/html/i2p-tx-proxy-port_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/mining_address.txt /var/www/html/mining_address_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/mining_intensity.txt /var/www/html/mining_intensity_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/monero-free-public-port.txt /var/www/html/monero-free-public-port_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/monero-port-rpc-pay.txt /var/www/html/monero-port-rpc-pay_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/monero-rpc-port.txt /var/www/html/monero-rpc-port_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/onion-address.txt /var/www/html/onion-address_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/payment-address.txt /var/www/html/payment-address_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/prune-text.txt /var/www/html/prune-text_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/user-set-custom.txt /var/www/html/user-set-custom_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					#Overwrite /var/www/html with updated contents
					sudo rsync -a /home/pinodexmr/PiNodeXMR/HTML/* /var/www/html/ 2>&1 | tee -a /home/pinodexmr/debug.log
					sudo rsync -a /home/pinodexmr/PiNodeXMR/HTML-LIGHT/*.html /var/www/html/ 2>&1 | tee -a /home/pinodexmr/debug.log
					sudo chown www-data -R /var/www/html/ 2>&1 | tee -a /home/pinodexmr/debug.log
					sudo chmod 777 -R /var/www/html/ 2>&1 | tee -a /home/pinodexmr/debug.log
					#Restore User variables
					mv /var/www/html/credits_retain.txt /var/www/html/credits.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/difficulty_retain.txt /var/www/html/difficulty.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/i2p-address_retain.txt /var/www/html/i2p-address.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/i2p-port_retain.txt /var/www/html/i2p-port.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/i2p-tx-proxy-port_retain.txt /var/www/html/i2p-tx-proxy-port.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/mining_address_retain.txt /var/www/html/mining_address.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/mining_intensity_retain.txt /var/www/html/mining_intensity.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/monero-free-public-port_retain.txt /var/www/html/monero-free-public-port.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/monero-port-rpc-pay_retain.txt /var/www/html/monero-port-rpc-pay.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/monero-rpc-port_retain.txt /var/www/html/monero-rpc-port.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/onion-address_retain.txt /var/www/html/onion-address.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/payment-address_retain.txt /var/www/html/payment-address.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/prune-text_retain.txt /var/www/html/prune-text.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/user-set-custom_retain.txt /var/www/html/user-set-custom.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					#Lightmode html update complete
					else
					#First move hidden file specifically .htaccess file then entire directory
					sudo mv /home/pinodexmr/PiNodeXMR/HTML/.htaccess /var/www/html/ 2>&1 | tee -a /home/pinodexmr/debug.log
					rm -R /var/www/html/*.php
					#Preserve user variables (custom ports, hidden service onion address, miningrpc pay address etc). Updater script overwrites/merges all files, this renames them temporarily to avoid merge.
					mv /var/www/html/credits.txt /var/www/html/credits_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/difficulty.txt /var/www/html/difficulty_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/i2p-address.txt /var/www/html/i2p-address_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/i2p-port.txt /var/www/html/i2p-port_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/i2p-tx-proxy-port.txt /var/www/html/i2p-tx-proxy-port_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/mining_address.txt /var/www/html/mining_address_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/mining_intensity.txt /var/www/html/mining_intensity_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/monero-free-public-port.txt /var/www/html/monero-free-public-port_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/monero-port-rpc-pay.txt /var/www/html/monero-port-rpc-pay_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/monero-rpc-port.txt /var/www/html/monero-rpc-port_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/onion-address.txt /var/www/html/onion-address_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/payment-address.txt /var/www/html/payment-address_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/prune-text.txt /var/www/html/prune-text_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/user-set-custom.txt /var/www/html/user-set-custom_retain.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					#Overwrite /var/www/html with updated contents										
					sudo rsync -a /home/pinodexmr/PiNodeXMR/HTML/* /var/www/html/ 2>&1 | tee -a /home/pinodexmr/debug.log
					sudo chown www-data -R /var/www/html/ 2>&1 | tee -a /home/pinodexmr/debug.log
					sudo chmod 777 -R /var/www/html/ 2>&1 | tee -a /home/pinodexmr/debug.log
					#Restore User variables
					mv /var/www/html/credits_retain.txt /var/www/html/credits.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/difficulty_retain.txt /var/www/html/difficulty.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/i2p-address_retain.txt /var/www/html/i2p-address.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/i2p-port_retain.txt /var/www/html/i2p-port.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/i2p-tx-proxy-port_retain.txt /var/www/html/i2p-tx-proxy-port.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/mining_address_retain.txt /var/www/html/mining_address.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/mining_intensity_retain.txt /var/www/html/mining_intensity.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/monero-free-public-port_retain.txt /var/www/html/monero-free-public-port.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/monero-port-rpc-pay_retain.txt /var/www/html/monero-port-rpc-pay.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/monero-rpc-port_retain.txt /var/www/html/monero-rpc-port.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/onion-address_retain.txt /var/www/html/onion-address.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/payment-address_retain.txt /var/www/html/payment-address.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/prune-text_retain.txt /var/www/html/prune-text.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /var/www/html/user-set-custom_retain.txt /var/www/html/user-set-custom.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					#Full-mode html update complete					
					fi

					#Set correct config for if HTML (Web UI) Password is required.

					if [ "$HTMLPASSWORDREQUIRED" = TRUE ]
					then
					sudo cp /home/pinodexmr/variables/000-default-passwordAuthEnabled.conf /etc/apache2/sites-enabled/000-default.conf
					sudo chown root /etc/apache2/sites-enabled/000-default.conf
					sudo chmod 777 /etc/apache2/sites-enabled/000-default.conf
					sudo systemctl restart apache2
					fi

					echo -e "\e[32mSuccess\e[0m"
										
				#Restore User Values
						echo "Restore user variables" >>/home/pinodexmr/debug.log	
					echo -e "\e[32mRestoring your personal settings\e[0m"
					sleep 2
					#home dir
					mv /home/pinodexmr/ban_list_InUse_retain.txt /home/pinodexmr/ban_list_InUse.txt 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/bootstatus_retain.sh /home/pinodexmr/bootstatus.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/current-ver_retain.sh /home/pinodexmr/current-ver.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/current-ver-exp_retain.sh /home/pinodexmr/current-ver-exp.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/current-ver-pi_retain.sh /home/pinodexmr/current-ver-pi.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/current-ver-p2pool_retain.sh /home/pinodexmr/current-ver-p2pool.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/current-ver-lws_retain.sh /home/pinodexmr/current-ver-lws.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/current-ver-atomicSwap_retain.sh /home/pinodexmr/current-ver-atomicSwap.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)

					#variables dir
					mv /home/pinodexmr/variables/difficulty_retain.sh /home/pinodexmr/variables/difficulty.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/credits_retain.sh /home/pinodexmr/variables/credits.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/i2p-address_retain.sh /home/pinodexmr/variables/i2p-address.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/i2p-port_retain.sh /home/pinodexmr/variables/i2p-port.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/i2p-tx-proxy-port_retain.sh /home/pinodexmr/variables/i2p-tx-proxy-port.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/in-peers_retain.sh /home/pinodexmr/variables/in-peers.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/limit-rate-down_retain.sh /home/pinodexmr/variables/limit-rate-down.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/limit-rate-up_retain.sh /home/pinodexmr/variables/limit-rate-up.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/mining-address_retain.sh /home/pinodexmr/variables/mining-address.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/mining-intensity_retain.sh /home/pinodexmr/variables/mining-intensity.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/monero-port_retain.sh /home/pinodexmr/variables/monero-port.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/monero-port-public-free_retain.sh /home/pinodexmr/variables/monero-port-public-free.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/out-peers_retain.sh /home/pinodexmr/variables/out-peers.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/payment-address_retain.sh /home/pinodexmr/variables/payment-address.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/pruneStatus_status.sh /home/pinodexmr/variables/pruneStatus.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/RPCp_retain.sh /home/pinodexmr/variables/RPCp.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/RPCu_retain.sh /home/pinodexmr/variables/RPCu.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/monero-rpcpay-port_retain.sh /home/pinodexmr/variables/monero-rpcpay-port.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/monero-stats-port_retain.sh /home/pinodexmr/variables/monero-stats-port.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/light-mode_retain.sh /home/pinodexmr/variables/light-mode.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					mv /home/pinodexmr/variables/htmlPasswordRequired_retain.sh /home/pinodexmr/variables/htmlPasswordRequired.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)

					echo -e "\e[32mUser configuration restored\e[0m"
				
				##Set Swappiness lower
						echo "Set swappiness" >>/home/pinodexmr/debug.log
					echo -e "\e[32mDecreasing swappiness\e[0m"
					sleep 3				
					sudo sysctl vm.swappiness=10 2> >(tee -a /home/pinodexmr/debug.log >&2)
					echo -e "\e[32mSuccess\e[0m"
					sleep 3						
				##Update crontab
						echo "Update crontabs" >>/home/pinodexmr/debug.log
					echo -e "\e[32mUpdating crontab tasks\e[0m"
					sleep 3
					crontab /home/pinodexmr/PiNodeXMR/var/spool/cron/crontabs/pinodexmr 2> >(tee -a /home/pinodexmr/debug.log >&2)
					echo -e "\e[32mSuccess\e[0m"
					sleep 3
		
				#Attempt update of tor hidden service settings
						echo "Update torrc settings - if installed" >>/home/pinodexmr/debug.log
					echo -e "\e[32mUpdate of tor hidden service settings - If you have not installed tor this process will fail - this is expected\e[0m"
					sleep 6
					sudo wget https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/etc/tor/torrc -O /etc/tor/torrc 2> >(tee -a /home/pinodexmr/debug.log >&2)
					echo -e "\e[32mApplying Settings...\e[0m"
					sleep 3
					sudo chmod 644 /etc/tor/torrc 2> >(tee -a /home/pinodexmr/debug.log >&2)
					sudo chown root /etc/tor/torrc 2> >(tee -a /home/pinodexmr/debug.log >&2)
				#Insert user specific local IP for correct hiddenservice redirect (line 73 overwrite)
					sudo sed -i "73s/.*/HiddenServicePort 18081 $(hostname -I | awk '{print $1}'):18081/" /etc/tor/torrc
					echo -e "\e[32mRestarting tor service...\e[0m"
					sudo service tor restart 2> >(tee -a /home/pinodexmr/debug.log >&2)
					sleep 3

				#Restart statusOutputs script service for changes to take effect
				sudo systemctl restart moneroStatus.service


				##Check-Install log.io (Real-time service monitoring)
				#Establish Device IP
				. ~/variables/deviceIp.sh
				echo -e "\e[32mInstalling log.io\e[0m" 2>&1 | tee -a /home/pinodexmr/debug.log
				sudo apt-get install nodejs npm -y 2>&1 | tee -a /home/pinodexmr/debug.log
				sudo npm install -g log.io 2>&1 | tee -a /home/pinodexmr/debug.log
				sudo npm install -g log.io-file-input 2>&1 | tee -a /home/pinodexmr/debug.log
				mkdir -p ~/.log.io/inputs/ 2>&1 | tee -a /home/pinodexmr/debug.log
				mv /home/pinodexmr/PiNodeXMR/.log.io/inputs/file.json ~/.log.io/inputs/file.json 2>&1 | tee -a /home/pinodexmr/debug.log
				mv /home/pinodexmr/PiNodeXMR/.log.io/server.json ~/.log.io/server.json 2>&1 | tee -a /home/pinodexmr/debug.log
				sed -i "s/127.0.0.1/$DEVICE_IP/g" ~/.log.io/server.json 2>&1 | tee -a /home/pinodexmr/debug.log
				sed -i "s/127.0.0.1/$DEVICE_IP/g" ~/.log.io/inputs/file.json 2>&1 | tee -a /home/pinodexmr/debug.log
				sudo systemctl start log-io-server.service 2>&1 | tee -a /home/pinodexmr/debug.log
				sudo systemctl start log-io-file.service 2>&1 | tee -a /home/pinodexmr/debug.log
				sudo systemctl enable log-io-server.service 2>&1 | tee -a /home/pinodexmr/debug.log
				sudo systemctl enable log-io-file.service 2>&1 | tee -a /home/pinodexmr/debug.log

				#Update system version number to new one installed
				echo "Update PiNodeXMR version number" >>/home/pinodexmr/debug.log
					wget https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/new-ver-pi.sh -O /home/pinodexmr/new-ver-pi.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					chmod 755 /home/pinodexmr/new-ver-pi.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					. /home/pinodexmr/new-ver-pi.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					echo -e "\e[32mUpdate system version number\e[0m"
					echo "#!/bin/bash
CURRENT_VERSION_PI=$NEW_VERSION_PI" > /home/pinodexmr/current-ver-pi.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					echo -e "\e[32mSuccess\e[0m"
					sleep 2
				#ubuntu /dev/null odd requiremnt to set permissions
				sudo chmod 777 /dev/null

				#Clean up files
				echo "Cleanup leftover files" >>/home/pinodexmr/debug.log
					echo -e "\e[32mCleanup leftover directories\e[0m"
					sleep 2

					sudo rm -r /home/pinodexmr/PiNodeXMR/ 2> >(tee -a /home/pinodexmr/debug.log >&2)
					rm /home/pinodexmr/new-ver-pi.sh 2> >(tee -a /home/pinodexmr/debug.log >&2)
					echo -e "\e[32mSuccess\e[0m"
					sleep 2

				##End debug log
echo "
####################
" >>/home/pinodexmr/debug.log
echo "End update-pinodexmr.sh script $(date)" >>/home/pinodexmr/debug.log
echo "
####################
" >>/home/pinodexmr/debug.log
					
			whiptail --title "PiNode-XMR Updater" --msgbox "\n\nYour PiNode-XMR has been updated to version ${NEW_VERSION_PI}" 12 78
					
			sleep 2

#Update complete - Return to menu
./setup.sh
