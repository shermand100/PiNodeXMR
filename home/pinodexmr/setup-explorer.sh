#!/bin/bash
		CHOICE=$(whiptail --title "Monero Onion Blockchain Explorer" --menu "\n\nStart or Stop the Blockchain Explorer manually" 20 60 10 \
	"1)" "Start Blockchain Explorer"   \
	"2)" "Stop Blockchain Explorer"   \
	"3)" "Cancel" 2>&1 >/dev/tty)

case $CHOICE in
		"1)") sudo systemctl start explorer-start.service
			TERM=vt220 whiptail --infobox "Please Wait...\n\nCommand has been passed to systemd to start the Monero Onion Blockchain Explorer" 12 78
			echo "#!/bin/sh
EXPLORER_START=1" > /home/pinodexmr/explorer-flag.sh
			whiptail --title "Monero Onion Blockchain Explorer" --msgbox "Systemd has successfully started the Monero Onion Blockchain Explorer" 12 78
			clear
			. /home/pinodexmr/setup.sh

            ;;

		"2)") sudo systemctl stop explorer-start.service
			TERM=vt220 whiptail --infobox "Please Wait...\n\nCommand has been passed to systemd to stop the Monero Onion Blockchain Explorer" 12 78
			echo "#!/bin/sh
EXPLORER_START=0" > /home/pinodexmr/explorer-flag.sh
			whiptail --title "Monero Onion Blockchain Explorer" --msgbox "Systemd has successfully stopped the Monero Onion Blockchain Explorer" 12 78
			clear
			. /home/pinodexmr/setup.sh
			;;
		
		"3)") . /home/pinodexmr/setup.sh
			;;
		
esac