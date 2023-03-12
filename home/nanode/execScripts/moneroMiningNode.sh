#!/bin/bash

#Import Start Flag Values:
	#Establish Device IP
	. /home/nanode/variables/deviceIp.sh
	#Import Port Number
	. /home/nanode/variables/monero-port.sh
	#Import "OUT-PEERS" (connections) Limit
	. /home/nanode/variables/out-peers.sh
	#Import "IN_PEERS" (connections) Limit
	. /home/nanode/variables/in-peers.sh
	#Import Data Limit Up
	. /home/nanode/variables/limit-rate-up.sh
	#Import Data Limit Down
	. /home/nanode/variables/limit-rate-down.sh
	#Import Mining Address
	. /home/nanode/variables/mining-address.sh
	#Import Mining Intensity
	. /home/nanode/variables/mining-intensity.sh
	#Import RPC username
	. /home/nanode/variables/RPCu.sh
	#Import RPC password
	. /home/nanode/variables/RPCp.sh
 
#Output the currently running node mode
	echo "#!/bin/sh
BOOT_STATUS=5" > /home/nanode/bootstatus.sh
#Allow time for previous service stop
sleep "10"
#Start Monerod
cd /home/nanode/monero/build/release/bin/
./monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT --zmq-pub tcp://$DEVICE_IP:18083 --confirm-external-bind --rpc-login=$RPCu:$RPCp --rpc-ssl disabled --in-peers=$IN_PEERS --out-peers=$OUT_PEERS --limit-rate-up=$LIMIT_RATE_UP --limit-rate-down=$LIMIT_RATE_DOWN --max-log-file-size=10485760 --log-level=1 --max-log-files=1 --pidfile /home/nanode/monero/build/release/bin/monerod.pid --start-mining=$MINING_ADDRESS --bg-mining-miner-target=$MINING_INTENSITY --enable-dns-blocklist --detach