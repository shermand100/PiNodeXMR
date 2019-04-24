#!/bin/sh
#Connected Peers info
./monero/monerod --rpc-bind-ip=$(hostname -I) print_cn > /var/www/html/print_cn.txt