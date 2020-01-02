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
	
	if [ $BOOT_STATUS -eq 6 ]
then
		#Adapted command for restricted public rpc calls (payments)
	./monero-active/monerod --rpc-bind-ip=$(hostname -I) --rpc-bind-port=$MONERO_STATS_PORT --rpc-ssl disabled print_cn | sed '1d' > /var/www/html/print_cn.txt
else
	#Connected Peers info
	./monero-active/monerod --rpc-bind-ip=$(hostname -I) --rpc-bind-port=$MONERO_PORT --rpc-login=$RPCu:$RPCp --rpc-ssl disabled print_cn | sed '1d' > /var/www/html/print_cn.txt			
fi	
	
	

