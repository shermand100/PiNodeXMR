#!/bin/bash
#Import Start Flag Values:
	#Create device IP
	MY_IP="$(hostname -I | awk '{print $1}')"
	#Import Port Number
	. /home/pinodexmr/monero-port.sh
	#Import RPC username
	. /home/pinodexmr/RPCu.sh
	#Import RPC password
	. /home/pinodexmr/RPCp.sh
	#Load boot status - what condition was node last run
	. /home/pinodexmr/bootstatus.sh
	#Import Restricted Port Number (external use)
	. /home/pinodexmr/monero-port.sh

		if [ $BOOT_STATUS -eq 6 ]
then
		#Adapted command for starting onion-block-explorer only for public node due to restricted rpc commands
cd /home/pinodexmr/onion-monero-blockchain-explorer/build/
./xmrblocks --port 8081 --enable-pusher --enable-emission-monitor --deamon-url=HTTP://${MY_IP// }:$MONERO_PORT --mempool-info-timeout 60000 --mempool-refresh-time 30 --concurrency 1
else if [ $BOOT_STATUS -eq 7 ]
then
		#Adapted command for starting onion-block-explorer only for public node due to restricted rpc commands
cd /home/pinodexmr/onion-monero-blockchain-explorer/build/
taskset 1 ./xmrblocks --port 8081 --enable-pusher=1 --enable-emission-monitor=1 --daemon-url=http:://0.0.0.0:$MONERO_PORT
else	
		#Start onion-block-explorer
cd /home/pinodexmr/onion-monero-blockchain-explorer/build/
./xmrblocks --port 8081 --enable-pusher --enable-emission-monitor --deamon-url=HTTP://${MY_IP// }:$MONERO_PORT --daemon-login $RPCu:$RPCp --mempool-info-timeout 60000 --mempool-refresh-time 30 --concurrency 1
fi
