#!/bin/bash

wget https://raw.githubusercontent.com/shermand100/pinode-xmr/development/new-ver-pi.sh -O /home/pinodexmr/new-ver-pi.sh
echo "Version Info file received:"
#Permission Setting
chmod 755 /home/pinodexmr/current-ver-pi.sh
chmod 755 /home/pinodexmr/new-ver-pi.sh
#Load Variables
. /home/pinodexmr/current-ver-pi.sh
. /home/pinodexmr/new-ver-pi.sh
echo "${NEW_VERSION_PI} New Version"
echo "${CURRENT_VERSION_PI} Current Version"
sleep "3"
	if [ $CURRENT_VERSION_PI -lt $NEW_VERSION_PI ]; then
					if (whiptail --title "PiNode-XMR Updater" --yesno "An update has been found for your PiNode-XMR. To continue will install it now.\n\nWould you like to Continue?" 12 78); then
					
					#Download update files
					
					#Backup User values
					
					#Install Update
					
					#Restore User Values

					#Update system version number to new one installed
					echo "#!/bin/bash
CURRENT_VERSION_PI=$NEW_VERSION_PI" > /home/pinodexmr/current-ver-pi.sh

					#Clean up files

					else
					. /home/pinodexmr/setup.sh
					exit 1
					fi

		
		#Delete new-ver-pi value
		rm /home/pinodexmr/new-ver-pi.sh
		
else
		whiptail --title "PiNode-XMR Update" --msgbox "\n\nYour PiNode-XMR is running the newest version" 12 78
	fi
	
#clean up
rm /home/pinodexmr/new-ver-pi.sh
#Return to menu
./setup.sh
