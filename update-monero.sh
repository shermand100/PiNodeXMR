#!/bin/bash

#shellcheck source=home/nodo/common.sh
. /home/nodo/common.sh

cd /home/nodo || exit 1

OLD_VERSION="${1:-$(getvar "versions.monero")}"
#Error Log:
touch "$DEBUG_LOG"
echo "
####################
Start update-monero.sh script $(date)
####################
" 2>&1 | tee -a "$DEBUG_LOG"

#Download variable for current monero release version
#FIXME: change url
# wget -q https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/master/release.sh -O /home/nodo/release.sh
#RELEASE="$(curl -s https://raw.githubusercontent.com/monero-ecosystem/MoneroNodo/master/release.txt)"
RELEASE="release-v0.18" # TODO remove when live

if [ "$RELEASE" == "$OLD_VERSION" ]; then
	showtext "No update for Monero"
	exit 0
fi
#ubuntu /dev/null odd requiremnt to set permissions
chmod 666 /dev/null

#Stop Node to make system resources available.
services-stop

showtext "Building Monero..."

{
	# first install monero dependancies
	apt-get update

	apt-get install git build-essential ccache cmake libboost-all-dev miniupnpc libunbound-dev graphviz doxygen libunwind8-dev pkg-config libssl-dev libcurl4-openssl-dev libgtest-dev libreadline-dev libzmq3-dev libsodium-dev libhidapi-dev libhidapi-libusb0 -y -o DPkg::Options::="--force-confnew"

	# go to home folder
	cd || exit 1
	git clone --recursive -b "$RELEASE" https://github.com/monero-project/monero.git

	cd monero/ || exit 1
	git pull
	USE_SINGLE_BUILDDIR=1 make && cp build/release/bin/monero* /usr/bin/ && chmod a+x /usr/bin/monero*
} 2>&1 | tee -a "$DEBUG_LOG"

# {
# wget --no-verbose --show-progress --progress=dot:giga -O arm64 https://downloads.getmonero.org/arm64
# mkdir dl
# tar -xjvf arm64 -C dl
# mv dl/*/monero* /usr/bin/
# chmod a+x /usr/bin/monero*
# } 2>&1 | tee -a "$DEBUG_LOG"

#Update system version number
putvar "versions.monero" "$RELEASE"
#cleanup old version number file

services-start

##End debug log
log "Monero Update Complete
####################
End setup-update-monero.sh script $(date)
####################"
