#!/bin/bash

#Import Start Flag Values:
	#Import Ethereum JSON RPC Endpoint
	. /home/pinodexmr/variables/eth-rpc-node.sh
	#Establish Device IP
	. /home/pinodexmr/variables/deviceIp.sh
	#Import Monero RPC Port Number
	. /home/pinodexmr/variables/monero-port.sh

#Start Atomic Swap

~/atomic-swap/bin/swapd --env mainnet --eth-endpoint $ETH_RPC_NODE --monerod-host $DEVICE_IP --monerod-port $MONERO_PORT --log-level debug