#!/bin/bash

#Import Start Flag Values:
	#Import Ethereum JSON RPC Endpoint
	. /home/pinodexmr/variables/eth-rpc-node.sh

#Start Atomic Swap
cd /home/pinodexmr/bin
./swapd --env mainnet --eth-endpoint $ETH_RPC_NODE