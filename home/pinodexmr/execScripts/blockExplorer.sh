#!/bin/bash
#Import Start Flag Values:
	#Establish Device IP
	. /home/pinodexmr/variables/deviceIp.sh
	#Import Port Number
	. /home/pinodexmr/variables/monero-port.sh
	#Import Public (free) Port Number
	. /home/pinodexmr/variables/monero-port-public-free.sh
	#Import RPC username
	. /home/pinodexmr/variables/RPCu.sh
	#Import RPC password
	. /home/pinodexmr/variables/RPCp.sh
	#Load boot status - what condition was node last run
	. /home/pinodexmr/bootstatus.sh

if [ $BOOT_STATUS -eq 6 ]
		then
		#Adapted command for starting onion-block-explorer only for public node due to restricted rpc commands
cd /home/pinodexmr/onion-monero-blockchain-explorer/build/
./xmrblocks --port 8081 --enable-pusher --enable-emission-monitor --daemon-url=HTTP://${DEVICE_IP// }:$MONERO_PORT --mempool-info-timeout 60000 --mempool-refresh-time 30 --concurrency 1
	else if [ $BOOT_STATUS -eq 7 ]
		then
		#Adapted command for starting onion-block-explorer only for public node due to restricted rpc commands
cd /home/pinodexmr/onion-monero-blockchain-explorer/build/
./xmrblocks --port 8081 --enable-pusher=1 --enable-emission-monitor=1 --daemon-url=HTTP://${DEVICE_IP// }:$MONERO_PUBLIC_PORT --concurrency=1
	else	
		#Start onion-block-explorer
cd /home/pinodexmr/onion-monero-blockchain-explorer/build/
./xmrblocks --port 8081 --enable-pusher --enable-emission-monitor --daemon-url=HTTP://${DEVICE_IP// }:$MONERO_PORT --daemon-login $RPCu:$RPCp --mempool-info-timeout 60000 --mempool-refresh-time 30 --concurrency 1
	fi
fi
