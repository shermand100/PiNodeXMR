#!/bin/sh
#Establish IP/Port
DEVICE_IP="$(hostname -I)"
#Import Start Flag Values:
	#Import Port Number
	. /home/pinodexmr/monero-port.sh
#Node Status
./monero/monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT status > /var/www/html/Node_Status.txt