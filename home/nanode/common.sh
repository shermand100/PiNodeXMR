#!/bin/bash
#Common variables and functions

DEBUG_LOG=/home/nanode/debug.log
CONFIG_FILE=/home/nanode/variables/config.json

getip() {
	hostname -I | awk '{print $1}'
}

getvar() {
	showtext "var $1 queried"
	jq ".config.$1" "$CONFIG_FILE"
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
	echo "$*" >> "$DEBUG_LOG"
}

services-stop() {
	systemctl stop blockExplorer.service
	systemctl stop moneroPrivate.service
	systemctl stop moneroTorPrivate.service
	systemctl stop moneroTorPublic.service
	systemctl stop moneroPublicFree.service
	systemctl stop moneroI2PPrivate.service
	systemctl stop moneroCustomNode.service
	systemctl stop moneroPublicRPCPay.service
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
				systemctl start moneroPrivate.service
				;;
			4)
				systemctl start moneroTorPrivate.service
				;;
			5)
				systemctl start moneroPublicRPCPay.service
				;;
			6)
				systemctl start moneroPublicFree.service
				;;
			7)
				systemctl start moneroI2PPrivate.service
				;;
			8)
				systemctl start moneroTorPublic.service
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
