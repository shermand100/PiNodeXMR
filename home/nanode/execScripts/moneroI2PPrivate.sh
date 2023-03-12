#!/bin/bash

#Import Start Flag Values:
	#Establish Device IP
	. /home/nanode/variables/deviceIp.sh
	#Import RPC Port Number
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
	#Import your I2P server/router hostname
	. /home/nanode/variables/i2p-address.sh
	#Import your I2P server/router port
	. /home/nanode/variables/i2p-port.sh
	#Import i2p-tx-proxy port
	. /home/nanode/variables/i2p-tx-proxy-port.sh

#Update power cycle reboot state
	echo "#!/bin/sh
BOOT_STATUS=8" > /home/nanode/bootstatus.sh
#Start Monerod
cd /home/nanode/monero/build/release/bin/

DNS_PUBLIC=tcp ./monerod --p2p-bind-ip 127.0.0.1 --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT --rpc-login=$RPCu:$RPCp --confirm-external-bind --anonymous-inbound $I2P_ADDRESS,127.0.0.1:$I2P_PORT --tx-proxy i2p,127.0.0.1:$I2P_TX_PROXY_PORT --rpc-ssl disabled --in-peers=$IN_PEERS --out-peers=$OUT_PEERS --limit-rate-up=$LIMIT_RATE_UP --limit-rate-down=$LIMIT_RATE_DOWN --max-log-file-size=10485760 --log-level=1 --max-log-files=1 --pidfile /home/nanode/monero/build/release/bin/monerod.pid --enable-dns-blocklist --non-interactive