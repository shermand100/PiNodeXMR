#!/bin/sh
	#Import RPC username
	. /home/pinodexmr/RPCu.sh
	#Import RPC password
	. /home/pinodexmr/RPCp.sh
#Print all white/grey nodes
./monero/monerod --rpc-bind-ip=$(hostname -I) --rpc-login $RPCu:$RPCp print_pl > /var/www/html/print_pl.txt
