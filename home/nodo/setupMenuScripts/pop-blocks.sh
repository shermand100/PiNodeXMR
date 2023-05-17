#!/bin/bash

# use temp file 
_temp="./dialog.$$"

	#Input Box - Pop Blocks
	whiptail --title "Nodo Pop Blocks" --inputbox "\nNumber of Blocks to remove" 10 30 2>$_temp
		
	       # get user input - number of blocks
			POP=$( cat $_temp )
			shred $_temp
#Ensure Monero is stopped before popping blocks
	echo -e "\e[32mEnsuring Monero is stopped before popping blocks...\e[0m"
	sleep 2
	
	sudo systemctl stop monerodPrivate.service
	sudo systemctl stop moneroMiningNode.service
	sudo systemctl stop moneroTorPrivate.service
	sudo systemctl stop moneroTorPublic.service
	sudo systemctl stop moneroPublicFree.service
	sudo systemctl stop moneroI2PPrivate.service
	sudo systemctl stop moneroCustomNode.service
	sudo systemctl stop moneroPublicRPCPay.service
	sleep 5

	./monero/build/release/bin/monero-blockchain-import --pop-blocks $POP
	
	echo -e "\e[32m${POP} Blocks have been removed from the blockchain\e[0m"
	
sleep "5"

. /home/nodo/setup.sh