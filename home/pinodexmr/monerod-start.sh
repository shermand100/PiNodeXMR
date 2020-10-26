#!/bin/bash
#Establish IP
DEVICE_IP="$(hostname -I | awk '{print $1}')"
#Import Start Flag Values:
	#Import Port Number
	. /home/pinodexmr/monero-port.sh
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
	#Import Block Size
	. /home/pinodexmr/block-sync-size.sh

#Update power cycle reboot state
	echo "#!/bin/sh
BOOT_STATUS=3" > /home/pinodexmr/bootstatus.sh
#Start Monerod
cd /home/pinodexmr/monero/build/release/bin/
./monerod --block-sync-size=$BLOCK_SYNC_SIZE --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT --confirm-external-bind --rpc-login=$RPCu:$RPCp --rpc-ssl disabled --in-peers=$IN_PEERS --out-peers=$OUT_PEERS --limit-rate-up=$LIMIT_RATE_UP --limit-rate-down=$LIMIT_RATE_DOWN --log-file=/var/www/html/monerod.log --max-log-file-size=10485000  --log-level=1 --max-log-files=1 --pidfile /home/pinodexmr/monero/build/release/bin/monerod.pid --non-interactive
