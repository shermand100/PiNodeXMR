#!/bin/bash
#Common variables and functions

DEBUG_LOG=/home/nanode/debug.log
CONFIG_FILE=/home/nanode/config.json

getvar() {
	jq ".config.$1" "$CONFIG_FILE"
}

putvar() {
	contents=$(jq ".config.$1 = \"$2\"" "$CONFIG_FILE")
	echo -E "$contents" > "$CONFIG_FILE"
}

showtext() {
	log "$*"
	echo -e "\e[32m$*\e[0m"
}

log() {
	echo "$*" | tee -a "$DEBUG_LOG"
}

services-stop() {
	sudo systemctl stop blockExplorer.service
	sudo systemctl stop moneroPrivate.service
	sudo systemctl stop moneroMiningNode.service
	sudo systemctl stop moneroTorPrivate.service
	sudo systemctl stop moneroTorPublic.service
	sudo systemctl stop moneroPublicFree.service
	sudo systemctl stop moneroI2PPrivate.service
	sudo systemctl stop moneroCustomNode.service
	sudo systemctl stop moneroPublicRPCPay.service
	sudo systemctl stop p2pool.service
}

#Define Restart Monero Node
# Key - bs
# 2 = idle
# 3 || 5 = private node || mining node
# 4 = tor
# 6 = Public RPC pay
# 7 = Public free
# 8 = I2P
# 9 tor public
services-start() {
	bs="$1"
	if [ "$bs" -eq 2 ]
	then
		whiptail --title "Monero Update Complete" --msgbox "Update complete, Node ready for start. See web-ui at $(hostname -I) to select mode." 16 60
	else
		case $bs in
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
}

export -f log
export -f showtext
export DEBUG_LOG
export CONFIG_FILE
