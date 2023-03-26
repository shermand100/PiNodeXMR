#!/bin/bash

#shellcheck source=home/nanode/common.sh
. /home/nanode/common.sh
#Import Start Flag Values:
DEVICE_IP=$(getip)
IN_PEERS=$(getvar "in_peers")
OUT_PEERS=$(getvar "out_peers")
LIMIT_RATE_UP=$(getvar "limit_rate_up")
LIMIT_RATE_DOWN=$(getvar "limit_rate_down")
MONERO_PUBLIC_PORT=$(getvar "monero_public_port")
DATA_DIR=$(getvar "data_dir")
SYNC_MODE=$(getvar "sync_mode")

putvar "boot_status" "7"
/home/nanode/monero/build/release/bin/monerod --sync-mode="$SYNC_MODE" --data-dir="$DATA_DIR" --rpc-bind-ip=0.0.0.0 --rpc-bind-port="$MONERO_PUBLIC_PORT" --zmq-pub tcp://"$DEVICE_IP":18083 --rpc-restricted-bind-ip="$DEVICE_IP" --rpc-restricted-bind-port="$MONERO_PORT" --confirm-external-bind --rpc-ssl disabled --in-peers="$IN_PEERS" --out-peers="$OUT_PEERS" --limit-rate-up="$LIMIT_RATE_UP" --limit-rate-down="$LIMIT_RATE_DOWN" --max-log-file-size=10485760 --log-level=1 --max-log-files=1 --pidfile /home/nanode/monero/build/release/bin/monerod.pid --public-node --enable-dns-blocklist --detach
