#!/bin/bash

# use temp file 
_temp="./dialog.$$"

	#Input Box - Pop Blocks
	whiptail --title "PiNode-XMR Pop Blocks" --inputbox "\nNumber of Blocks to remove" 10 30 2>$_temp
		
	       # get user input - number of blocks
			POP=$( cat $_temp )
			shred $_temp
			
	./monero/build/release/bin/monero-blockchain-import --pop-blocks $POP
	
	echo -e "\e[32m${POP} Blocks have been removed from the blockchain\e[0m"
	
sleep "5"

. /home/pinodexmr/setup.sh