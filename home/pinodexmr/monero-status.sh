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
	
	if [ $BOOT_STATUS -eq 2 ]
then	
		#System Idle
		echo "--System Idle--\nSelect a mode for your PiNode-XMR to start on the \"Advanced Settings\" page.\nThen allow at least 5 minutes for stats to appear here. " > /var/www/html/Node_Status.txt
fi	
	
	
	if [ $BOOT_STATUS -eq 3 ] || [ $BOOT_STATUS -eq 5 ]
then	
		#Node Status
			OUTPUT="$(./monero/build/release/bin/monerod --rpc-bind-ip=${DEVICE_IP} --rpc-bind-port=${MONERO_PORT} --rpc-login=${RPCu}:${RPCp} --rpc-ssl disabled status | sed -n 's/Height:/&/p')" && echo "$OUTPUT" > /var/www/html/Node_Status.txt
fi	

	if [ $BOOT_STATUS -eq 4 ] || [ $BOOT_STATUS -eq 8 ]
then
		#Adapted command for tor rpc calls (payments)
			OUTPUT="$(./monero/build/release/bin/monerod --rpc-bind-ip=127.0.0.1 --rpc-bind-port=18081 --rpc-login=${RPCu}:${RPCp} --rpc-ssl disabled status | sed -n 's/Height:/&/p')" && echo "$OUTPUT" > /var/www/html/Node_Status.txt
fi
	
	if [ $BOOT_STATUS -eq 6 ]
then
		#Adapted command for restricted public rpc calls (payments)
			OUTPUT="$(./monero/build/release/bin/monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_STATS_PORT --rpc-ssl disabled status | sed -n 's/Height:/&/p')" && echo "$OUTPUT" > /var/www/html/Node_Status.txt
fi

	if [ $BOOT_STATUS -eq 7 ]
then
		#Adapted command for public free (restricted) rpc calls. No auth needed for local.
			OUTPUT="$(./monero/build/release/bin/monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT --rpc-ssl disabled status | sed -n 's/Height:/&/p')" && echo "$OUTPUT" > /var/www/html/Node_Status.txt
fi
