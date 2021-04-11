#!/bin/bash
#Establish IP
DEVICE_IP="$(hostname -I | awk '{print $1}')"
#Extra display hidden service address incase of error on tor install
sudo cat /var/lib/tor/hidden_service/hostname > /var/www/html/onion-address.txt
#Onion Public Address
NAME_FILE="/var/lib/tor/hidden_service/hostname"
ONION_ADDR="$(sudo cat $NAME_FILE)"
ANONYMOUS_INBOUND="${ONION_ADDR},127.0.0.1:18081"
#Import Start Flag Values:
	#Import RPC Port Number
	. /home/pinodexmr/monero-port.sh
	#Import "IN-PEERS" (connections) Limit
	. /home/pinodexmr/in-peers.sh
	#Import "OUT-PEERS" (connections) Limit
	. /home/pinodexmr/out-peers.sh
	#Import Data Limit Up
	. /home/pinodexmr/limit-rate-up.sh
	#Import Data Limit Down
	. /home/pinodexmr/limit-rate-down.sh
	#Import RPC username
	. /home/pinodexmr/RPCu.sh
	#Import RPC password
	. /home/pinodexmr/RPCp.sh
	#Import ADD_TOR_PEER (seed) port
	. /home/pinodexmr/add-tor-peer.sh	

#Output the currently running state
	echo "#!/bin/sh
BOOT_STATUS=4" > /home/pinodexmr/bootstatus.sh
#Start Monerod
DNS_PUBLIC=tcp TORSOCKS_ALLOW_INBOUND=1 ./monero/build/release/bin/monerod --p2p-bind-ip 127.0.0.1 --no-igd --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=18081 --tx-proxy tor,127.0.0.1:9050 --anonymous-inbound $ANONYMOUS_INBOUND --confirm-external-bind --rpc-login=$RPCu:$RPCp --rpc-ssl disabled --in-peers=$IN_PEERS --out-peers=$OUT_PEERS --limit-rate-up=$LIMIT_RATE_UP --limit-rate-down=$LIMIT_RATE_DOWN --max-log-file-size=10485760 --log-level=1 --max-log-files=1 --enable-dns-blocklist --ban-list /home/pinodexmr/block.txt --non-interactive --add-peer $ADD_TOR_PEER