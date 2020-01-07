#!/bin/bash


# use temp file 
_temp="./dialog.$$"

#Load menu status - to track setup progress - will be re-called throughout
. /home/pinodexmr/setupstatus.sh

if [ $SETUP_STATUS -eq 0 ]; then
		
		#HEIGHT=20
		#WIDTH=60
		#CHOICE_HEIGHT=8
		CHOICE=$(whiptail --backtitle "Welcome" --title "PiNode-XMR Setup" --menu "What would you like to do?" 20 60 8 \
    "1)" "Password setup"   \
	"2)" "USB storage setup"   \
	"3)" "Update Monero"  \
	"4)" "Update PiNode-XMR" \
	"5)" "Prune Node" \
	"6)" "Install PiVPN" \
	"7)" "Install NoIP.com Dynamic DNS" \
	"8)" "Exit to Command line"  2>&1 >/dev/tty)
	
		case $CHOICE in
		"1)")
			whiptail \
		--title "PiNode-XMR Setup" \
		--msgbox "You will now be guided through the initial setup for your PiNode-XMR\n\nIf you intend to use an external USB device to store the blockchain (device over 100GB) you may attach it now.\n\nThis menu will allow you to set a USB storage device, secure user name/password and Dynamic DNS configuration (optional)"
            ;;

		"2)")
			whiptail \
		--title "PiNode-XMR Update" \
		--msgbox "Your PiNode-XMR will check to see if an update is available"
		;;
		

            ;;

#Restore setup back to nil to allow script to be run again if needed
	echo "#!/bin/sh
SETUP_STATUS=0" > /home/pinodexmr/setupstatus.sh
#To allow Monero onion-block-explorer to be run from boot now storage has been configured. Referenced from init.sh
	echo "#!/bin/sh
SETUP_COMPLETE=1" > /home/pinodexmr/setupcomplete.sh