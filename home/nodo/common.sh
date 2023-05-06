#!/bin/bash
#Common variables and functions

DEBUG_LOG=/home/nodo/debug.log
CONFIG_FILE=/home/nodo/variables/config.json

check_connection() {
        touse="$(ip r | grep default | cut -d ' ' -f 3)"
        for f in $touse; do
                if ping -q -w 1 -c 1 "$f"> /dev/null; then
                        return 0
                fi
        done
        return 1
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
	#create table & part
	parted --script "$blockdevice" mklabel gpt mkpart primary 1MiB 100%;
	sleep 1
	#create fs
	mkfs."$fstype" -f "${blockdevice}p1"
	sleep 1
	#get uuid from block device
	uuid=$(blkid | grep "$1" | sed 's/.*\sUUID="\([a-z0-9\-]\+\)".*/\1/g')
	#append new partition to fstab
	sed "/^UUID=$uuid/d" /etc/fstab
	#add to fstab
	printf "\nUUID=%s\t/media/monero\t%s\tdefaults,noatime\t0\t0" "$uuid" "$fstype" | tee -a /etc/fstab
	#create mountpoint
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
	# Very cringe, I know
	re='^[+-]?[0-9]+([.][0-9]+)?$'
	if [[ $2 =~ $re ]]; then
		contents=$(jq --argjson var "$2" ".config.$1 = \$var" "$CONFIG_FILE")
	else
		contents=$(jq --argjson var "\"$2\"" ".config.$1 = \$var" "$CONFIG_FILE")
	fi
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

services="monerod explorer monero-lws moneroStatus"
services-stop() {
	for f in $services; do
		systemctl stop "$f".service
	done
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
	for f in $services; do
		if systemctl is-enabled "$f".service; then
			systemctl start "$f".service
		fi
	done
}

export -f log
export -f showtext
export DEBUG_LOG
export CONFIG_FILE
