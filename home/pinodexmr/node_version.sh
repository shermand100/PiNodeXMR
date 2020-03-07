#!/bin/sh
	#Load boot status - what condition was node last run
	. /home/pinodexmr/bootstatus.sh
	#Import Un-restricted Port Number (for internal status updates)
	. /home/pinodexmr/monero-stats-port.sh
	#Import Restricted Port Number (external use)
	. /home/pinodexmr/monero-port.sh
	#Import RPC username
	. /home/pinodexmr/RPCu.sh
	#Import RPC password
	. /home/pinodexmr/RPCp.sh
	#Establish IP/Port
	DEVICE_IP="$(hostname -I)"


	if [ $BOOT_STATUS -eq 6 ]
then
		#Adapted command for restricted public rpc calls (payments)
		VERSION="$(./monero/build/release/bin/monerod --rpc-bind-ip=${DEVICE_IP} --rpc-bind-port=${MONERO_STATS_PORT} --rpc-ssl disabled version | sed -n 's/Monero/&/p')" && echo "${VERSION#*I}" > /var/www/html/node_version.txt
else
		#Node Version Print
		VERSION="$(./monero/build/release/bin/monerod --rpc-bind-ip=${DEVICE_IP} --rpc-bind-port=${MONERO_PORT} --rpc-login=${RPCu}:${RPCp} --rpc-ssl disabled version | sed -n 's/Monero/&/p')" && echo "${VERSION#*I}" | cut -c9- > /var/www/html/node_version.txt
	
fi 