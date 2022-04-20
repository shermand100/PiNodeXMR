#!/bin/bash

#Import Start Flag Values:
	#Establish Device IP
	. /home/pinodexmr/variables/deviceIp.sh
	#Import Port Number
	. /home/pinodexmr/variables/monero-port.sh
	#Import Mining Address
	. /home/pinodexmr/variables/mining-address.sh	

#Start P2Pool
cd /home/pinodexmr/p2pool/build
./p2pool --host $DEVICE_IP --wallet $MINING_ADDRESS --no-color --light-mode