#!/bin/bash
#Establish IP
DEVICE_IP="$(hostname -I)"
#Import Start Flag Values:
	#Import Port Number
	. /home/pi/monero-port.sh
	#Import Block Sync Size
	. /home/pi/monero-block-sync-size.sh
	#Set Sync Mode (Safe,Fast,Fastest)
	. /home/pi/db-sync-mode.sh
	#Import "IN-PEERS" (connections) Limit
	. /home/pi/in-peers.sh
	#Import "OUT-PEERS" (connections) Limit
	. /home/pi/out-peers.sh
	#Import Data Limit Up
	. /home/pi/limit-rate-up.sh
	#Import Data Limit Down
	. /home/pi/limit-rate-down.sh
#Start Monerod
DNS_PUBLIC=tcp TORSOCKS_ALLOW_INBOUND=1 torsocks ./monero/monerod --p2p-bind-ip 127.0.0.1 --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT --confirm-external-bind --block-sync-size=$MONERO_BLOCK_SYNC_SIZE --db-sync-mode=$DB_SYNC_MODE --in-peers=$IN_PEERS --out-peers=$OUT_PEERS --limit-rate-up=$LIMIT_RATE_UP --limit-rate-down=$LIMIT_RATE_DOWN