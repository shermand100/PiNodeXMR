#!/bin/bash

#Import Start Flag Values:
	#Establish Device IP
	. /home/pinodexmr/deviceIp.sh
	#Import Port Number
	. /home/pinodexmr/monero-port.sh
	#Import Mining Address
	. /home/pinodexmr/mining-address.sh	

#Start P2Pool
cd /home/pinodexmr/p2pool/build
./p2pool --host $DEVICE_IP --wallet $MINING_ADDRESS