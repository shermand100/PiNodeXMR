#!/bin/bash

#Import Start Flag Values:
	#Establish Device IP
	. /home/pinodexmr/variables/deviceIp.sh
	#Import Port Number
	. /home/pinodexmr/variables/monero-port.sh
	#Import Public (free) Port Number
	. /home/pinodexmr/variables/monero-port-public-free.sh
	#Import IN-PEERS (connections) Limit
	. /home/pinodexmr/variables/in-peers.sh
	#Import OUT-PEERS (connections) Limit
	. /home/pinodexmr/variables/out-peers.sh
	#Import Data Limit Up
	. /home/pinodexmr/variables/limit-rate-up.sh
	#Import Data Limit Down
	. /home/pinodexmr/variables/limit-rate-down.sh
	#Import RPC username
	. /home/pinodexmr/variables/RPCu.sh
	#Import RPC password
	. /home/pinodexmr/variables/RPCp.sh

#Update power cycle reboot state
	echo "#!/bin/sh
BOOT_STATUS=7" > /home/pinodexmr/bootstatus.sh
#Start Monerod

cd /home/pinodexmr/monero/build/release/bin/
./monerod --rpc-bind-ip=0.0.0.0 --rpc-bind-port=$MONERO_PUBLIC_PORT --zmq-pub tcp://$DEVICE_IP:18083 --rpc-restricted-bind-ip=$DEVICE_IP --rpc-restricted-bind-port=$MONERO_PORT --confirm-external-bind --ban-list /home/pinodexmr/ban_list_InUse.txt --rpc-ssl disabled --in-peers=$IN_PEERS --out-peers=$OUT_PEERS --limit-rate-up=$LIMIT_RATE_UP --limit-rate-down=$LIMIT_RATE_DOWN --max-log-file-size=10485760 --log-level=1 --max-log-files=1 --pidfile /home/pinodexmr/monero/build/release/bin/monerod.pid --public-node --enable-dns-blocklist --detach