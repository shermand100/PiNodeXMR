#!/bin/bash

wget https://raw.githubusercontent.com/shermand100/pinode-xmr/development/new-ver-pi.sh -O /home/pinodexmr/new-ver-pi.sh
echo "Version Info file received:"
#Permission Setting
chmod 755 /home/pinodexmr/current-ver-pi.sh
chmod 755 /home/pinodexmr/new-ver-pi.sh
#Load Variables
. /home/pinodexmr/current-ver-pi.sh
. /home/pinodexmr/new-ver-pi.sh
echo $NEW_VERSION_PI 'New Version'
echo $CURRENT_VERSION_PI 'Current Version'
sleep "3"
	if [ $CURRENT_VERSION_PI -lt $NEW_VERSION_PI ]
		#Remove old version of update-pinodexmr.sh
		rm /home/pinodexmr/update-pinodexmr.sh
		#Get new update script and run
		wget -O - https://raw.githubusercontent.com/shermand100/pinode-xmr/development/update-pinodexmr.sh | bash
		else
		whiptail --title "PiNode-XMR Update" --msgbox "\n\nYour PiNode-XMR is running the newest version" 12 78
	fi
	
#clean up
rm /home/pinodexmr/new-ver-pi.sh
#Return to menu
./setup.sh
