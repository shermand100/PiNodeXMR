#!/bin/bash
#Establish IP/Port
DEVICE_IP="$(hostname -I | awk '{print $1}')"
	#Import Port Number
	. /home/pinodexmr/monero-stats-port.sh
	#Import RPC username
	. /home/pinodexmr/RPCu.sh
	#Import RPC password
	. /home/pinodexmr/RPCp.sh
#Stop Monerod
cd /home/pinodexmr/monero/build/release/bin/
./monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_STATS_PORT --rpc-login=$RPCu:$RPCp exit