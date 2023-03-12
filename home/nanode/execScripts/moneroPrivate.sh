#!/bin/bash

#Import Start Flag Values:
	#Establish Device IP
	. /home/nanode/variables/deviceIp.sh
	#Import Port Number
	. /home/nanode/variables/monero-port.sh
	#Import IN-PEERS (connections) Limit
	. /home/nanode/variables/in-peers.sh
	#Import OUT-PEERS (connections) Limit
	. /home/nanode/variables/out-peers.sh
	#Import Data Limit Up
	. /home/nanode/variables/limit-rate-up.sh
	#Import Data Limit Down
	. /home/nanode/variables/limit-rate-down.sh
	#Import RPC username
	. /home/nanode/variables/RPCu.sh
	#Import RPC password
	. /home/nanode/variables/RPCp.sh

#Update power cycle reboot state
	echo "#!/bin/sh
BOOT_STATUS=3" > /home/nanode/bootstatus.sh
#Start Monerod
cd /home/nanode/monero/build/release/bin/
./monerod --rpc-bind-ip=$DEVICE_IP --zmq-pub tcp://$DEVICE_IP:18083 --rpc-bind-port=$MONERO_PORT --confirm-external-bind --rpc-login=$RPCu:$RPCp --rpc-ssl disabled --in-peers=$IN_PEERS --out-peers=$OUT_PEERS --limit-rate-up=$LIMIT_RATE_UP --limit-rate-down=$LIMIT_RATE_DOWN --max-log-file-size=10485760 --log-level=1 --max-log-files=1 --pidfile /home/nanode/monero/build/release/bin/monerod.pid --enable-dns-blocklist --detach