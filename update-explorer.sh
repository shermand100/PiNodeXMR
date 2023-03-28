#!/bin/bash

#shellcheck source=home/nanode/common.sh
. /home/nanode/common.sh
NEW_VERSION_EXP="${1:-$(getvar "versions.pi")}"

touch "$DEBUG_LOG"

echo "
####################
Start setup-update-explorer.sh script $(date)
####################
" 2>&1 | tee -a "$DEBUG_LOG"


#(1) Define variables and updater functions

#Stop Node to make system resources available.
services-stop
systemctl stop blockExplorer.service
rm -rf /home/nanode/onion-monero-blockchain-explorer/
showtext "Building Monero Blockchain Explorer
*******************************************************
***This will take a few minutes - Hardware Dependent***
*******************************************************"

{
	git clone -b master https://github.com/moneroexamples/onion-monero-blockchain-explorer.git
	cd onion-monero-blockchain-explorer || exit
	mkdir build
	cd build || exit
	cmake ..
	make && cp xmrblocks /usr/bin/ && chmod a+x /usr/bin/xmrblocks
} 2>&1 | tee -a "$DEBUG_LOG"

putvar "versions.exp" "$NEW_VERSION_EXP"
services-start
#
##End debug log
echo "
####################
" 2>&1 | tee -a "$DEBUG_LOG"
log "End setup-update-explorer.sh script $(date)"
echo "
####################
" 2>&1 | tee -a "$DEBUG_LOG"
