#!/bin/sh
	#Load boot status - what condition was node last run
	. /home/pinodexmr/bootstatus.sh
	#Import Restricted Port Number (external use)
	. /home/pinodexmr/monero-port.sh
	#Import RPC username
	. /home/pinodexmr/RPCu.sh
	#Import RPC password
	. /home/pinodexmr/RPCp.sh
	#Establish IP/Port
DEVICE_IP="$(hostname -I | awk '{print $1}')"

	if [ $BOOT_STATUS -eq 2 ]
then	
		#Node Version Print
		VERSION="$(./monero/build/release/bin/monerod --rpc-bind-ip=${DEVICE_IP} --rpc-bind-port=${MONERO_PORT} --rpc-login=${RPCu}:${RPCp} --rpc-ssl disabled version | sed -n '2p' | cut -c 5-)" && echo "${VERSION}" > /var/www/html/node_version.txt
fi	
	
	
	if [ $BOOT_STATUS -eq 3 ] || [ $BOOT_STATUS -eq 5 ]
then	
		#Node Status
		VERSION="$(./monero/build/release/bin/monerod --rpc-bind-ip=${DEVICE_IP} --rpc-bind-port=${MONERO_PORT} --rpc-login=${RPCu}:${RPCp} --rpc-ssl disabled version | sed -n '2p' | cut -c 5-)" && echo "${VERSION}" > /var/www/html/node_version.txt
fi	


	if [ $BOOT_STATUS -eq 4 ]
then	
		#Tor Node Status - Fixed RPC P and Port due to link to tor hidden service settings at /etc/tor/torrc
		VERSION="$(./monero/build/release/bin/monerod --rpc-bind-ip=127.0.0.1 --rpc-bind-port=18081 --rpc-login=${RPCu}:${RPCp} --rpc-ssl disabled version | sed -n '2p' | cut -c 5-)" && echo "${VERSION}" > /var/www/html/node_version.txt;

fi
	
	if [ $BOOT_STATUS -eq 6 ]
then
		#Adapted command for restricted public rpc calls (payments)
		VERSION="$(./monero/build/release/bin/monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT --rpc-ssl disabled version | sed -n '2p' | cut -c 5-)" && echo "${VERSION}" > /var/www/html/node_version.txt
fi

	if [ $BOOT_STATUS -eq 7 ]
then
		#Adapted command for public free (restricted) rpc calls. No auth needed for local.
		VERSION="$(./monero/build/release/bin/monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT --rpc-ssl disabled version | sed -n '2p' | cut -c 5-)" && echo "${VERSION}" > /var/www/html/node_version.txt
fi


	if [ $BOOT_STATUS -eq 8 ]
then	
		#Node Status
		VERSION="$(./monero/build/release/bin/monerod --rpc-bind-ip=${DEVICE_IP} --rpc-bind-port=$MONERO_PORT --rpc-login=${RPCu}:${RPCp} --rpc-ssl disabled version | sed -n '2p' | cut -c 5-)" && echo "${VERSION}" > /var/www/html/node_version.txt;

fi
