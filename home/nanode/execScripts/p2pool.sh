#!/bin/bash

#Import Start Flag Values:
	#Establish Device IP
	. /home/nanode/variables/deviceIp.sh
	#Import Port Number
	. /home/nanode/variables/monero-port.sh
	#Import Mining Address
	. /home/nanode/variables/mining-address.sh	

#Start P2Pool
cd /home/nanode/p2pool/build
./p2pool --host $DEVICE_IP --wallet $MINING_ADDRESS --no-color --light-mode --no-cache --loglevel 2 --mini