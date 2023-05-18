#!/bin/bash

#shellcheck source=home/nodo/common.sh
. /home/nodo/common.sh
cd /home/nodo || exit 1

OLD_VERSION_LWS_ADMIN="${1:-$(getvar "versions.lws-admin")}"

RELEASE="$(curl -fs https://raw.githubusercontent.com/MoneroNodo/Nodo/master/release-lws-admin.txt)"
#RELEASE="release-v0.18" # TODO remove when live

if [ -z "$RELEASE" ]; then # Release somehow not set or empty
	showtext "Failed to check for update for LWS Admin"
	exit 0
fi

if [ "$RELEASE" == "$OLD_VERSION_LWS_ADMIN" ]; then
	showtext "No update for LWS Admin"
	exit 0
fi

touch "$DEBUG_LOG"

showtext "
####################
Start setup-update-explorer.sh script $(date)
####################
"


#(1) Define variables and updater functions

rm -rf /home/nodo/onion-monero-blockchain-explorer/
showtext "Building Monero LWS Admin..."

{
	git clone -b main https://github.com/CryptoGrampy/monero-lws-admin.git
	cd monero-lws-admin || exit
	git pull
	npm i
} 2>&1 | tee -a "$DEBUG_LOG"

putvar "versions.lws-admin" "$RELEASE"
#
##End debug log
showtext "
####################
End setup-update-explorer.sh script $(date)
####################"
