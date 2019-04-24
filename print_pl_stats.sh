#!/bin/sh
#Print PL_STATS white vs grey nodes
./monero/monerod --rpc-bind-ip=$(hostname -I) print_pl_stats > /var/www/html/print_pl_stats.txt