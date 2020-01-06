#!/bin/bash


		dialog
		HEIGHT=20
		WIDTH=60
		CHOICE_HEIGHT=4
		BACKTITLE="Welcome"
		TITLE="PiNode-XMR Setup"
		MENU="Welcome to PiNode-XMR. This script will build the PiNode-XMR project on this device. To get started I need to know what operating system I'm running on."

		OPTIONS=(1 "Raspbian"
				2 "Debian/Armbian")

		CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

		clear
		case $CHOICE in
		1)
			dialog \
		--title "PiNode-XMR Setup" \
		--msgbox "PiNode-XMR will now be configured for Raspbian" 20 60
		wget https://raw.githubusercontent.com/shermand100/pinode-xmr/development/raspbian.sh
		echo -e "\e[32mPiNode-XMR Raspbian configuration file received\e[0m"
		echo -e "\eStarting Installation\e[0m"
		sleep 2
		./raspbian.sh
		exit 1
            ;;
        2)
			dialog \
		--title "PiNode-XMR Setup" \
		--msgbox "PiNode-XMR will now be configured for Debian/Armbian" 20 60
		exit 1
            ;;
		esac
