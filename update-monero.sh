#!/bin/bash

. ./common.sh

NEW_VERSION="${1:-$(getvar "versions.monero")}"
#Error Log:
touch "$DEBUG_LOG"
echo "
####################
Start setup-update-monero.sh script $(date)
####################
" 2>&1 | tee -a "$DEBUG_LOG"

#Download variable for current monero release version
#FIXME: change url
# wget -q https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/master/release.sh -O /home/nanode/release.sh
RELEASE="$(curl -s https://raw.githubusercontent.com/monero-ecosystem/MoneroNanode/master/release.txt)"

#Permission Setting
# chmod 755 /home/nanode/release.sh
#Load boot status - condition the node was last run
# . /home/nanode/bootstatus.sh
BOOT_STATUS="$(getvar boot_status)"
#Load Variables
#shellcheck source=home/nanode/release.sh
# . /home/nanode/release.sh


		#ubuntu /dev/null odd requiremnt to set permissions
		sudo chmod 666 /dev/null

		#Stop Node to make system resources available.
		sudo systemctl stop blockExplorer.service
		sudo systemctl stop moneroPrivate.service
		sudo systemctl stop moneroTorPrivate.service
		sudo systemctl stop moneroTorPublic.service
		sudo systemctl stop moneroPublicFree.service
		sudo systemctl stop moneroI2PPrivate.service
		sudo systemctl stop moneroCustomNode.service
		sudo systemctl stop moneroPublicRPCPay.service
		echo "Monero node stop command sent, allowing 30 seconds for safe shutdown"
		echo "Deleting Old Version"
		rm -rf /home/nanode/monero/

# ********************************************
# ******START OF MONERO SOURCE BUILD******
# ********************************************
log "manual build of gtest for Monero"
{
	sudo apt-get install libgtest-dev -y
	cd /usr/src/gtest || exit 1
	sudo cmake .
	sudo make
	sudo mv lib/libg* /usr/lib/
	cd || exit 1
	log "Check dependencies installed for --- Monero"
	sudo apt-get update
	sudo apt-get install build-essential cmake pkg-config libssl-dev libzmq3-dev libunbound-dev libsodium-dev libunwind8-dev liblzma-dev libreadline6-dev libldns-dev libexpat1-dev libpgm-dev qttools5-dev-tools libhidapi-dev libusb-1.0-0-dev libprotobuf-dev protobuf-compiler libudev-dev libboost-chrono-dev libboost-date-time-dev libboost-filesystem-dev libboost-locale-dev libboost-program-options-dev libboost-regex-dev libboost-all-dev libboost-serialization-dev libboost-system-dev libboost-thread-dev ccache doxygen graphviz -y
} 2>&1 | tee -a "$DEBUG_LOG"


showtext "Downloading Monero"

git clone --recursive https://github.com/monero-project/monero
showtext "Building Monero
****************************************************
****************************************************
***This will take a while - Hardware Dependent***
****************************************************
****************************************************"
cd monero && git submodule init && git submodule update
git checkout "$RELEASE"
git submodule sync && git submodule update
USE_SINGLE_BUILDDIR=1 make 2>&1 | tee -a "$DEBUG_LOG"
cd || exit 1

# ********************************************
# ********END OF MONERO SOURCE BUILD **********
# ********************************************

#Make dir .bitmonero to hold lmdb. Needs to be added before drive mounted to give mount point. Waiting for monerod to start fails mount.
mkdir .bitmonero 2>&1 | tee -a "$DEBUG_LOG"
#Clean-up used downloaded files
rm -R ~/temp

		#Update system version number
		putvar "current_version" "$NEW_VERSION"
		#cleanup old version number file

#Define Restart Monero Node
		# Key - BOOT_STATUS
		# 2 = idle
		# 3 = private node
		# 4 = tor
		# 5 = Public RPC pay
		# 6 = Public free
		# 7 = I2P
		# 8 = tor public
services-start

##End debug log
log "Update Complete
####################
End setup-update-monero.sh script $(date)
####################"


./setup.sh
