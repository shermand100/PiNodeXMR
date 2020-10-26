#!/bin/bash
#Establish IP
DEVICE_IP="$(hostname -I | awk '{print $1}')"
#Import Start Flag Values:
	#Import RPC Port Number
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
	#Import your I2P server/router hostname
	. /home/pinodexmr/i2p-address.sh
	#Import your I2P server/router port
	. /home/pinodexmr/i2p-port.sh
	#Import i2p-tx-proxy port
	. /home/pinodexmr/i2p-tx-proxy-port.sh
	#Import ADD_I2P_PEER (seed) port
	. /home/pinodexmr/add-i2p-peer.sh

#Update power cycle reboot state
	echo "#!/bin/sh
BOOT_STATUS=8" > /home/pinodexmr/bootstatus.sh
#Start Monerod
cd /home/pinodexmr/monero/build/release/bin/

DNS_PUBLIC=tcp ./monerod --block-sync-size=10 --p2p-bind-ip 127.0.0.1 --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT --rpc-login=$RPCu:$RPCp --confirm-external-bind --anonymous-inbound $I2P_ADDRESS,127.0.0.1:$I2P_PORT --tx-proxy i2p,127.0.0.1:$I2P_TX_PROXY_PORT --rpc-ssl disabled --log-level=1 --add-peer $ADD_I2P_PEER --in-peers=$IN_PEERS --out-peers=$OUT_PEERS --limit-rate-up=$LIMIT_RATE_UP --limit-rate-down=$LIMIT_RATE_DOWN --log-file=/var/www/html/monerod.log --max-log-file-size=10485000 --max-log-files=1 --pidfile /home/pinodexmr/monero/build/release/bin/monerod.pid --non-interactive
