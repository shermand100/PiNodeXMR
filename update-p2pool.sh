#!/bin/bash

. ./common.sh

showtext "
####################
Start setup-update-p2pool.sh script $(date)
####################
"

#Stop Node to make system resources available.
services-stop
sudo systemctl stop p2pool.service

echo "Monero node stop command sent to make system resources available for update, allowing 30 seconds for safe shutdown"
sleep 30
showtext "Deleting old version"
rm -rf /home/nanode/p2pool/
showtext "Building new P2Pool"
##Install P2Pool
{
	git clone --recursive https://github.com/SChernykh/p2pool
	cd p2pool || exit 1
	git checkout tags/v3.0
	mkdir build && (cd build || exit 1)
	cmake ..
	make -j2
	showtext "Success"
	cd || exit 1
	#Update system reference Explorer version number version number
	chmod 755 /home/nanode/p2pool-new-ver.sh
	#shellcheck disable=SC1091
	. /home/nanode/p2pool-new-ver.sh
	echo "#!/bin/bash
	CURRENT_VERSION_P2POOL=$NEW_VERSION_P2POOL" > /home/nanode/current-ver-p2pool.sh
} 2>&1 | tee -a "$DEBUG_LOG"

services-start "$BOOT_STATUS"
##End debug log
log "Update Script Complete
####################
End setup-update-p2pool.sh script $(date)
####################"
