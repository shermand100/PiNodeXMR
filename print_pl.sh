#!/bin/sh
#Print all white/grey nodes
./monero/monerod --rpc-bind-ip=$(hostname -I) print_pl > /var/www/html/print_pl.txt
