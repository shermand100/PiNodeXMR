#!/bin/sh
#Establish IP/Port
DEVICE_IP="$(hostname -I)"
#Import Start Flag Values:
	#Import Port Number
	. /home/pinodexmr/monero-port.sh
#Node MemPool status
./monero/monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT print_pool_sh > /var/www/html/TXPool-short_Status.txt