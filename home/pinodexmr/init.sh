#!/bin/bash
#IP tables rule for Tor
sudo iptables -I OUTPUT -p tcp -d 127.0.0.1 -m tcp --dport 18081 -j ACCEPT
#Load boot status - what condition was node last run
. /home/pinodexmr/bootstatus.sh

#Establish IP
	DEVICE_IP="$(hostname -I)"
#Output onion address
sudo cat /var/lib/tor/hidden_service/hostname > /var/www/html/onion-address.txt

#Load Variables
. /home/pinodexmr/current-ver.sh
. /home/pinodexmr/monero-port.sh
. /home/pinodexmr/setupcomplete.sh

echo $CURRENT_VERSION 'Current Version'
echo $DEVICE_IP 'Device IP'
echo $MONERO_PORT 'Monero Port'
sleep "3"

if [ $BOOT_STATUS -eq 2 ]
then
		echo "Fist boot complete, system ready for first run command. See web-ui at $(hostname -I) for launch buttons."
else
	echo "loading ."	
fi

if [ $BOOT_STATUS -eq 3 ]
then
	sudo systemctl start monerod-start.service
	echo "Monero Node Started in background"
else
	echo "loading .."
fi

if [ $BOOT_STATUS -eq 4 ]
then
	sudo systemctl start monerod-start-tor.service
	echo "Monero tor Node Started in background"
else
		echo "loading ..."
fi

if [ $BOOT_STATUS -eq 5 ]
then
	sudo systemctl start monerod-start-mining.service
	echo "Monero Solo Mining Node Started in background"
else
		echo "loading ..."
fi

if [ $BOOT_STATUS -eq 6 ]
then
	sudo systemctl start monerod-start-public.service
	echo "Monero Public Node Started in background"
else
		echo "loading ..."
fi

if [ $BOOT_STATUS -gt 2 || $SETUP_COMPLETE -eq 1 ]
then
echo "Start Monero-onion-block-explorer"
	sudo systemctl start explorer-start.service
	echo "Starting Onion-Block-Explorer in background"
fi
#Notes:
#Block explorer won't auto start on boot unless node is configured to auto-start monerod. 
#This to prevent .bitmonero directory being in use when configuring storage during setup, preventing mounting of drive to in use location.