#!/bin/sh

#Dependencies
sudo apt-get install udftools coreutils vim-common -y 

TITLE=$(lsblk --nodeps | sed -n 1p)
LINE1=$(lsblk --nodeps | sed -n 2p)
LINE2=$(lsblk --nodeps | sed -n 3p)
LINE3=$(lsblk --nodeps | sed -n 4p)
LINE4=$(lsblk --nodeps | sed -n 5p)
LINE5=$(lsblk --nodeps | sed -n 6p)
LINE6=$(lsblk --nodeps | sed -n 7p)
LINE7=$(lsblk --nodeps | sed -n 8p)
LINE8=$(lsblk --nodeps | sed -n 9p)
#whiptail --title "PiNode-XMR Storage" --msgbox "$LSBLK" 10 78

	CHOICE=$(whiptail --backtitle "Storage Setup" --title "PiNode-XMR Storage" --menu "\nSelect device for blockchain storage\n" 20 80 10 \
	"__" "$TITLE" \
	"1)" "$LINE1" \
    "2)" "$LINE2" \
	"3)" "$LINE3" \
	"4)" "$LINE4" \
	"5)" "$LINE5" \
	"6)" "$LINE6" \
	"7)" "$LINE7" \
	"8)" "$LINE8" 2>&1 >/dev/tty)
	
	case $CHOICE in
	
		"__") . /home/pinodexmr/setupMenuScripts/setup-usb-select-device.sh
		;;
		
		"1)") DEVICE_TO_CONFIGURE=$(lsblk --nodeps -o name | sed -n 2p)
		echo "#!/bin/sh
DEVICE_TO_CONFIGURE=$(lsblk --nodeps -o name | sed -n 2p)" > /home/pinodexmr/setupMenuScripts/setup-usb-path.sh
				sudo /home/pinodexmr/setupMenuScripts/setup-usb.sh /dev/$DEVICE_TO_CONFIGURE XMRBLOCKCHAIN
		;;
				
		"2)")DEVICE_TO_CONFIGURE=$(lsblk --nodeps -o name | sed -n 3p)
		echo "#!/bin/sh
DEVICE_TO_CONFIGURE=$(lsblk --nodeps -o name | sed -n 3p)" > /home/pinodexmr/setupMenuScripts/setup-usb-path.sh
				sudo /home/pinodexmr/setupMenuScripts/setup-usb.sh /dev/$DEVICE_TO_CONFIGURE XMRBLOCKCHAIN
		;;
		
		"3)")DEVICE_TO_CONFIGURE=$(lsblk --nodeps -o name | sed -n 4p)
		echo "#!/bin/sh
DEVICE_TO_CONFIGURE=$(lsblk --nodeps -o name | sed -n 4p)" > /home/pinodexmr/setupMenuScripts/setup-usb-path.sh
				sudo /home/pinodexmr/setupMenuScripts/setup-usb.sh /dev/$DEVICE_TO_CONFIGURE XMRBLOCKCHAIN
		;;
		
		"4)")DEVICE_TO_CONFIGURE=$(lsblk --nodeps -o name | sed -n 5p)
		echo "#!/bin/sh
DEVICE_TO_CONFIGURE=$(lsblk --nodeps -o name | sed -n 5p)" > /home/pinodexmr/setupMenuScripts/setup-usb-path.sh
				sudo /home/pinodexmr/setupMenuScripts/setup-usb.sh /dev/$DEVICE_TO_CONFIGURE XMRBLOCKCHAIN
		;;

		"5)")DEVICE_TO_CONFIGURE=$(lsblk --nodeps -o name | sed -n 6p)
		echo "#!/bin/sh
DEVICE_TO_CONFIGURE=$(lsblk --nodeps -o name | sed -n 6p)" > /home/pinodexmr/setupMenuScripts/setup-usb-path.sh
				sudo /home/pinodexmr/setupMenuScripts/setup-usb.sh /dev/$DEVICE_TO_CONFIGURE XMRBLOCKCHAIN
		;;

		"6)")DEVICE_TO_CONFIGURE=$(lsblk --nodeps -o name | sed -n 7p)
		echo "#!/bin/sh
DEVICE_TO_CONFIGURE=$(lsblk --nodeps -o name | sed -n 7p)" > /home/pinodexmr/setupMenuScripts/setup-usb-path.sh
				sudo /home/pinodexmr/setupMenuScripts/setup-usb.sh /dev/$DEVICE_TO_CONFIGURE XMRBLOCKCHAIN
		;;
		
		"7)")DEVICE_TO_CONFIGURE=$(lsblk --nodeps -o name | sed -n 8p)
		echo "#!/bin/sh
DEVICE_TO_CONFIGURE=$(lsblk --nodeps -o name | sed -n 8p)" > /home/pinodexmr/setupMenuScripts/setup-usb-path.sh
				sudo /home/pinodexmr/setupMenuScripts/setup-usb.sh /dev/$DEVICE_TO_CONFIGURE XMRBLOCKCHAIN
		;;
		
		"8)")DEVICE_TO_CONFIGURE=$(lsblk --nodeps -o name | sed -n 9p)
		echo "#!/bin/sh
DEVICE_TO_CONFIGURE=$(lsblk --nodeps -o name | sed -n 9p)" > /home/pinodexmr/setupMenuScripts/setup-usb-path.sh
				sudo /home/pinodexmr/setupMenuScripts/setup-usb.sh /dev/$DEVICE_TO_CONFIGURE XMRBLOCKCHAIN
		;;
	esac
		./setup.sh
		exit 0
	