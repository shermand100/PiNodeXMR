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
	#Import RPC username
	. /home/pinodexmr/variables/RPCu.sh
	#Import RPC password
	. /home/pinodexmr/variables/RPCp.sh
	#Load boot status - what condition was node last run
	. /home/pinodexmr/bootstatus.sh

#Start P2Pool

if [ $BOOT_STATUS -eq 3 ]
		then
		#Adapted command for starting onion-block-explorer only for public node due to restricted rpc commands
		cd /home/pinodexmr/p2pool/build
		./p2pool --host $DEVICE_IP --rpc-port $MONERO_PORT --rpc-login $RPCu:$RPCp --wallet $MINING_ADDRESS --no-color --light-mode --no-cache --loglevel 2 --mini

else if [ $BOOT_STATUS -eq 6 ]
		then
		#Adapted command for starting onion-block-explorer only for public node due to restricted rpc commands
		cd /home/pinodexmr/p2pool/build
		./p2pool --host $DEVICE_IP --rpc-port $MONERO_PORT --wallet $MINING_ADDRESS --no-color --light-mode --no-cache --loglevel 2 --mini
else if [ $BOOT_STATUS -eq 7 ]
		then
		#Adapted command for starting onion-block-explorer only for public node due to restricted rpc commands
		cd /home/pinodexmr/p2pool/build
		./p2pool --host $DEVICE_IP --rpc-port $MONERO_PUBLIC_PORT --wallet $MINING_ADDRESS --no-color --light-mode --no-cache --loglevel 2 --mini
else 
		#Start with $MONERO_PUBLIC_PORT set. This port isn't included with tor hidden service rules to prevent inadvertant exposure of unrestricted monero port via tor/I2P
		cd /home/pinodexmr/p2pool/build
		./p2pool --host $DEVICE_IP --rpc-port $MONERO_PUBLIC_PORT --rpc-login $RPCu:$RPCp --wallet $MINING_ADDRESS --no-color --light-mode --no-cache --loglevel 2 --mini
fi

# Key - BOOT_STATUS
# 2 = idle
# 3 || 5 = private node || mining node
# 4 = tor
# 6 = Public RPC pay
# 7 = Public free
# 8 = I2P
# 9 tor public
#Notes on how this works:
#1)Each status command is set as a variable and then on completion this variable is then returned into the file specified...
#The variable step is needed to prevent the previous stats file being overwritten to empty at the start of the command before the new stats are generated thus causing blank stats sections in the UI.
#2)I spent far too much time trying to incorporate 'target height' into the main status section, however this would often sit below the current height once sync'd...
#So next I used 'Current_Sync_Progress:((.result.height/.result.target_height)*100)|floor' to readout a percentage of sync'd rounded down to a whole number. This meant that when the current height was above target sync status read as 100%...
#However in tor mode target height sometimes outputs to 0 and the math fails killing the whole command. In the end the boolean 'Busy_Syncing:.result.busy_syncing' is used but not as pretty.