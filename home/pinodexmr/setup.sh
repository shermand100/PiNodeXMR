#!/bin/bash

		#HEIGHT=20
		#WIDTH=60
		#CHOICE_HEIGHT=8
		CHOICE=$(whiptail --backtitle "Welcome" --title "PiNode-XMR Setup" --menu "What would you like to do?" 20 60 8 \
    "1)" "Terminal Password & RPC username:password setup"   \
	"2)" "USB storage setup"   \
	"3)" "Update Monero"  \
	"4)" "Update PiNode-XMR" \
	"5)" "Prune Node" \
	"6)" "Install PiVPN" \
	"7)" "Install NoIP.com Dynamic DNS" \
	"8)" "Exit to Command line"  2>&1 >/dev/tty)
	
		case $CHOICE in
		"1)") if (whiptail --title "PiNode-XMR Set Passwords" --yesno "This will change your web terminal log in password & your RPC username and password\n\nYes/Continue or No/back to menu?" 12 78); then
    . /home/pinodexmr/setup-passwords.sh
else
    . /home/pinodexmr/setup.sh
fi
            ;;

		"2)") if (whiptail --title "PiNode-XMR configure storage" --yesno "This will allow you to add USB storage for the Monero blockchain.\n\nConnect your device now.\n\n***If this device has not been used with PiNode-XMR before it will be formatted and all data on it lost***" 12 78); then
    . /home/pinodexmr/setup-usb.sh
else
    . /home/pinodexmr/setup.sh
fi
		;;
		
		"3)")
			whiptail \
		--title "PiNode-XMR Update" \
		--msgbox "Your PiNode-XMR will check to see if an update is available"
		;;
		
		"4)")
			whiptail \
		--title "PiNode-XMR Update" \
		--msgbox "Your PiNode-XMR will check to see if an update is available"
		;;
		
		"5)")
			whiptail \
		--title "PiNode-XMR Update" \
		--msgbox "Your PiNode-XMR will check to see if an update is available"
		;;
		
		"6)")
			whiptail \
		--title "PiNode-XMR Update" \
		--msgbox "Your PiNode-XMR will check to see if an update is available"
		;;
		
		"7)")
if (whiptail --title "PiNode-XMR Configure Dynamic DNS" --yesno "This will configure Dynamic DNS from NoIP.com\n\nFirst create a free account with them and have your username and password before continuing\n\nContinue or back to menu?" 12 78); then
    . /home/pinodexmr/setup-noip.sh
else
    . /home/pinodexmr/setup.sh
fi
		;;
		
		"8)")
			whiptail \
		--title "PiNode-XMR Update" \
		--msgbox "Your PiNode-XMR will check to see if an update is available"
		;;
esac

#Restore setup back to nil to allow script to be run again if needed
#	echo "#!/bin/sh
#SETUP_STATUS=0" > /home/pinodexmr/setupstatus.sh
#To allow Monero onion-block-explorer to be run from boot now storage has been configured. Referenced from init.sh
	#echo "#!/bin/sh
#SETUP_COMPLETE=1" > /home/pinodexmr/setupcomplete.sh