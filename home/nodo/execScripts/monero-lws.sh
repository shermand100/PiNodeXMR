#!/bin/bash

#shellcheck source=home/nodo/common.sh
. /home/nodo/common.sh

lwsloc=/home/nodo/monero-lws/build/src/

DATA_DIR=$(getvar "data_dir")/light_wallet_server

eval "${lwsloc}monero-lws-daemon --daemon tcp://127.0.0.1:18083 --db-path $DATA_DIR --admin-rest-server https://127.0.0.1:8443/admin --rest-server https://127.0.0.1:8443/basic"
