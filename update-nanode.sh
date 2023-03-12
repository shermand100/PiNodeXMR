#!/bin/bash
#Create/ammend debug file for handling update errors:
touch /home/nanode/debug.log
echo "
####################
" >>/home/nanode/debug.log
echo "Start update-nanode.sh script $(date)" >>/home/nanode/debug.log
echo "
####################
" >>/home/nanode/debug.log
sleep 1

#Import Variable: Light-mode true/false
. /home/nanode/variables/light-mode.sh
echo "Light-Mode value is: $LIGHTMODE" >>/home/nanode/debug.log
#Import Variable: htmlPasswordRequired
. /home/nanode/variables/htmlPasswordRequired.sh
echo "HMTL Password Required set to: $HTMLPASSWORDREQUIRED" >>/home/nanode/debug.log

##Update and Upgrade systemhtac
echo -e "\e[32mReceiving and applying Ubuntu updates to latest versions\e[0m"
sudo apt-get update 2>&1 | tee -a /home/nanode/debug.log
sudo apt-get --yes -o Dpkg::Options::="--force-confnew" upgrade 2>&1 | tee -a /home/nanode/debug.log
sudo apt-get --yes -o Dpkg::Options::="--force-confnew" dist-upgrade 2>&1 | tee -a /home/nanode/debug.log

##Auto remove any obsolete packages
sudo apt-get autoremove -y 2>&1 | tee -a /home/nanode/debug.log

##Installing dependencies for --- Web Interface
	echo "Installing dependencies for --- Web Interface" 2>&1 | tee -a /home/nanode/debug.log
echo -e "\e[32mInstalling dependencies for --- Web Interface\e[0m"
sleep 3
sudo apt-get install apache2 shellinabox php php-common avahi-daemon -y 2>&1 | tee -a /home/nanode/debug.log
sleep 3

if [ "$LIGHTMODE" = FALSE ]
then
  echo "ARCH: 64-bit"
##Installing dependencies for --- Monero
	echo "Installing dependencies for --- Monero" 2>&1 | tee -a /home/nanode/debug.log
echo -e "\e[32mInstalling dependencies for --- Monero\e[0m"
sleep 3
sudo apt-get update && sudo apt-get install build-essential cmake pkg-config libssl-dev libzmq3-dev libunbound-dev libsodium-dev libunwind8-dev liblzma-dev libreadline6-dev libldns-dev libexpat1-dev libpgm-dev qttools5-dev-tools libhidapi-dev libusb-1.0-0-dev libprotobuf-dev protobuf-compiler libudev-dev libboost-chrono-dev libboost-date-time-dev libboost-filesystem-dev libboost-locale-dev libboost-program-options-dev libboost-regex-dev libboost-serialization-dev libboost-system-dev libboost-thread-dev ccache doxygen graphviz -y 2>&1 | tee -a /home/nanode/debug.log
sleep 2

##Installing dependencies for --- P2Pool
	echo "Installing dependencies for --- P2Pool" 2>&1 | tee -a /home/nanode/debug.log
sudo apt-get install git build-essential cmake libuv1-dev libzmq3-dev libsodium-dev libpgm-dev libnorm-dev libgss-dev -y
sleep 2
fi

##Checking all dependencies are installed for --- miscellaneous (security tools-fail2ban-ufw, menu tool-dialog, screen, mariadb)
	echo "Installing dependencies for --- miscellaneous" 2>&1 | tee -a /home/nanode/debug.log
echo -e "\e[32mChecking all dependencies are installed for --- Miscellaneous\e[0m"
sleep 3
sudo apt-get install git mariadb-client mariadb-server screen fail2ban ufw dialog jq libcurl4-openssl-dev libpthread-stubs0-dev -y 2>&1 | tee -a /home/nanode/debug.log
sudo apt-get install exfat-fuse -y 2>&1 | tee -a /home/nanode/debug.log
#libcurl4-openssl-dev & libpthread-stubs0-dev for block-explorer
sleep 3
		#Download update files

##Replace file /etc/sudoers to set global sudo permissions/rules (required to add  new permissions to www-data user for interface buttons)
echo -e "\e[32mDownload and replace /etc/sudoers file\e[0m"
sleep 3
wget https://raw.githubusercontent.com/monero-ecosystem/Nanode/ubuntuServer-20.04/etc/sudoers -O /home/nanode/sudoers
sudo chmod 0440 /home/nanode/sudoers
sudo chown root /home/nanode/sudoers
sudo mv /home/nanode/sudoers /etc/sudoers

#ubuntu /dev/null odd requirment to set permissions
sudo chmod 777 /dev/null
echo -e "\e[32mGlobal permissions changed\e[0m"
sleep 3

##Clone Nanode to device from git
	echo "Clone Nanode to device from git" 2>&1 | tee -a /home/nanode/debug.log
echo -e "\e[32mDownloading Nanode files\e[0m"
sleep 3
git clone -b ubuntuServer-20.04 --single-branch https://github.com/monero-ecosystem/Nanode.git 2>&1 | tee -a /home/nanode/debug.log

				#Backup User values
						echo "Backup variables" >>/home/nanode/debug.log
					echo -e "\e[32mCreating backups of any settings you have customised\e[0m"
					echo -e "\e[32m*****\e[0m"
					echo -e "\e[32mIf a setting did not exist on your previous version you may see some errors here for missing files, these can safely be ignored\e[0m"
					echo -e "\e[32m*****\e[0m"
					sleep 8
					#home dir
					mv /home/nanode/bootstatus.sh /home/nanode/bootstatus_retain.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/current-ver.sh /home/nanode/current-ver_retain.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/current-ver-exp.sh /home/nanode/current-ver-exp_retain.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/current-ver-pi.sh /home/nanode/current-ver-pi_retain.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/current-ver-p2pool.sh /home/nanode/current-ver-p2pool_retain.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/current-ver-lws.sh /home/nanode/current-ver-lws_retain.sh 2> >(tee -a /home/nanode/debug.log >&2)
					#variables dir
					mv /home/nanode/variables/credits.sh /home/nanode/variables/credits_retain.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/difficulty.sh /home/nanode/variables/difficulty_retain.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/i2p-address.sh /home/nanode/variables/i2p-address_retain.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/i2p-port.sh /home/nanode/variables/i2p-port_retain.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/i2p-tx-proxy-port.sh /home/nanode/variables/i2p-tx-proxy-port_retain.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/in-peers.sh /home/nanode/variables/in-peers_retain.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/limit-rate-down.sh /home/nanode/variables/limit-rate-down_retain.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/limit-rate-up.sh /home/nanode/variables/limit-rate-up_retain.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/mining-address.sh /home/nanode/variables/mining-address_retain.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/mining-intensity.sh /home/nanode/variables/mining-intensity_retain.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/monero-port.sh /home/nanode/variables/monero-port_retain.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/monero-port-public-free.sh /home/nanode/variables/monero-port-public-free_retain.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/monero-rpcpay-port.sh /home/nanode/variables/monero-rpcpay-port_retain.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/monero-stats-port.sh /home/nanode/variables/monero-stats-port_retain.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/out-peers.sh /home/nanode/variables/out-peers_retain.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/payment-address.sh /home/nanode/variables/payment-address_retain.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/pruneStatus.sh /home/nanode/variables/pruneStatus_status.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/RPCp.sh /home/nanode/variables/RPCp_retain.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/RPCu.sh /home/nanode/variables/RPCu_retain.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/light-mode.sh /home/nanode/variables/light-mode_retain.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/htmlPasswordRequired.sh /home/nanode/variables/htmlPasswordRequired_retain.sh 2> >(tee -a /home/nanode/debug.log >&2)
					echo -e "\e[32mUser-set configuration saved\e[0m"


		#Install Update
			echo -e "\e[32mInstalling update\e[0m"
			sleep 2
				##Add Nanode systemd services
						echo "Update services" >>/home/nanode/debug.log
					echo -e "\e[32mAdd Nanode systemd services\e[0m"
					sleep 3
					sudo mv /home/nanode/Nanode/etc/systemd/system/*.service /etc/systemd/system/ 2> >(tee -a /home/nanode/debug.log >&2)
					sudo chmod 644 /etc/systemd/system/*.service 2> >(tee -a /home/nanode/debug.log >&2)
					sudo chown root /etc/systemd/system/*.service 2> >(tee -a /home/nanode/debug.log >&2)
					sudo systemctl daemon-reload 2> >(tee -a /home/nanode/debug.log >&2)
					sudo systemctl start moneroStatus.service 2> >(tee -a /home/nanode/debug.log >&2)
					sudo systemctl enable moneroStatus.service 2> >(tee -a /home/nanode/debug.log >&2)
					echo -e "\e[32mSuccess\e[0m"
					sleep 3

				##Updating Nanode scripts in home directory
						echo "Update Nanode scripts" >>/home/nanode/debug.log
					echo -e "\e[32mUpdating Nanode scripts in home directory\e[0m"
					sleep 2
					cp -afr /home/nanode/Nanode/home/nanode/* /home/nanode/ 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/Nanode/home/nanode/.profile /home/nanode/ 2> >(tee -a /home/nanode/debug.log >&2)
					sudo chmod -R 777 /home/nanode/* 2> >(tee -a /home/nanode/debug.log >&2)
					echo -e "\e[32mSuccess\e[0m"
					sleep 2

				#Configure apache server for access to monero log file
					echo -e "\e[32mConfigure apache server for access to monero log file\e[0m"
					sudo mv /home/nanode/Nanode/etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf 2> >(tee -a /home/nanode/debug.log >&2)
					sudo chmod 777 /etc/apache2/sites-enabled/000-default.conf 2> >(tee -a /home/nanode/debug.log >&2)
					sudo chown root /etc/apache2/sites-enabled/000-default.conf 2> >(tee -a /home/nanode/debug.log >&2)
					sudo /etc/init.d/apache2 restart 2> >(tee -a /home/nanode/debug.log >&2)
					echo -e "\e[32mSuccess\e[0m"
					sleep 3
				##Setup local hostname
						echo "Update hostname (avahi)" >>/home/nanode/debug.log
					echo -e "\e[32mEnable local hostname nanode.local\e[0m"
					sleep 3
					sudo mv /home/nanode/Nanode/etc/avahi/avahi-daemon.conf /etc/avahi/avahi-daemon.conf 2> >(tee -a /home/nanode/debug.log >&2)
					sudo /etc/init.d/avahi-daemon restart 2> >(tee -a /home/nanode/debug.log >&2)
					echo -e "\e[32mSuccess\e[0m"

				##Update html template
						echo "Update html template" >>/home/nanode/debug.log
					echo -e "\e[32mConfiguring Web-UI template with Nanode pages\e[0m"
					sleep 3
					if [ "$LIGHTMODE" = TRUE ]
					then
					#First move hidden file specifically .htaccess file then entire directory
					sudo mv /home/nanode/Nanode/HTML/.htaccess /var/www/html/ 2>&1 | tee -a /home/nanode/debug.log
					#Remove .php file clutter, see Nanode PR66 for context.
					rm -R /var/www/html/*.php
					#Preserve user variables (custom ports, hidden service onion address, miningrpc pay address etc). Updater script overwrites/merges all files, this renames them temporarily to avoid merge.
					mv /var/www/html/credits.txt /var/www/html/credits_retain.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/difficulty.txt /var/www/html/difficulty_retain.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/i2p-address.txt /var/www/html/i2p-address_retain.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/i2p-port.txt /var/www/html/i2p-port_retain.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/i2p-tx-proxy-port.txt /var/www/html/i2p-tx-proxy-port_retain.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/mining_address.txt /var/www/html/mining_address_retain.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/mining_intensity.txt /var/www/html/mining_intensity_retain.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/monero-free-public-port.txt /var/www/html/monero-free-public-port_retain.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/monero-port-rpc-pay.txt /var/www/html/monero-port-rpc-pay_retain.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/monero-rpc-port.txt /var/www/html/monero-rpc-port_retain.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/onion-address.txt /var/www/html/onion-address_retain.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/payment-address.txt /var/www/html/payment-address_retain.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/prune-text.txt /var/www/html/prune-text_retain.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/user-set-custom.txt /var/www/html/user-set-custom_retain.txt 2> >(tee -a /home/nanode/debug.log >&2)
					#Overwrite /var/www/html with updated contents
					sudo rsync -a /home/nanode/Nanode/HTML/* /var/www/html/ 2>&1 | tee -a /home/nanode/debug.log
					sudo rsync -a /home/nanode/Nanode/HTML-LIGHT/*.html /var/www/html/ 2>&1 | tee -a /home/nanode/debug.log
					sudo chown www-data -R /var/www/html/ 2>&1 | tee -a /home/nanode/debug.log
					sudo chmod 777 -R /var/www/html/ 2>&1 | tee -a /home/nanode/debug.log
					#Restore User variables
					mv /var/www/html/credits_retain.txt /var/www/html/credits.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/difficulty_retain.txt /var/www/html/difficulty.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/i2p-address_retain.txt /var/www/html/i2p-address.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/i2p-port_retain.txt /var/www/html/i2p-port.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/i2p-tx-proxy-port_retain.txt /var/www/html/i2p-tx-proxy-port.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/mining_address_retain.txt /var/www/html/mining_address.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/mining_intensity_retain.txt /var/www/html/mining_intensity.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/monero-free-public-port_retain.txt /var/www/html/monero-free-public-port.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/monero-port-rpc-pay_retain.txt /var/www/html/monero-port-rpc-pay.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/monero-rpc-port_retain.txt /var/www/html/monero-rpc-port.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/onion-address_retain.txt /var/www/html/onion-address.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/payment-address_retain.txt /var/www/html/payment-address.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/prune-text_retain.txt /var/www/html/prune-text.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/user-set-custom_retain.txt /var/www/html/user-set-custom.txt 2> >(tee -a /home/nanode/debug.log >&2)
					#Lightmode html update complete
					else
					#First move hidden file specifically .htaccess file then entire directory
					sudo mv /home/nanode/Nanode/HTML/.htaccess /var/www/html/ 2>&1 | tee -a /home/nanode/debug.log
					rm -R /var/www/html/*.php
					#Preserve user variables (custom ports, hidden service onion address, miningrpc pay address etc). Updater script overwrites/merges all files, this renames them temporarily to avoid merge.
					mv /var/www/html/credits.txt /var/www/html/credits_retain.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/difficulty.txt /var/www/html/difficulty_retain.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/i2p-address.txt /var/www/html/i2p-address_retain.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/i2p-port.txt /var/www/html/i2p-port_retain.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/i2p-tx-proxy-port.txt /var/www/html/i2p-tx-proxy-port_retain.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/mining_address.txt /var/www/html/mining_address_retain.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/mining_intensity.txt /var/www/html/mining_intensity_retain.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/monero-free-public-port.txt /var/www/html/monero-free-public-port_retain.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/monero-port-rpc-pay.txt /var/www/html/monero-port-rpc-pay_retain.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/monero-rpc-port.txt /var/www/html/monero-rpc-port_retain.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/onion-address.txt /var/www/html/onion-address_retain.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/payment-address.txt /var/www/html/payment-address_retain.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/prune-text.txt /var/www/html/prune-text_retain.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/user-set-custom.txt /var/www/html/user-set-custom_retain.txt 2> >(tee -a /home/nanode/debug.log >&2)
					#Overwrite /var/www/html with updated contents
					sudo rsync -a /home/nanode/Nanode/HTML/* /var/www/html/ 2>&1 | tee -a /home/nanode/debug.log
					sudo chown www-data -R /var/www/html/ 2>&1 | tee -a /home/nanode/debug.log
					sudo chmod 777 -R /var/www/html/ 2>&1 | tee -a /home/nanode/debug.log
					#Restore User variables
					mv /var/www/html/credits_retain.txt /var/www/html/credits.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/difficulty_retain.txt /var/www/html/difficulty.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/i2p-address_retain.txt /var/www/html/i2p-address.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/i2p-port_retain.txt /var/www/html/i2p-port.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/i2p-tx-proxy-port_retain.txt /var/www/html/i2p-tx-proxy-port.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/mining_address_retain.txt /var/www/html/mining_address.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/mining_intensity_retain.txt /var/www/html/mining_intensity.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/monero-free-public-port_retain.txt /var/www/html/monero-free-public-port.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/monero-port-rpc-pay_retain.txt /var/www/html/monero-port-rpc-pay.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/monero-rpc-port_retain.txt /var/www/html/monero-rpc-port.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/onion-address_retain.txt /var/www/html/onion-address.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/payment-address_retain.txt /var/www/html/payment-address.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/prune-text_retain.txt /var/www/html/prune-text.txt 2> >(tee -a /home/nanode/debug.log >&2)
					mv /var/www/html/user-set-custom_retain.txt /var/www/html/user-set-custom.txt 2> >(tee -a /home/nanode/debug.log >&2)
					#Full-mode html update complete
					fi

					#Set correct config for if HTML (Web UI) Password is required.

					if [ "$HTMLPASSWORDREQUIRED" = TRUE ]
					then
					sudo cp /home/nanode/variables/000-default-passwordAuthEnabled.conf /etc/apache2/sites-enabled/000-default.conf
					sudo chown root /etc/apache2/sites-enabled/000-default.conf
					sudo chmod 777 /etc/apache2/sites-enabled/000-default.conf
					sudo systemctl restart apache2
					fi

					echo -e "\e[32mSuccess\e[0m"

				#Restore User Values
						echo "Restore user variables" >>/home/nanode/debug.log
					echo -e "\e[32mRestoring your personal settings\e[0m"
					sleep 2
					#home dir
					mv /home/nanode/bootstatus_retain.sh /home/nanode/bootstatus.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/current-ver_retain.sh /home/nanode/current-ver.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/current-ver-exp_retain.sh /home/nanode/current-ver-exp.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/current-ver-pi_retain.sh /home/nanode/current-ver-pi.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/current-ver-p2pool_retain.sh /home/nanode/current-ver-p2pool.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/current-ver-lws_retain.sh /home/nanode/current-ver-lws.sh 2> >(tee -a /home/nanode/debug.log >&2)

					#variables dir
					mv /home/nanode/variables/difficulty_retain.sh /home/nanode/variables/difficulty.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/credits_retain.sh /home/nanode/variables/credits.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/i2p-address_retain.sh /home/nanode/variables/i2p-address.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/i2p-port_retain.sh /home/nanode/variables/i2p-port.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/i2p-tx-proxy-port_retain.sh /home/nanode/variables/i2p-tx-proxy-port.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/in-peers_retain.sh /home/nanode/variables/in-peers.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/limit-rate-down_retain.sh /home/nanode/variables/limit-rate-down.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/limit-rate-up_retain.sh /home/nanode/variables/limit-rate-up.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/mining-address_retain.sh /home/nanode/variables/mining-address.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/mining-intensity_retain.sh /home/nanode/variables/mining-intensity.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/monero-port_retain.sh /home/nanode/variables/monero-port.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/monero-port-public-free_retain.sh /home/nanode/variables/monero-port-public-free.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/out-peers_retain.sh /home/nanode/variables/out-peers.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/payment-address_retain.sh /home/nanode/variables/payment-address.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/pruneStatus_status.sh /home/nanode/variables/pruneStatus.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/RPCp_retain.sh /home/nanode/variables/RPCp.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/RPCu_retain.sh /home/nanode/variables/RPCu.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/monero-rpcpay-port_retain.sh /home/nanode/variables/monero-rpcpay-port.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/monero-stats-port_retain.sh /home/nanode/variables/monero-stats-port.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/light-mode_retain.sh /home/nanode/variables/light-mode.sh 2> >(tee -a /home/nanode/debug.log >&2)
					mv /home/nanode/variables/htmlPasswordRequired_retain.sh /home/nanode/variables/htmlPasswordRequired.sh 2> >(tee -a /home/nanode/debug.log >&2)

					echo -e "\e[32mUser configuration restored\e[0m"

				##Set Swappiness lower
						echo "Set swappiness" >>/home/nanode/debug.log
					echo -e "\e[32mDecreasing swappiness\e[0m"
					sleep 3
					sudo sysctl vm.swappiness=10 2> >(tee -a /home/nanode/debug.log >&2)
					echo -e "\e[32mSuccess\e[0m"
					sleep 3
				##Update crontab
						echo "Update crontabs" >>/home/nanode/debug.log
					echo -e "\e[32mUpdating crontab tasks\e[0m"
					sleep 3
					crontab /home/nanode/Nanode/var/spool/cron/crontabs/nanode 2> >(tee -a /home/nanode/debug.log >&2)
					echo -e "\e[32mSuccess\e[0m"
					sleep 3

				#Attempt update of tor hidden service settings
						echo "Update torrc settings - if installed" >>/home/nanode/debug.log
					echo -e "\e[32mUpdate of tor hidden service settings - If you have not installed tor this process will fail - this is expected\e[0m"
					sleep 6
					sudo wget https://raw.githubusercontent.com/monero-ecosystem/Nanode/ubuntuServer-20.04/etc/tor/torrc -O /etc/tor/torrc 2> >(tee -a /home/nanode/debug.log >&2)
					echo -e "\e[32mApplying Settings...\e[0m"
					sleep 3
					sudo chmod 644 /etc/tor/torrc 2> >(tee -a /home/nanode/debug.log >&2)
					sudo chown root /etc/tor/torrc 2> >(tee -a /home/nanode/debug.log >&2)
				#Insert user specific local IP for correct hiddenservice redirect (line 73 overwrite)
					sudo sed -i "73s/.*/HiddenServicePort 18081 $(hostname -I | awk '{print $1}'):18081/" /etc/tor/torrc
					echo -e "\e[32mRestarting tor service...\e[0m"
					sudo service tor restart 2> >(tee -a /home/nanode/debug.log >&2)
					sleep 3

				#Restart statusOutputs script service for changes to take effect
				sudo systemctl restart moneroStatus.service


				##Check-Install log.io (Real-time service monitoring)
				#Establish Device IP
				. ~/variables/deviceIp.sh
				echo -e "\e[32mInstalling log.io\e[0m" 2>&1 | tee -a /home/nanode/debug.log
				sudo apt-get install nodejs npm -y 2>&1 | tee -a /home/nanode/debug.log
				sudo npm install -g log.io 2>&1 | tee -a /home/nanode/debug.log
				sudo npm install -g log.io-file-input 2>&1 | tee -a /home/nanode/debug.log
				mkdir -p ~/.log.io/inputs/ 2>&1 | tee -a /home/nanode/debug.log
				mv /home/nanode/Nanode/.log.io/inputs/file.json ~/.log.io/inputs/file.json 2>&1 | tee -a /home/nanode/debug.log
				mv /home/nanode/Nanode/.log.io/server.json ~/.log.io/server.json 2>&1 | tee -a /home/nanode/debug.log
				sed -i "s/127.0.0.1/$DEVICE_IP/g" ~/.log.io/server.json 2>&1 | tee -a /home/nanode/debug.log
				sed -i "s/127.0.0.1/$DEVICE_IP/g" ~/.log.io/inputs/file.json 2>&1 | tee -a /home/nanode/debug.log
				sudo systemctl start log-io-server.service 2>&1 | tee -a /home/nanode/debug.log
				sudo systemctl start log-io-file.service 2>&1 | tee -a /home/nanode/debug.log
				sudo systemctl enable log-io-server.service 2>&1 | tee -a /home/nanode/debug.log
				sudo systemctl enable log-io-file.service 2>&1 | tee -a /home/nanode/debug.log

				#Update system version number to new one installed
				echo "Update Nanode version number" >>/home/nanode/debug.log
					wget https://raw.githubusercontent.com/monero-ecosystem/Nanode/ubuntuServer-20.04/new-ver-pi.sh -O /home/nanode/new-ver-pi.sh 2> >(tee -a /home/nanode/debug.log >&2)
					chmod 755 /home/nanode/new-ver-pi.sh 2> >(tee -a /home/nanode/debug.log >&2)
					. /home/nanode/new-ver-pi.sh 2> >(tee -a /home/nanode/debug.log >&2)
					echo -e "\e[32mUpdate system version number\e[0m"
					echo "#!/bin/bash
CURRENT_VERSION_PI=$NEW_VERSION_PI" > /home/nanode/current-ver-pi.sh 2> >(tee -a /home/nanode/debug.log >&2)
					echo -e "\e[32mSuccess\e[0m"
					sleep 2
				#ubuntu /dev/null odd requiremnt to set permissions
				sudo chmod 777 /dev/null

				#Clean up files
				echo "Cleanup leftover files" >>/home/nanode/debug.log
					echo -e "\e[32mCleanup leftover directories\e[0m"
					sleep 2

					sudo rm -r /home/nanode/Nanode/ 2> >(tee -a /home/nanode/debug.log >&2)
					rm /home/nanode/new-ver-pi.sh 2> >(tee -a /home/nanode/debug.log >&2)
					echo -e "\e[32mSuccess\e[0m"
					sleep 2

				##End debug log
echo "
####################
" >>/home/nanode/debug.log
echo "End update-nanode.sh script $(date)" >>/home/nanode/debug.log
echo "
####################
" >>/home/nanode/debug.log

			whiptail --title "Nanode Updater" --msgbox "\n\nYour Nanode has been updated to version ${NEW_VERSION_PI}" 12 78

			sleep 2

#Update complete - Return to menu
./setup.sh
