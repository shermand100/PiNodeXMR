#!/bin/bash

whiptail --title "PiNode-XMR Update" --msgbox "\n\n" 12 78

if (whiptail --title "PiNode-XMR Updater" --yesno "This will update PiNode-XMR to the newest version\n\nContinue?" 12 78); then

else
    . /home/pinodexmr/setup.sh
fi
		echo "Commands to be inserted here for updating PiNode-XMR with new features"
		sleep 5
		else
	

#Return to menu
./setup.sh
