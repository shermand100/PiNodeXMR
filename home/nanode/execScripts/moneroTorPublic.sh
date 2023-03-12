#!/bin/bash

#Extra display hidden service address incase of error on tor install
sudo cat /var/lib/tor/hidden_service/hostname > /var/www/html/onion-address.txt
#Onion Public Address
NAME_FILE="/var/lib/tor/hidden_service/hostname"
ONION_ADDR="$(sudo cat $NAME_FILE)"
ANONYMOUS_INBOUND="${ONION_ADDR},127.0.0.1:18083"
#Import Start Flag Values:
	#Establish Device IP
	. /home/nanode/variables/deviceIp.sh
	#Import RPC Port Number
	. /home/nanode/variables/monero-port.sh
	#Import "IN-PEERS" (connections) Limit
	. /home/nanode/variables/in-peers.sh
	#Import "OUT-PEERS" (connections) Limit
	. /home/nanode/variables/out-peers.sh
	#Import Data Limit Up
	. /home/nanode/variables/limit-rate-up.sh
	#Import Data Limit Down
	. /home/nanode/variables/limit-rate-down.sh
	#Import RPC username
	. /home/nanode/variables/RPCu.sh
	#Import RPC password
	. /home/nanode/variables/RPCp.sh

#Output the currently running state
	echo "#!/bin/sh
BOOT_STATUS=9" > /home/nanode/bootstatus.sh
#Start Monerod
DNS_PUBLIC=tcp TORSOCKS_ALLOW_INBOUND=1 ./monero/build/release/bin/monerod --p2p-bind-ip 0.0.0.0 --zmq-pub tcp://$DEVICE_IP:18083 --p2p-bind-port=18080 --no-igd --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=18081 --tx-proxy tor,127.0.0.1:9050,16 --anonymous-inbound $ANONYMOUS_INBOUND --confirm-external-bind --public-node --restricted-rpc --rpc-ssl disabled --in-peers=$IN_PEERS --out-peers=$OUT_PEERS --limit-rate-up=$LIMIT_RATE_UP --limit-rate-down=$LIMIT_RATE_DOWN --max-log-file-size=10485760 --log-level=1 --max-log-files=1 --enable-dns-blocklist --non-interactive