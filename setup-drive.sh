#!/bin/bash

#shellcheck source=home/nanode/common.sh
. /home/nanode/common.sh

showtext "Formatting SSD..."
{
	#Narrows down non-rotational drives with nvme0n1 blockdevice, picks the top one. Hacky but should work.
	device=$(lsblk -o KNAME,VENDOR,ROTA | grep -e "0$" | grep -e "nvme\dn\d" | awk '{print $1}' | head -n1)
	showtext "Using device $device."
	if [ -n "$device" ]; then
		setup_drive "$device" xfs
	fi

} 2>&1 | tee -a "$DEBUG_LOG"
