#!/bin/bash

. ./common.sh

showtext "
####################
Start setup-update-p2pool.sh script $(date)
####################
"

#Stop Node to make system resources available.
sudo systemctl stop blockExplorer.service \
	moneroPrivate.service \
	moneroMiningNode.service \
	moneroTorPrivate.service \
	moneroTorPublic.service \
	moneroPublicFree.service \
	moneroI2PPrivate.service \
	moneroCustomNode.service \
	moneroPublicRPCPay.service \
	p2pool.service

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

#Define Restart Monero Node
# Key - BOOT_STATUS
# 2 = idle
# 3 || 5 = private node || mining node
# 4 = tor
# 6 = Public RPC pay
# 7 = Public free
# 8 = I2P
# 9 tor public
if [ "$BOOT_STATUS" -eq 2 ]
then
	whiptail --title "Monero Update Complete" --msgbox "Update complete, Node ready for start. See web-ui at $(hostname -I) to select mode." 16 60
else
	case $BOOT_STATUS in
		3)
			sudo systemctl start moneroPrivate.service
			;;
		4)
			sudo systemctl start moneroTorPrivate.service
			;;
		# 5) TODO apparently not needed
			# 	sudo systemctl start moneroMiningNode.service
			# 	;;
		6)
			sudo systemctl start moneroPublicRPCPay.service
			;;
		7)
			sudo systemctl start moneroPublicFree.service
			;;
		8)
			sudo systemctl start moneroI2PPrivate.service
			;;
		9)
			sudo systemctl start moneroTorPublic.service
			;;
		*)
			log "Very strange"
			;;
	esac
	whiptail --title "Monero Update Complete" --msgbox "Update complete, Your Monero Node has resumed." 16 60
fi
##End debug log
log "Update Script Complete
####################
End setup-update-p2pool.sh script $(date)
####################"
