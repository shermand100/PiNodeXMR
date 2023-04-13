#!/bin/bash
#Common variables and functions

DEBUG_LOG=/home/nanode/debug.log
CONFIG_FILE=/home/nanode/variables/config.json

check_connection() {
	ping -q -w 1 -c 1 "$(ip r | grep default | cut -d ' ' -f 3)" > /dev/null
	return $?
}

setup_drive() {
	blockdevice="/dev/$1"
	fstype="$2"

	#unmount just in case
	for f in $(lsblk -o KNAME | grep -e "$1\\d\?"); do
		umount -vf "/dev/$f"
	done
	#format
	wipefs --all "/dev/$1"
	#make sure it's gpt
	sgdisk -g "/dev/$1"
	#create fs
	mkfs."$fstype" -f "$blockdevice"
	#get uuid from block device
	uuid=$(blkid | grep "$1" | sed 's/.*UUID="\([a-z0-9\-]\+\)".*/\1/g')
	#append new partition to fstab
	sed "/^UUID=$uuid/d" /etc/fstab
	#add to fstab
	printf "\nUUID=%s\t/media/monero\t%s\tdefaults,noatime\t0\t0" "$uuid" "$fstype" | tee -a /etc/fstab
	mkdir -p /media/monero
	#mount
	mount -v "UUID=$uuid"
	#correct owner
	chown monero:monero -R /media/monero
}

getip() {
	hostname -I | awk '{print $1}'
}

getvar() {
	log "var $1 queried"
	jq ".config.$1" "$CONFIG_FILE"
}

putvar() {
	log "var $1 updated to $2"
	contents=$(jq ".config.$1 = \"$2\"" "$CONFIG_FILE")
	if [ -n "$contents" ]; then
		echo -E "$contents" > "$CONFIG_FILE"
	fi
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
