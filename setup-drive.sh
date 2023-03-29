#!/bin/bash

#shellcheck source=home/nanode/common.sh
. /home/nanode/common.sh

pre_setup() {
	read -r areyousure
	if [ "$areyousure" == "YES" ]; then
		setup_drive "$1" "$2"
	fi
}
#setup ssd
showtext "Setting up SSD..."
{
	#Print all non rotational (SSD) devices
	devices=$(lsblk -o KNAME,VENDOR,SIZE,ROTA | grep -e "0$" | awk '{print $1": "$2" ("$3")" }')
	tput bel
	printf '\e[?5h'
	sleep 0.5
	printf '\e[?5l'
	numdevices="$(echo "$devices" | wc -l)"
	if [ "$numdevices" -gt 1 ]; then
		showtext "Please enter the block device (usually three letters or nvme0) of the SSD\nPlease make sure you enter it correctly!"
		read -r devchosen
		#strip nonletters
		devchosen=${devchosen//[^[:alnum:]]/}
		if [ -n "$devchosen" ]; then
			showtext "Performing setup-drive on \"$devchosen\"\n"
			pre_setup "$devchosen" xfs
		else
			showtext "No device chosen! Not setting up."
		fi
	elif [ "$numdevices" -eq 1 ]; then
		devchosen=${devices%%:*}
		showtext "Assuming block device $devchosen"
		pre_setup "$devchosen" xfs
	else
		showtext "No non-rotational drive found! Not setting up."
	fi

} 2>&1 | tee -a "$DEBUG_LOG"
