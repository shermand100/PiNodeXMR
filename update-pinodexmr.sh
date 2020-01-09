#!/bin/bash

if (whiptail --title "PiNode-XMR Updater" --yesno "This will update PiNode-XMR to the newest version\n\nContinue?" 12 78); then
		echo "Commands to be inserted here for updating PiNode-XMR with new features"
		sleep 5
else
    . /home/pinodexmr/setup.sh
fi

#Return to menu
./setup.sh
