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

{
	#Permission Setting
	chmod 755 /home/nanode/current-ver-exp.sh
	chmod 755 /home/nanode/exp-new-ver.sh
} 2>&1 | tee -a "$DEBUG_LOG"


#Stop Node to make system resources available.
{
services-stop
sudo systemctl stop blockExplorer.service
rm -rf /home/nanode/onion-monero-blockchain-explorer/
showtext "Building Monero Blockchain Explorer
*******************************************************
***This will take a few minutes - Hardware Dependent***
*******************************************************"
git clone -b master https://github.com/moneroexamples/onion-monero-blockchain-explorer.git
cd onion-monero-blockchain-explorer || exit
mkdir build && cd build || exit
cmake ..
make
putvar "versions.exp" "$NEW_VERSION_EXP"
services-start
} 2>&1 | tee -a "$DEBUG_LOG"
#
##End debug log
echo "
####################
" 2>&1 | tee -a "$DEBUG_LOG"
log "End setup-update-explorer.sh script $(date)"
echo "
####################
" 2>&1 | tee -a "$DEBUG_LOG"
