#!/bin/bash
#Establish IP
DEVICE_IP="$(hostname -I)"
#Import Start Flag Values:
	#Import Port Number
	. /home/pinodexmr/monero-port.sh
	#Import Block Sync Size
	. /home/pinodexmr/monero-block-sync-size.sh
	#Set Sync Mode (Safe,Fast,Fastest)
	. /home/pinodexmr/db-sync-mode.sh
	#Import "IN-PEERS" (connections) Limit
	. /home/pinodexmr/in-peers.sh
	#Import "OUT-PEERS" (connections) Limit
	. /home/pinodexmr/out-peers.sh
	#Import Data Limit Up
	. /home/pinodexmr/limit-rate-up.sh
	#Import Data Limit Down
	. /home/pinodexmr/limit-rate-down.sh
	#Import Mining Address
	. /home/pinodexmr/mining-address.sh
#Start Monerod
./monero/monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT --confirm-external-bind --block-sync-size=$MONERO_BLOCK_SYNC_SIZE --db-sync-mode=$DB_SYNC_MODE --in-peers=$IN_PEERS --out-peers=$OUT_PEERS --limit-rate-up=$LIMIT_RATE_UP --limit-rate-down=$LIMIT_RATE_DOWN --start-mining=$MINING_ADDRESS --log-file=/var/www/html/monerod.log --max-log-file-size=10485000  --log-level=0 --max-log-files=1 --detach