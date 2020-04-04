#!/bin/sh
#Establish IP/Port
DEVICE_IP="$(hostname -I | awk '{print $1}')"
#Import Start Flag Values:
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

# use temp file 
_temp="./dialog.$$"
	
	if [ $BOOT_STATUS -eq 6 ]
then
		#Adapted command for restricted public rpc calls (payments)
		./monero/build/release/bin/monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_STATS_PORT --rpc-ssl disabled status | sed -n '2'p && > /var/www/html/Node_Status.txt
else
		#Node Status
			OUTPUT="$(./monero/build/release/bin/monerod --rpc-bind-ip=${DEVICE_IP} --rpc-bind-port=${MONERO_PORT} --rpc-login=${RPCu}:${RPCp} --rpc-ssl disabled status | sed -n 's/Height:/&/p')" && echo "$OUTPUT" > /var/www/html/Node_Status.txt
fi
