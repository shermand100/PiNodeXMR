#!/bin/bash
#Establish IP
DEVICE_IP="$(hostname -I | awk '{print $1}')"
#Import Start Flag Values:
	#Import Port Number
	. /home/pinodexmr/monero-port.sh
	#Import Public (free) Port Number
	. /home/pinodexmr/monero-port-public-free.sh
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

#Update power cycle reboot state
	echo "#!/bin/sh
BOOT_STATUS=7" > /home/pinodexmr/bootstatus.sh
#Start Monerod

cd /home/pinodexmr/monero/build/release/bin/
./monerod --rpc-bind-ip=0.0.0.0 --rpc-bind-port=$MONERO_PORT --rpc-restricted-bind-ip=$DEVICE_IP --rpc-restricted-bind-port=$MONERO_PUBLIC_PORT --confirm-external-bind --rpc-ssl disabled --in-peers=$IN_PEERS --out-peers=$OUT_PEERS --limit-rate-up=$LIMIT_RATE_UP --limit-rate-down=$LIMIT_RATE_DOWN --log-file=/var/www/html/monerod.log --max-log-file-size=10485000  --log-level=1 --max-log-files=1 --pidfile /home/pinodexmr/monero/build/release/bin/monerod.pid --public-node --enable-dns-blocklist --ban-list /home/pinodexmr/block.txt --detach