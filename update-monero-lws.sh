#!/bin/bash
#(1) Define variables and updater functions
#shellcheck source=home/nodo/common.sh
. /home/nodo/common.sh
OLD_VERSION_LWS="${1:-$(getvar "versions.lws")}"

RELEASE="$(curl -fs https://raw.githubusercontent.com/MoneroNodo/Nodo/master/release-monero-lws.txt)"
#RELEASE="release-v0.18" # TODO remove when live

if [ -z "$RELEASE" ]; then # Release somehow not set or empty
	showtext "Failed to check for update for LWS Admin"
	exit 0
fi

if [ "$RELEASE" == "$OLD_VERSION_LWS" ]; then
	showtext "No update for LWS Admin"
	exit 0
fi

touch "$DEBUG_LOG"

showtext "
####################
Start setup-update-monero-lws.sh script $(date)
####################
"

##Delete old version
showtext "Delete old version"
rm -rf /home/nodo/monero-lws 2>&1 | tee -a "$DEBUG_LOG"
showtext "Downloading VTNerd Monero-LWS"
{
	git clone --recursive https://github.com/vtnerd/monero-lws.git
	cd monero-lws || exit 1
	git checkout release-v0.2_0.18
	git pull
	mkdir build
	cd build || exit 1
	cmake -DMONERO_SOURCE_DIR=/home/nodo/monero -DMONERO_BUILD_DIR=/home/nodo/monero/build/release ..
	showtext "Building VTNerd Monero-LW"
	make
} 2>&1 | tee -a "$DEBUG_LOG"
cd || exit 1
#Update system reference current LWS version number to New version number
putvar "versions.lws" "$RELEASE"

##End debug log
showtext "Monero-LWS Updated
####################
End setup-update-monero-lws.sh script $(date)
####################"
