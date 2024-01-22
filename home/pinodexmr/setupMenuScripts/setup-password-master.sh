#!/bin/bash
##Start password config

whiptail --title "PiNode-XMR Master Password config" --msgbox "This password is required for SSH connections and the web terminal log in\n\nKeep it safe - without this you cannot access any node settings" 16 60

clear
	
sudo passwd $USER

echo "Returning to Main Menu"
sleep 5

./setup.sh
exit 1