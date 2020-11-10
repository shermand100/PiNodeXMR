#!/bin/bash
#Establish IP
DEVICE_IP="$(hostname -I)"
#Import Start Flag Values:
	#Import stats Port Number
	. /home/pinodexmr/monero-stats-port.sh
	#Import restricted Port Number
	. /home/pinodexmr/monero-port.sh
	#Import Block Sync Size
	. /home/pinodexmr/monero-block-sync-size.sh
	#Set Sync Mode (Safe,Fast,Fastest)
	. /home/pinodexmr/db-sync-mode.sh
	#Import IN-PEERS (connections) Limit
	. /home/pinodexmr/in-peers.sh
	#Import OUT-PEERS (connections) Limit
	. /home/pinodexmr/out-peers.sh
	#Import Data Limit Up
	. /home/pinodexmr/limit-rate-up.sh
	#Import Data Limit Down
	. /home/pinodexmr/limit-rate-down.sh
	#Import RPC username
	. /home/pinodexmr/RPCu.sh
	#Import RPC password
	. /home/pinodexmr/RPCp.sh
	#Import Credits
	. /home/pinodexmr/credits.sh
	#Import Difficulty
	. /home/pinodexmr/difficulty.sh
	#RPC payment address
	. /home/pinodexmr/payment-address.sh
#Removed commands
	#  --block-sync-size=$MONERO_BLOCK_SYNC_SIZE --db-sync-mode=$DB_SYNC_MODE
#Output the currently running node mode & update power cycle reboot state
	echo "Clearnet Node - Public" > /var/www/html/iamrunning_version.txt
	echo "#!/bin/sh
BOOT_STATUS=6" > /home/pinodexmr/bootstatus.sh
#Start Monerod
cd /home/pinodexmr/monero-active/
./monerod --ban-list /home/pinodexmr/block.txt --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_STATS_PORT --rpc-restricted-bind-port=$MONERO_PORT --confirm-external-bind --rpc-payment-allow-free-loopback --rpc-ssl disabled --in-peers=$IN_PEERS --out-peers=$OUT_PEERS --limit-rate-up=$LIMIT_RATE_UP --limit-rate-down=$LIMIT_RATE_DOWN --log-file=/var/www/html/monerod.log --max-log-file-size=10485000  --log-level=1 --max-log-files=1 --pidfile /home/pinodexmr/monero-active/monerod.pid --rpc-payment-address=$PAYMENT_ADDRESS --rpc-payment-credits=$CREDITS --rpc-payment-difficulty=$DIFFICULTY --detach
