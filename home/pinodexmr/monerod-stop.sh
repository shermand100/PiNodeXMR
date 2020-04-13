#!/bin/bash
#Establish IP/Port
DEVICE_IP="$(hostname -I | awk '{print $1}')"
	#Import Port Number
	. /home/pinodexmr/monero-port.sh
	#Import RPC username
	. /home/pinodexmr/RPCu.sh
	#Import RPC password
	. /home/pinodexmr/RPCp.sh
		#Import stats Port Number
	. /home/pinodexmr/monero-stats-port.sh
	
	
#Stop Monerod
cd /home/pinodexmr/monero/build/release/bin/

./monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT --rpc-login=$RPCu:$RPCp exit


	if [ $BOOT_STATUS -eq 3 ] || [ $BOOT_STATUS -eq 4 ] || [ $BOOT_STATUS -eq 5 ]
then	
		#Reboot Private(3) tor(4) mining(5)
		./monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT --rpc-login=$RPCu:$RPCp exit
fi	
	
	if [ $BOOT_STATUS -eq 6 ]
then
		#Adapted command for restricted public rpc calls (payments)
		./monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_STATS_PORT --rpc-login=$RPCu:$RPCp exit
fi

	if [ $BOOT_STATUS -eq 7 ]
then
		#Adapted command for public free (restricted) rpc calls. No auth needed for local.
		./monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT exit
fi
