#!/bin/sh
	#Import RPC username
	. /home/pinodexmr/RPCu.sh
	#Import RPC password
	. /home/pinodexmr/RPCp.sh
#Connected Peers info
./monero/monerod --rpc-bind-ip=$(hostname -I) --rpc-login $RPCu:$RPCp print_cn > /var/www/html/print_cn.txt