#!/bin/bash
#Import Start Flag Values:
	#Create device IP
	MY_IP="$(hostname -I)"
	#Import Port Number
	. /home/pinodexmr/monero-port.sh
	#Import RPC username
	. /home/pinodexmr/RPCu.sh
	#Import RPC password
	. /home/pinodexmr/RPCp.sh
	#Load boot status - what condition was node last run
	. /home/pinodexmr/bootstatus.sh
	#Import Un-restricted Port Number (for internal status updates)
	. /home/pinodexmr/monero-stats-port.sh
	#Import Restricted Port Number (external use)
	. /home/pinodexmr/monero-port.sh

		if [ $BOOT_STATUS -eq 6 ]
then
		#Adapted command for starting onion-block-explorer only for public node due to restricted rpc commands
cd /home/pinodexmr/onion-monero-blockchain-explorer/build/
/usr/bin/flock -n /home/pinodexmr/flock/xmrblocks.lock ./xmrblocks --port 8081 --enable-pusher --enable-emission-monitor --deamon-url=HTTP://${MY_IP// }:$MONERO_STATS_PORT --mempool-info-timeout 60000 --mempool-refresh-time 30 --concurrency 2
else
	#Start onion-block-explorer
cd /home/pinodexmr/onion-monero-blockchain-explorer/build/
/usr/bin/flock -n /home/pinodexmr/flock/xmrblocks.lock ./xmrblocks --port 8081 --enable-pusher --enable-emission-monitor --deamon-url=HTTP://${MY_IP// }:$MONERO_PORT --daemon-login $RPCu:$RPCp --mempool-info-timeout 60000 --mempool-refresh-time 30 --concurrency 2
fi
