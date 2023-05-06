#!/bin/bash

#shellcheck source=home/nodo/common.sh
. /home/nodo/common.sh
#Import Start Flag Values:
#Establish Device IP
DEVICE_IP=$(getip)
#Import Restricted Port Number (external use)
MONERO_PORT=$(getvar "monero_port")
#Import RPC username
RPCu=$(getvar "rpcu")
#Import RPC password
RPCp=$(getvar "rpcp")
IN_PEERS=$(getvar "in_peers")
OUT_PEERS=$(getvar "out_peers")
LIMIT_RATE_UP=$(getvar "limit_rate_up")
LIMIT_RATE_DOWN=$(getvar "limit_rate_down")
DATA_DIR=$(getvar "data_dir")
SYNC_MODE=$(getvar "sync_mode")

putvar "boot_status" "3"
#Start Monerod
/usr/bin/monerod --sync-mode="$SYNC_MODE" --data-dir="$DATA_DIR" --rpc-bind-ip="$DEVICE_IP" --zmq-pub "tcp://$DEVICE_IP:18083" --rpc-bind-port="$MONERO_PORT" --confirm-external-bind --rpc-login="$RPCu:$RPCp" --rpc-ssl disabled --in-peers="$IN_PEERS" --out-peers="$OUT_PEERS" --limit-rate-up="$LIMIT_RATE_UP" --limit-rate-down="$LIMIT_RATE_DOWN" --max-log-file-size=10485760 --log-level=1 --max-log-files=1 --pidfile /run/monerod.pid --enable-dns-blocklist --detach
