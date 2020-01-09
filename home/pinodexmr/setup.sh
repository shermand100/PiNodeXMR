#!/bin/bash

		#HEIGHT=20
		#WIDTH=60
		#CHOICE_HEIGHT=8
		CHOICE=$(whiptail --backtitle "Welcome" --title "PiNode-XMR Setup" --menu "\n\nWhat would you like to do?" 20 60 10 \
    "1)" "Terminal Password & RPC username:password setup"   \
	"2)" "USB storage setup"   \
	"3)" "Start/Stop Blockchain Explorer"   \
	"4)" "Update Monero"  \
	"5)" "Update PiNode-XMR" \
	"6)" "Update Blockchain Explorer" \
	"7)" "Prune Node" \
	"8)" "Install PiVPN" \
	"9)" "Install NoIP.com Dynamic DNS" \
	"10)" "Exit to Command line"  2>&1 >/dev/tty)
	
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
		
		"3)") . /home/pinodexmr/setup-explorer.sh
		;;
		
		"4)") if (whiptail --title "PiNode-XMR Update Monero" --yesno "This will run a check to see if a Monero update is available\n\nIf an update is found PiNode-XMR will perform the update.\n\n***This will take several hours***\n\nContinue?" 12 78); then
    . /home/pinodexmr/setup-update-monero.sh
else
    . /home/pinodexmr/setup.sh
fi
		;;
		
		"5)") if (whiptail --title "Update PiNode-XMR" --yesno "This will check for updates to PiNode-XMR features not covered by other titles in the main menu\n\nWould you like to continue?" 12 78); then
    . /home/pinodexmr/setup-update-pinodexmr.sh
else
    . /home/pinodexmr/setup.sh
fi
		;;
						
		"6)") if (whiptail --title "Update Onion-Blockchain-Explorer" --yesno "This will check for and install updates to your Blockchain Explorer\n\nIf updates are found they will be installed\n\nWould you like to continue?" 12 78); then
    . /home/pinodexmr/setup-prune-node.sh
else
    . /home/pinodexmr/setup.sh
fi
		;;
				
		"7)") if (whiptail --title "PiNode-XMR Prune Monero Node" --yesno "This will configure your node to run 'pruned' to reduce storage space required for the blockchain\n\n***This command only be run once and cannot be undone***\n\nAre you sure you want to continue?" 12 78); then
    . /home/pinodexmr/setup-prune-node.sh
else
    . /home/pinodexmr/setup.sh
fi
		;;
		
		"8)") if (whiptail --title "PiNode-XMR PiVPN Install" --yesno "This feature will install PiVPN on your PiNode-XMR\n\nPiVPN is a simple to configure openVPN server.\n\nFor more info see https://pivpn.dev/" 12 78); then
    . /home/pinodexmr/setup-PiVPN.sh
else
    . /home/pinodexmr/setup.sh
fi
		;;
		
		"9)")
if (whiptail --title "PiNode-XMR Configure Dynamic DNS" --yesno "This will configure Dynamic DNS from NoIP.com\n\nFirst create a free account with them and have your username and password before continuing\n\nContinue or back to menu?" 12 78); then
    . /home/pinodexmr/setup-noip.sh
else
    . /home/pinodexmr/setup.sh
fi
		;;
		
		"10)")
		;;
esac

#Restore setup back to nil to allow script to be run again if needed
#	echo "#!/bin/sh
#SETUP_STATUS=0" > /home/pinodexmr/setupstatus.sh
#To allow Monero onion-block-explorer to be run from boot now storage has been configured. Referenced from init.sh
	#echo "#!/bin/sh
#SETUP_COMPLETE=1" > /home/pinodexmr/setupcomplete.sh