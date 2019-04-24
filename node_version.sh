#!/bin/sh
#Node Version Print
./monero/monerod --rpc-bind-ip=$(hostname -I) version > /var/www/html/node_version.txt