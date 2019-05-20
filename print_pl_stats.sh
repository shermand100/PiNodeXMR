#!/bin/sh
	#Import RPC username
	. /home/pinodexmr/RPCu.sh
	#Import RPC password
	. /home/pinodexmr/RPCp.sh
#Print PL_STATS white vs grey nodes
./monero/monerod --rpc-bind-ip=$(hostname -I) --rpc-login=$RPCu:$RPCp print_pl_stats > /var/www/html/print_pl_stats.txt