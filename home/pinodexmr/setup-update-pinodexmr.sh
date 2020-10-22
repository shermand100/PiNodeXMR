#!/bin/bash


wget https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/Raspbian-install/new-ver-pi.sh -O /home/pinodexmr/new-ver-pi.sh


#Permission Setting
chmod 755 /home/pinodexmr/current-ver-pi.sh
chmod 755 /home/pinodexmr/new-ver-pi.sh
#Load Variables
. /home/pinodexmr/current-ver-pi.sh
. /home/pinodexmr/new-ver-pi.sh
echo "Version Info file received:"
echo "Current Version: $CURRENT_VERSION_PI "
echo "Latest Version: $NEW_VERSION_PI "

sleep "3"
	if [ $CURRENT_VERSION_PI -lt $NEW_VERSION_PI ]; then
					if (whiptail --title "PiNode-XMR Updater" --yesno "An update has been found for your PiNode-XMR. To continue will install it now.\n\nWould you like to Continue?" 12 78); then
					
	wget -O - https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/Raspbian-install/update-pinodexmr.sh | bash

					else
					rm /home/pinodexmr/new-ver-pi.sh
					. /home/pinodexmr/setup.sh
					fi

else
		if (whiptail --title "PiNode-XMR Update" --yesno "This device thinks it's running the latest version of PiNode-XMR.\n\nIf you think this is incorrect you may force an update below.\n\n*Note that a force update can also be used as a reset tool if you think your version is not functioning properly" --yes-button "Force PiNode-XMR Update" --no-button "Return to Main Menu"  14 78); then

	wget -O - https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/Raspbian-install/update-pinodexmr.sh | bash
		
									else
									whiptail --title "PiNode-XMR Update" --msgbox "Returning to Main Menu. No changes have been made." 12 78;
									rm /home/pinodexmr/new-ver-pi.sh
									. /home/pinodexmr/setup.sh
									fi
	fi
	
#clean up
rm /home/pinodexmr/new-ver-pi.sh
#Return to menu
./setup.sh
