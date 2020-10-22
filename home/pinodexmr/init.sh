#!/bin/bash
#IP tables rule for Tor
sudo iptables -I OUTPUT -p tcp -d 127.0.0.1 -m tcp --dport 18081 -j ACCEPT
#Load boot status - what condition was node last run
. /home/pinodexmr/bootstatus.sh

#Establish IP
	DEVICE_IP="$(hostname -I | awk '{print $1}')"

#Load Variables
. /home/pinodexmr/current-ver.sh
. /home/pinodexmr/monero-port.sh
. /home/pinodexmr/explorer-flag.sh

echo $CURRENT_VERSION 'Current Version'
echo $DEVICE_IP 'Device IP'
echo $MONERO_PORT 'Monero Port'
sleep 3
		sudo chown -R pinodexmr /home/pinodexmr/.bitmonero
		sudo chmod 777 -R /home/pinodexmr/.bitmonero

if [ $BOOT_STATUS -eq 2 ]
then
		echo "Boot complete, system ready for start. See web-ui at $(hostname -I) to interface."
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
		echo "loading ...."
fi

if [ $BOOT_STATUS -eq 6 ]
then
	sudo systemctl start monerod-start-public.service
	echo "Monero Public Node (RPC_Pay) Started in background"
else
		echo "loading ....."
fi

if [ $BOOT_STATUS -eq 7 ]
then
	sudo systemctl start monerod-start-free.service
	echo "Monero Free Public Node Started in background"
else
		echo "loading ......"
fi

if [ $BOOT_STATUS -eq 8 ]
then
	sudo systemctl start monerod-start-i2p.service
	echo "Monero I2P Node Started in background"
else
		echo "loading ......."
fi

if [ $BOOT_STATUS -gt 2 ] && [ $EXPLORER_START -eq 1 ]
then
	echo "Start Monero-onion-block-explorer"
	sudo systemctl start explorer-start.service
	echo "Starting Onion-Block-Explorer in background"
fi
#Notes:
#Block explorer won't auto start on boot unless node is configured to auto-start monerod. 
#This to prevent .bitmonero directory being in use when configuring storage during setup, preventing mounting of drive to in use location.
