#!/bin/bash
#Import Start Flag Values:
	#Create device IP
	MY_IP="$(hostname -I)"
	#Import Port Number
	. /home/pinodexmr/monero-port.sh
	#Import RPC username
	. /home/pinodexmr/RPCu.sh
	#Import RPC password
	. /home/pinodexmr/RPCp.sh

#Start onion-block-explorer
cd /home/pinodexmr/onion-monero-blockchain-explorer/build/
./xmrblocks --port 8081 --enable-pusher --enable-emission-monitor --deamon-url=HTTP://${MY_IP// }:$MONERO_PORT --daemon-login $RPCu:$RPCp --mempool-info-timeout 60000 --mempool-refresh-time 30