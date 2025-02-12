#!/bin/bash

#Import Start Flag Values:
	#Establish Device IP
	. /home/pinodexmr/variables/deviceIp.sh
	#Import Port Number
	. /home/pinodexmr/variables/monero-port.sh
	#Import Mining Address
	. /home/pinodexmr/variables/mining-address.sh
	#Import Public (free) Port Number
	. /home/pinodexmr/variables/monero-port-public-free.sh
	#Import CPU threads / 'intensity'
	. /home/pinodexmr/variables/mining-threads.sh	
	#Import RPC username
	. /home/pinodexmr/variables/RPCu.sh
	#Import RPC password
	. /home/pinodexmr/variables/RPCp.sh
	#Load boot status - what condition was node last run
	. /home/pinodexmr/bootstatus.sh

#Start P2Pool

cd /home/pinodexmr/p2pool/build

if [ $BOOT_STATUS -eq 2 ]
		then
		#Monerod not running
		set -e
		echo "Error: Monerod not running."
fi

if [ $BOOT_STATUS -eq 3 ] || [ $BOOT_STATUS -eq 5 ]
		then
		#Adapted command for starting P2Pool only for private node due to restricted rpc commands
		./p2pool --host $DEVICE_IP --rpc-port $MONERO_PORT --rpc-login $RPCu:$RPCp --wallet $MINING_ADDRESS --start-mining $MINING_THREADS --data-api /var/www/html/api/ --local-api --no-color --light-mode --no-cache --loglevel 1 --data-dir ~/p2pool/build/ --mini
fi

if [ $BOOT_STATUS -eq 4 ]
		then
		#Adapted command for starting P2Pool only for private node due to restricted rpc commands
		./p2pool --host $DEVICE_IP --rpc-port $MONERO_PORT --rpc-login $RPCu:$RPCp --wallet $MINING_ADDRESS --start-mining $MINING_THREADS --data-api /var/www/html/api/ --local-api --no-color --light-mode --no-cache --loglevel 1 --data-dir ~/p2pool/build/ --mini
fi

if [ $BOOT_STATUS -eq 6 ]
		then
		#Adapted command for starting P2Pool only for public node due to restricted rpc commands
		./p2pool --host $DEVICE_IP --rpc-port $MONERO_PORT --wallet $MINING_ADDRESS --start-mining $MINING_THREADS --data-api /var/www/html/api/ --local-api --no-color --light-mode --no-cache --loglevel 1 --data-dir ~/p2pool/build/ --mini
fi

if [ $BOOT_STATUS -eq 7 ]
		then
		#Adapted command for starting P2Pool only for clearnet public node, note change in port to request on internal non-restricted port.
		./p2pool --host $DEVICE_IP --rpc-port $MONERO_PUBLIC_PORT --wallet $MINING_ADDRESS --start-mining $MINING_THREADS --data-api /var/www/html/api/ --local-api --no-color --light-mode --no-cache --loglevel 1 --data-dir ~/p2pool/build/ --mini
fi

if [ $BOOT_STATUS -eq 8 ]
		then
		#Adapted command for starting P2Pool only for private node due to restricted rpc commands
		./p2pool --host $DEVICE_IP --rpc-port $MONERO_PORT --rpc-login $RPCu:$RPCp --wallet $MINING_ADDRESS --start-mining $MINING_THREADS --data-api /var/www/html/api/ --local-api --no-color --light-mode --no-cache --loglevel 1 --data-dir ~/p2pool/build/ --mini
fi

if [ $BOOT_STATUS -eq 9 ]
		then
		#Adapted command for starting P2Pool only for tor public node
		./p2pool --host $DEVICE_IP --rpc-port $MONERO_PORT --wallet $MINING_ADDRESS --start-mining $MINING_THREADS --data-api /var/www/html/api/ --local-api --no-color --light-mode --no-cache --loglevel 1 --data-dir ~/p2pool/build/ --mini
fi



# Key - BOOT_STATUS
# 2 = idle
# 3 || 5 = private node || solo mining node
# 4 = tor private
# 6 = Public RPC pay
# 7 = Public free
# 8 = I2P
# 9 tor public
#A note on how this works:
#BOOT_STATUS is set by the Monerod start script. 
#Each additional feature, P2Pool, blockexplorer etc interacts with Moneros RPC and it is necessary to know what configuration Monerod is in to know what additional options flags are requires for interaction. 
#e.g Is RPCusername and RPCpassword set by monerod? 
#What Monero ports are open and which are RPC-restricted, and tor mode has bound ports to the hiddenservice file prohibiting customisation.
#For this purpose a numerical integer is assigned to each Monerod "mode".
