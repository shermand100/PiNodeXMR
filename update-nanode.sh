#!/bin/bash
#Create/ammend debug file for handling update errors:
. ./common.sh
touch "$DEBUG_LOG"
echo "
####################
Start update-nanode.sh script $(date)
####################
" | tee -a "$DEBUG_LOG"

#Import Variable: htmlPasswordRequired
#shellcheck source=home/nanode/variables/htmlPasswordRequired.sh
. /home/nanode/variables/htmlPasswordRequired.sh
log "HTML Password Required set to: $HTMLPASSWORDREQUIRED"

##Update and Upgrade systemhtac
showtext "Receiving and applying Ubuntu updates to the latest version..."
{
sudo apt-get update
sudo apt-get --yes -o Dpkg::Options::="--force-confnew" upgrade
sudo apt-get --yes -o Dpkg::Options::="--force-confnew" dist-upgrade
sudo apt-get autoremove -y
} 2>&1 | tee -a "$DEBUG_LOG"

##Auto remove any obsolete packages

##Installing dependencies for Web Interface
showtext "Installing dependencies for Web Interface..."
sudo apt-get install apache2 shellinabox php php-common avahi-daemon -y 2>&1 | tee -a "$DEBUG_LOG"

##Installing dependencies for Monero
showtext "Installing dependencies for Monero..."
sudo apt-get update && sudo apt-get install build-essential cmake pkg-config libssl-dev libzmq3-dev libunbound-dev libsodium-dev libunwind8-dev liblzma-dev libreadline6-dev libldns-dev libexpat1-dev libpgm-dev qttools5-dev-tools libhidapi-dev libusb-1.0-0-dev libprotobuf-dev protobuf-compiler libudev-dev libboost-chrono-dev libboost-date-time-dev libboost-filesystem-dev libboost-locale-dev libboost-program-options-dev libboost-regex-dev libboost-serialization-dev libboost-system-dev libboost-thread-dev ccache doxygen graphviz -y 2>&1 | tee -a "$DEBUG_LOG"

##Installing dependencies for P2Pool
showtext "Installing dependencies for P2Pool..."
sudo apt-get install git build-essential cmake libuv1-dev libzmq3-dev libsodium-dev libpgm-dev libnorm-dev libgss-dev -y

##Checking all dependencies are installed for miscellaneous (security tools-fail2ban-ufw, menu tool-dialog, screen, mariadb)
showtext "Checking all other dependencies are installed..."
sudo apt-get install git mariadb-client mariadb-server screen fail2ban ufw dialog jq libcurl4-openssl-dev libpthread-stubs0-dev exfat-fuse -y 2>&1 | tee -a "$DEBUG_LOG"
#libcurl4-openssl-dev & libpthread-stubs0-dev for block-explorer
#Download update files

##Replace file /etc/sudoers to set global sudo permissions/rules (required to add  new permissions to www-data user for interface buttons)
showtext "Download and replace /etc/sudoers file"
wget https://raw.githubusercontent.com/monero-ecosystem/Nanode/ubuntuServer-20.04/etc/sudoers -O /home/nanode/sudoers
sudo chmod 0440 /home/nanode/sudoers
sudo chown root /home/nanode/sudoers
sudo mv /home/nanode/sudoers /etc/sudoers

#ubuntu /dev/null odd requirment to set permissions
sudo chmod 777 /dev/null
showtext "Global permissions changed"

##Clone Nanode to device from git
showtext "Clone Nanode to device from git"
# Update Link
#git clone -b ubuntuServer-20.04 --single-branch https://github.com/monero-ecosystem/Nanode.git 2>&1 | tee -a "$DEBUG_LOG"

#Backup User values
showtext "Creating backups of any settings you have customised
*****
If a setting did not exist on your previous version you may see some errors here for missing files, these can safely be ignored
*****"
#home dir
mv /home/nanode/bootstatus.sh /home/nanode/bootstatus_retain.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/current-ver.sh /home/nanode/current-ver_retain.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/current-ver-exp.sh /home/nanode/current-ver-exp_retain.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/current-ver-pi.sh /home/nanode/current-ver-pi_retain.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/current-ver-p2pool.sh /home/nanode/current-ver-p2pool_retain.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/current-ver-lws.sh /home/nanode/current-ver-lws_retain.sh 2> >(tee -a "$DEBUG_LOG" >&2)
#variables dir
mv /home/nanode/variables/credits.sh /home/nanode/variables/credits_retain.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/difficulty.sh /home/nanode/variables/difficulty_retain.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/i2p-address.sh /home/nanode/variables/i2p-address_retain.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/i2p-port.sh /home/nanode/variables/i2p-port_retain.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/i2p-tx-proxy-port.sh /home/nanode/variables/i2p-tx-proxy-port_retain.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/in-peers.sh /home/nanode/variables/in-peers_retain.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/limit-rate-down.sh /home/nanode/variables/limit-rate-down_retain.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/limit-rate-up.sh /home/nanode/variables/limit-rate-up_retain.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/mining-address.sh /home/nanode/variables/mining-address_retain.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/mining-intensity.sh /home/nanode/variables/mining-intensity_retain.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/monero-port.sh /home/nanode/variables/monero-port_retain.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/monero-port-public-free.sh /home/nanode/variables/monero-port-public-free_retain.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/monero-rpcpay-port.sh /home/nanode/variables/monero-rpcpay-port_retain.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/monero-stats-port.sh /home/nanode/variables/monero-stats-port_retain.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/out-peers.sh /home/nanode/variables/out-peers_retain.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/payment-address.sh /home/nanode/variables/payment-address_retain.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/RPCp.sh /home/nanode/variables/RPCp_retain.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/RPCu.sh /home/nanode/variables/RPCu_retain.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/htmlPasswordRequired.sh /home/nanode/variables/htmlPasswordRequired_retain.sh 2> >(tee -a "$DEBUG_LOG" >&2)
showtext "User-set configuration saved"


#Install Update
showtext "Installing update"
##Add Nanode systemd services
showtext "Add Nanode systemd services"
{
	sudo mv /home/nanode/Nanode/etc/systemd/system/*.service /etc/systemd/system/
	sudo chmod 644 /etc/systemd/system/*.service
	sudo chown root /etc/systemd/system/*.service
	sudo systemctl daemon-reload
	sudo systemctl start moneroStatus.service
	sudo systemctl enable moneroStatus.service
} 2>&1 | tee -a "$DEBUG_LOG"
showtext "Success"

##Updating Nanode scripts in home directory
showtext "Updating Nanode scripts in home directory"
{
cp -afr /home/nanode/Nanode/home/nanode/* /home/nanode/
mv /home/nanode/Nanode/home/nanode/.profile /home/nanode/
sudo chmod -R 777 /home/nanode/*
} 2>&1 | tee -a "$DEBUG_LOG"
showtext "Success"

#Configure apache server for access to monero log file
showtext "Configure apache server for access to monero log file"
{
sudo mv /home/nanode/Nanode/etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf
sudo chmod 777 /etc/apache2/sites-enabled/000-default.conf
sudo chown root /etc/apache2/sites-enabled/000-default.conf
sudo /etc/init.d/apache2 restart
} 2>&1 | tee -a "$DEBUG_LOG"

showtext "Success"
##Setup local hostname
showtext "Enable local hostname nanode.local"
sudo mv /home/nanode/Nanode/etc/avahi/avahi-daemon.conf /etc/avahi/avahi-daemon.conf 2>&1 | tee -a "$DEBUG_LOG"
sudo /etc/init.d/avahi-daemon restart 2>&1 | tee -a "$DEBUG_LOG"
showtext "Success"

##Update html template
showtext "Configuring Web-UI template with Nanode pages"
#First move hidden file specifically .htaccess file then entire directory
sudo mv /home/nanode/Nanode/HTML/.htaccess /var/www/html/ 2>&1 | tee -a "$DEBUG_LOG"
rm -R /var/www/html/*.php
#Preserve user variables (custom ports, hidden service onion address, miningrpc pay address etc). Updater script overwrites/merges all files, this renames them temporarily to avoid merge.
mv /var/www/html/credits.txt /var/www/html/credits_retain.txt 2> >(tee -a "$DEBUG_LOG" >&2)
mv /var/www/html/difficulty.txt /var/www/html/difficulty_retain.txt 2> >(tee -a "$DEBUG_LOG" >&2)
mv /var/www/html/i2p-address.txt /var/www/html/i2p-address_retain.txt 2> >(tee -a "$DEBUG_LOG" >&2)
mv /var/www/html/i2p-port.txt /var/www/html/i2p-port_retain.txt 2> >(tee -a "$DEBUG_LOG" >&2)
mv /var/www/html/i2p-tx-proxy-port.txt /var/www/html/i2p-tx-proxy-port_retain.txt 2> >(tee -a "$DEBUG_LOG" >&2)
mv /var/www/html/mining_address.txt /var/www/html/mining_address_retain.txt 2> >(tee -a "$DEBUG_LOG" >&2)
mv /var/www/html/mining_intensity.txt /var/www/html/mining_intensity_retain.txt 2> >(tee -a "$DEBUG_LOG" >&2)
mv /var/www/html/monero-free-public-port.txt /var/www/html/monero-free-public-port_retain.txt 2> >(tee -a "$DEBUG_LOG" >&2)
mv /var/www/html/monero-port-rpc-pay.txt /var/www/html/monero-port-rpc-pay_retain.txt 2> >(tee -a "$DEBUG_LOG" >&2)
mv /var/www/html/monero-rpc-port.txt /var/www/html/monero-rpc-port_retain.txt 2> >(tee -a "$DEBUG_LOG" >&2)
mv /var/www/html/onion-address.txt /var/www/html/onion-address_retain.txt 2> >(tee -a "$DEBUG_LOG" >&2)
mv /var/www/html/payment-address.txt /var/www/html/payment-address_retain.txt 2> >(tee -a "$DEBUG_LOG" >&2)
mv /var/www/html/user-set-custom.txt /var/www/html/user-set-custom_retain.txt 2> >(tee -a "$DEBUG_LOG" >&2)
#Overwrite /var/www/html with updated contents
sudo rsync -a /home/nanode/Nanode/HTML/* /var/www/html/ 2>&1 | tee -a "$DEBUG_LOG"
sudo chown www-data -R /var/www/html/ 2>&1 | tee -a "$DEBUG_LOG"
sudo chmod 777 -R /var/www/html/ 2>&1 | tee -a "$DEBUG_LOG"
#Restore User variables
mv /var/www/html/credits_retain.txt /var/www/html/credits.txt 2> >(tee -a "$DEBUG_LOG" >&2)
mv /var/www/html/difficulty_retain.txt /var/www/html/difficulty.txt 2> >(tee -a "$DEBUG_LOG" >&2)
mv /var/www/html/i2p-address_retain.txt /var/www/html/i2p-address.txt 2> >(tee -a "$DEBUG_LOG" >&2)
mv /var/www/html/i2p-port_retain.txt /var/www/html/i2p-port.txt 2> >(tee -a "$DEBUG_LOG" >&2)
mv /var/www/html/i2p-tx-proxy-port_retain.txt /var/www/html/i2p-tx-proxy-port.txt 2> >(tee -a "$DEBUG_LOG" >&2)
mv /var/www/html/mining_address_retain.txt /var/www/html/mining_address.txt 2> >(tee -a "$DEBUG_LOG" >&2)
mv /var/www/html/mining_intensity_retain.txt /var/www/html/mining_intensity.txt 2> >(tee -a "$DEBUG_LOG" >&2)
mv /var/www/html/monero-free-public-port_retain.txt /var/www/html/monero-free-public-port.txt 2> >(tee -a "$DEBUG_LOG" >&2)
mv /var/www/html/monero-port-rpc-pay_retain.txt /var/www/html/monero-port-rpc-pay.txt 2> >(tee -a "$DEBUG_LOG" >&2)
mv /var/www/html/monero-rpc-port_retain.txt /var/www/html/monero-rpc-port.txt 2> >(tee -a "$DEBUG_LOG" >&2)
mv /var/www/html/onion-address_retain.txt /var/www/html/onion-address.txt 2> >(tee -a "$DEBUG_LOG" >&2)
mv /var/www/html/payment-address_retain.txt /var/www/html/payment-address.txt 2> >(tee -a "$DEBUG_LOG" >&2)
mv /var/www/html/user-set-custom_retain.txt /var/www/html/user-set-custom.txt 2> >(tee -a "$DEBUG_LOG" >&2)
#Full-mode html update complete

#Set correct config for if HTML (Web UI) Password is required.

if [ "$HTMLPASSWORDREQUIRED" = TRUE ]
then
sudo cp /home/nanode/variables/000-default-passwordAuthEnabled.conf /etc/apache2/sites-enabled/000-default.conf
sudo chown root /etc/apache2/sites-enabled/000-default.conf
sudo chmod 777 /etc/apache2/sites-enabled/000-default.conf
sudo systemctl restart apache2
fi

showtext "Success"

#Restore User Values
showtext "Restoring your personal settings"
#home dir
mv /home/nanode/bootstatus_retain.sh /home/nanode/bootstatus.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/current-ver_retain.sh /home/nanode/current-ver.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/current-ver-exp_retain.sh /home/nanode/current-ver-exp.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/current-ver-pi_retain.sh /home/nanode/current-ver-pi.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/current-ver-p2pool_retain.sh /home/nanode/current-ver-p2pool.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/current-ver-lws_retain.sh /home/nanode/current-ver-lws.sh 2> >(tee -a "$DEBUG_LOG" >&2)

#variables dir
mv /home/nanode/variables/difficulty_retain.sh /home/nanode/variables/difficulty.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/credits_retain.sh /home/nanode/variables/credits.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/i2p-address_retain.sh /home/nanode/variables/i2p-address.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/i2p-port_retain.sh /home/nanode/variables/i2p-port.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/i2p-tx-proxy-port_retain.sh /home/nanode/variables/i2p-tx-proxy-port.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/in-peers_retain.sh /home/nanode/variables/in-peers.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/limit-rate-down_retain.sh /home/nanode/variables/limit-rate-down.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/limit-rate-up_retain.sh /home/nanode/variables/limit-rate-up.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/mining-address_retain.sh /home/nanode/variables/mining-address.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/mining-intensity_retain.sh /home/nanode/variables/mining-intensity.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/monero-port_retain.sh /home/nanode/variables/monero-port.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/monero-port-public-free_retain.sh /home/nanode/variables/monero-port-public-free.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/out-peers_retain.sh /home/nanode/variables/out-peers.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/payment-address_retain.sh /home/nanode/variables/payment-address.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/RPCp_retain.sh /home/nanode/variables/RPCp.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/RPCu_retain.sh /home/nanode/variables/RPCu.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/monero-rpcpay-port_retain.sh /home/nanode/variables/monero-rpcpay-port.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/monero-stats-port_retain.sh /home/nanode/variables/monero-stats-port.sh 2> >(tee -a "$DEBUG_LOG" >&2)
mv /home/nanode/variables/htmlPasswordRequired_retain.sh /home/nanode/variables/htmlPasswordRequired.sh 2> >(tee -a "$DEBUG_LOG" >&2)

showtext "User configuration restored"

##Set Swappiness lower
showtext "Decreasing swappiness"
sudo sysctl vm.swappiness=10 2> >(tee -a "$DEBUG_LOG" >&2)
showtext "Success"
##Update crontab
showtext "Updating crontab tasks"
crontab /home/nanode/Nanode/var/spool/cron/crontabs/nanode 2> >(tee -a "$DEBUG_LOG" >&2)
showtext "Success"

#Attempt update of tor hidden service settings
{
	if [ -f /usr/bin/tor ]; then #Crude way of detecting tor installed
		showtext "Update of tor hidden service settings"
		sudo wget https://raw.githubusercontent.com/monero-ecosystem/Nanode/ubuntuServer-20.04/etc/tor/torrc -O /etc/tor/torrc
		showtext "Applying Settings..."
		sudo chmod 644 /etc/tor/torrc
		sudo chown root /etc/tor/torrc
		#Insert user specific local IP for correct hiddenservice redirect (line 73 overwrite)
		sudo sed -i "73s/.*/HiddenServicePort 18081 $(hostname -I | awk '{print $1}'):18081/" /etc/tor/torrc
		showtext "Restarting tor service..."
		sudo service tor restart
	fi
} 2>&1 | tee -a "$DEBUG_LOG"

#Restart statusOutputs script service for changes to take effect
sudo systemctl restart moneroStatus.service


##Check-Install log.io (Real-time service monitoring)
#Establish Device IP
#shellcheck source=home/nanode/variables/deviceIp.sh
. ~/variables/deviceIp.sh
showtext "Installing log.io"
{
	sudo apt-get install nodejs npm -y
	sudo npm install -g log.io
	sudo npm install -g log.io-file-input
	mkdir -p ~/.log.io/inputs/
	mv /home/nanode/Nanode/.log.io/inputs/file.json ~/.log.io/inputs/file.json
	mv /home/nanode/Nanode/.log.io/server.json ~/.log.io/server.json
	sed -i "s/127.0.0.1/$DEVICE_IP/g" ~/.log.io/server.json
	sed -i "s/127.0.0.1/$DEVICE_IP/g" ~/.log.io/inputs/file.json
	sudo systemctl enable --now log-io-server.service
	sudo systemctl enable --now log-io-file.service
} 2>&1 | tee -a "$DEBUG_LOG"

#Update system version number to new one installed
{
	#FIXME: change url
	wget https://raw.githubusercontent.com/monero-ecosystem/Nanode/ubuntuServer-20.04/new-ver-pi.sh -O /home/nanode/new-ver-pi.sh
	chmod 755 /home/nanode/new-ver-pi.sh
	. /home/nanode/new-ver-pi.sh
	showtext "Update system version number"
	echo "#!/bin/bash
	CURRENT_VERSION_PI=$NEW_VERSION_PI" > /home/nanode/current-ver-pi.sh
	showtext "Success"
	#ubuntu /dev/null odd requiremnt to set permissions
	sudo chmod 777 /dev/null
} 2>&1 | tee -a "$DEBUG_LOG"

#Clean up files
showtext "Cleanup leftover directories"

sudo rm -r "/home/nanode/Nanode/"
rm "/home/nanode/new-ver-pi.sh"
showtext "Success"

##End debug log
showtext "
####################
End update-nanode.sh script $(date)
####################
"

whiptail --title "Nanode Updater" --msgbox "\n\nYour Nanode has been updated to version ${NEW_VERSION_PI}" 12 78


#Update complete - Return to menu
./setup.sh
