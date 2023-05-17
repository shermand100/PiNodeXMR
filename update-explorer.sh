#!/bin/bash

#shellcheck source=home/nodo/common.sh
. /home/nodo/common.sh
cd /home/nodo || exit 1

OLD_VERSION_EXP="${1:-$(getvar "versions.exp")}"

#RELEASE="$(curl -s https://raw.githubusercontent.com/monero-ecosystem/MoneroNodo/master/release.txt)"
RELEASE="release-v0.18" # TODO remove when live

if [ "$RELEASE" == "$OLD_VERSION_EXP" ]; then
	showtext "No update for Monero"
	exit 0
fi

touch "$DEBUG_LOG"

echo "
####################
Start setup-update-explorer.sh script $(date)
####################
" 2>&1 | tee -a "$DEBUG_LOG"


#(1) Define variables and updater functions

rm -rf /home/nodo/onion-monero-blockchain-explorer/
showtext "Building Monero Blockchain Explorer..."

{
	git clone -b master https://github.com/moneroexamples/onion-monero-blockchain-explorer.git
	cd onion-monero-blockchain-explorer || exit
	git pull
	mkdir build
	cd build || exit
	cmake ..
	make && cp xmrblocks /usr/bin/ && chmod a+x /usr/bin/xmrblocks
} 2>&1 | tee -a "$DEBUG_LOG"

putvar "versions.exp" "$RELEASE"
#
##End debug log
showtext "
####################
End setup-update-explorer.sh script $(date)
####################"
