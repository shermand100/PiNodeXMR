#!/bin/bash

#shellcheck source=home/nodo/common.sh
. /home/nodo/common.sh

exploc=/home/nodo/onion-monero-blockchain-explorer/build/
DATA_DIR=$(getvar "data_dir")

eval "$exploc/xmrblocks -b $DATA_DIR" >/dev/null
