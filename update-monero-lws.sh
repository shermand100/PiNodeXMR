#!/bin/bash
#(1) Define variables and updater functions
#shellcheck source=home/nanode/common.sh
. /home/nanode/common.sh
NEW_VERSION_LWS="${1:-$(getvar "versions.lws")}"

#Error Log:
touch "$DEBUG_LOG"
showtext "
####################
Start setup-update-monero-lws.sh script $(date)
####################
"

#Stop Monero-lws service (if started)
showtext "Stopping Monero-LWS service (if started)..."
sudo systemctl stop monero-lws.service
##Delete old version
showtext "Delete old version"
rm -rf /root/monero-lws/ 2>&1 | tee -a "$DEBUG_LOG"
showtext "Downloading and Building new Monero-LWS"
#Check dependencies (Should be installed already from Monero install)
sudo apt-get update
sudo apt-get install build-essential cmake libboost-all-dev libssl-dev libzmq3-dev doxygen graphviz -y -o DPkg::Options::="--force-confnew" 2>&1 | tee -a "$DEBUG_LOG"
showtext "Downloading VTNerd Monero-LWS"
{
	git clone --recursive https://github.com/vtnerd/monero-lws.git
	cd monero-lws || exit 1
	git checkout release-v0.2_0.18
	git pull
	mkdir build
	cd build || exit 1
	cmake -DMONERO_SOURCE_DIR=/root/monero -DMONERO_BUILD_DIR=/root/monero/build/release ..
	showtext "Building VTNerd Monero-LW"
	make
} 2>&1 | tee -a "$DEBUG_LOG"
cd || exit 1
#Restarting Monero-LWS servcice
sudo systemctl start monero-lws.service
#Update system reference current LWS version number to New version number
putvar "versions.lws" "$NEW_VERSION_LWS"

##End debug log
showtext "Monero-LWS Updated
####################
End setup-update-monero-lws.sh script $(date)
####################"
