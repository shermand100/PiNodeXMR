!/bin/bash
		CHOICE=$(whiptail --title "Monero Onion Blockchain Explorer" --menu "\n\nStart or Stop the Blockchain Explorer manually" 20 60 10 \
	"1)" "Start Blockchain Explorer"   \
	"2)" "Stop Blockchain Explorer"   \
	"3)" "Cancel" 2>&1 >/dev/tty)

case $CHOICE in
		"1)") sudo systemctl start blockExplorer.service
			TERM=vt220 whiptail --infobox "Please Wait...\n\nCommand has been passed to systemd to start the Monero Onion Blockchain Explorer" 12 78
			whiptail --title "Monero Onion Blockchain Explorer" --msgbox "Systemd has successfully started the Monero Onion Blockchain Explorer" 12 78
            sudo systemctl enable blockExplorer.service
			clear
			. /home/pinodexmr/setup.sh

            ;;

		"2)") sudo systemctl stop blockExplorer.service
			TERM=vt220 whiptail --infobox "Please Wait...\n\nCommand has been passed to systemd to stop the Monero Onion Blockchain Explorer" 12 78
			whiptail --title "Monero Onion Blockchain Explorer" --msgbox "Systemd has successfully stopped the Monero Onion Blockchain Explorer" 12 78
            sudo systemctl disable blockExplorer.service
			clear
			. /home/pinodexmr/setup.sh
			;;
		
		"3)") . /home/pinodexmr/setup.sh
			;;
		
esac

# whiptail --title "Monero Onion Blockchain Explorer" --msgbox "Due to stability issues the block explorer has been disabled, hopefully as a temporary measure. I hope to return it to this project in the future." 20 78
		
. /home/pinodexmr/setup.sh