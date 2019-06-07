#!/bin/bash
#Establish IP/Port
DEVICE_IP="$(hostname -I)"
	#Import Port Number
	. /home/pinodexmr/monero-port.sh
	#Import RPC username
	. /home/pinodexmr/RPCu.sh
	#Import RPC password
	. /home/pinodexmr/RPCp.sh
#Stop Monerod
./monero/monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT --rpc-login=$RPCu:$RPCp exit

#Allow time for Monerod to stop
sleep "60"

#Shutdown
sudo shutdown now