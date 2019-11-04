#!/bin/sh
	#Import RPC username
	. /home/pinodexmr/RPCu.sh
	#Import RPC password
	. /home/pinodexmr/RPCp.sh
#Print all white/grey nodes
./monero/monerod --rpc-bind-ip=$(hostname -I) --rpc-login $RPCu:$RPCp --rpc-ssl disabled print_pl | sed '1d' > /var/www/html/print_pl.txt
