#!/bin/bash
#Common variables and functions

DEBUG_LOG=/home/nanode/debug.log
CONFIG_FILE=/home/nanode/config.json

getip() {
	return "$(hostname -I | awk '{print $1}')"
}

getvar() {
	showtext "var $1 queried"
	return "$(jq ".config.$1" "$CONFIG_FILE")"
}

putvar() {
	contents=$(jq ".config.$1 = \"$2\"" "$CONFIG_FILE")
	echo -E "$contents" > "$CONFIG_FILE"
	showtext "var $1 updated to $2"
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
	sudo systemctl stop moneroTorPrivate.service
	sudo systemctl stop moneroTorPublic.service
	sudo systemctl stop moneroPublicFree.service
	sudo systemctl stop moneroI2PPrivate.service
	sudo systemctl stop moneroCustomNode.service
	sudo systemctl stop moneroPublicRPCPay.service
}

#Define Restart Monero Node
# Key - bs
# 2 = idle
# 3 = Private node
# 4 = tor
# 5 = Public RPC pay
# 6 = Public free
# 7 = I2P
# 8 = tor public
services-start() {
bs="$(getvar "boot_status")"
		case $bs in
			3)
				sudo systemctl start moneroPrivate.service
				;;
			4)
				sudo systemctl start moneroTorPrivate.service
				;;
			5)
				sudo systemctl start moneroPublicRPCPay.service
				;;
			6)
				sudo systemctl start moneroPublicFree.service
				;;
			7)
				sudo systemctl start moneroI2PPrivate.service
				;;
			8)
				sudo systemctl start moneroTorPublic.service
				;;
			*)
				log "Very strange"
				;;
		esac
}

export -f log
export -f showtext
export DEBUG_LOG
export CONFIG_FILE
