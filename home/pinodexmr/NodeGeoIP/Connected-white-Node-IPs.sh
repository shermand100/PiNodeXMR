#!/bin/sh

	#Return to home dir
cd ~/

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
DEVICE_IP="$(hostname -I | awk '{print $1}')"

cd ~/monero/build/release/bin/
	#Print all white/grey nodes
./monerod --rpc-bind-ip=${DEVICE_IP} --rpc-bind-port=${MONERO_PORT} --rpc-login=${RPCu}:${RPCp} --rpc-ssl disabled print_pl | sed '1d' | awk '{ if ($1 == "white") print $3}' | cut -f1 -d":" > /home/pinodexmr/NodeGeoIP/IPoutput.txt

	#Update timestamp of when list last created
echo "List last updated: " > /var/www/html/node-list-timestamp.txt
date >> /var/www/html/node-list-timestamp.txt
	
cd ~/	