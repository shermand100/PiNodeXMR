#!/bin/bash

#shellcheck source=home/nanode/common.sh
. /home/nanode/common.sh
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
I2P_ADDRESS=$(getvar "i2p_address")
I2P_PORT=$(getvar "i2p_port")
I2P_TX_PROXY_PORT=$(getvar "i2p_tx_proxy_port")
DATA_DIR=$(getvar "data_dir")
SYNC_MODE=$(getvar "sync_mode")

#Update power cycle reboot state
putvar "boot_status" "8"
#Start Monerod
DNS_PUBLIC=tcp /usr/bin/monerod --sync-mode="$SYNC_MODE" --data-dir="$DATA_DIR" --p2p-bind-ip 127.0.0.1 --rpc-bind-ip="$DEVICE_IP" --rpc-bind-port="$MONERO_PORT" --rpc-login="$RPCu:$RPCp" --confirm-external-bind --anonymous-inbound "$I2P_ADDRESS,127.0.0.1:$I2P_PORT" --tx-proxy "i2p,127.0.0.1:$I2P_TX_PROXY_PORT" --rpc-ssl disabled --in-peers="$IN_PEERS" --out-peers="$OUT_PEERS" --limit-rate-up="$LIMIT_RATE_UP" --limit-rate-down="$LIMIT_RATE_DOWN" --max-log-file-size=10485760 --log-level=1 --max-log-files=1 --pidfile /run/monerod.pid --enable-dns-blocklist --non-interactive
