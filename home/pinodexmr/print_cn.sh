#!/bin/sh
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
	#Establish IP/Port
	DEVICE_IP="$(hostname -I)"
	
	if [ $BOOT_STATUS -eq 6 ]
then
		#Adapted command for restricted public rpc calls (payments)
	PRINT_CN="$(./monero/build/release/bin/monerod --rpc-bind-ip=${DEVICE_IP} --rpc-bind-port=${MONERO_STATS_PORT} --rpc-login=${RPCu}:${RPCp} --rpc-ssl disabled print_cn | sed '1d')" && echo "$PRINT_CN" > /var/www/html/print_cn.txt
else
	#Connected Peers info
		PRINT_CN="$(./monero/build/release/bin/monerod --rpc-bind-ip=${DEVICE_IP} --rpc-bind-port=${MONERO_PORT} --rpc-login=${RPCu}:${RPCp} --rpc-ssl disabled print_cn | sed '1d')" && echo "$PRINT_CN" > /var/www/html/print_cn.txt
fi	
	
	

