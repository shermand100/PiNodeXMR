#!/bin/bash
#Establish IP
DEVICE_IP="$(hostname -I | awk '{print $1}')"
#Onion Public Address
NAME_FILE="/var/lib/tor/hidden_service/hostname"
ONION_ADDR="$(sudo cat $NAME_FILE)"
ANONYMOUS_INBOUND="${ONION_ADDR}:18081,${DEVICE_IP}:18080"
#Import Start Flag Values:
	#Import Port Number
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

#Output the currently running state
	echo "#!/bin/sh
BOOT_STATUS=4" > /home/pinodexmr/bootstatus.sh
#Start Monerod
DNS_PUBLIC=tcp TORSOCKS_ALLOW_INBOUND=1 ./monero/build/release/bin/monerod --p2p-bind-ip 127.0.0.1 --no-igd --rpc-bind-ip=127.0.0.1 --rpc-bind-port=18081 --tx-proxy tor,127.0.0.1:9050 --anonymous-inbound $ANONYMOUS_INBOUND --confirm-external-bind --rpc-login=$RPCu:$RPCp --rpc-ssl disabled --in-peers=$IN_PEERS --out-peers=$OUT_PEERS --limit-rate-up=$LIMIT_RATE_UP --limit-rate-down=$LIMIT_RATE_DOWN --log-file=/var/www/html/monerod.log --max-log-file-size=10485000 --log-level=1 --max-log-files=1 --non-interactive --add-peer nitbdip72kdg5z6g.onion:28083 --add-peer m3bh2imdcpdlzpt6.onion:18083 --add-peer moneromoos37mmoz37i5zu6fatfcsfy2okitw75tyhjjgbnvsyohp4ad.onion:28083 --add-peer moneroxmrxw44lku6qniyarpwgznpcwml4drq7vb24ppatlcg4kmxpqd.onion:18080 --add-peer rbqkzes4auwdrkiddi2fukjmmik43kl2yp57sc3zazaleocn4jmyj3ad.onion:18083
