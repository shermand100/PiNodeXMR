#!/bin/bash

#shellcheck source=common.sh
. /home/nanode/common.sh
#Import Start Flag Values:
DEVICE_IP=$(getip)
MONERO_PORT=$(getvar "monero_port")
MONERO_RPCPAY_PORT=$(getvar "monero_rpcpay_port")
PAYMENT_ADDRESS=$(getvar "payment_address")
CREDITS=$(getvar "credits")
IN_PEERS=$(getvar "in_peers")
OUT_PEERS=$(getvar "out_peers")
LIMIT_RATE_UP=$(getvar "limit_rate_up")
LIMIT_RATE_DOWN=$(getvar "limit_rate_down")

putvar "boot_status" "6"
#Start Monerod
cd /home/nanode/monero/build/release/bin/ || exit 1
./monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT --zmq-pub tcp://$DEVICE_IP:18083 --rpc-restricted-bind-port=$MONERO_RPCPAY_PORT --confirm-external-bind --rpc-payment-allow-free-loopback --rpc-ssl disabled --in-peers=$IN_PEERS --out-peers=$OUT_PEERS --limit-rate-up=$LIMIT_RATE_UP --limit-rate-down=$LIMIT_RATE_DOWN --max-log-file-size=10485760 --log-level=1 --max-log-files=1 --pidfile /home/nanode/monero/build/release/bin/monerod.pid --rpc-payment-address=$PAYMENT_ADDRESS --rpc-payment-credits=$CREDITS --rpc-payment-difficulty=$DIFFICULTY --public-node --enable-dns-blocklist --detach
