#!/bin/bash
echo -e "\e[32mPreparing...\e[0m"
sleep 3
sudo apt-get install whiptail

CHOICE=$(
whiptail --title "Welcome to the PiNode-XMR Project" --menu "For correct installation select your OS" 20 60 5 \
	"1)" "Raspbian"   \
	"2)" "Debian"  \
	"3)" "Armbian" \
	"4)" "Exit"  3>&2 2>&1 1>&3	
)

case $CHOICE in
	"1)")   
		echo -e "\e[32mDownloading data for install\e[0m"
		sleep 3
		wget https://raw.githubusercontent.com/shermand100/pinode-xmr/development/raspbian.sh
		sudo apt-get install dialog -y
		sleep 2
		echo -e "\e[32mPiNode-XMR Raspbian configuration file received\e[0m"
		echo -e "\e[32mStarting Installation\e[0m"
		sudo chmod 755 /home/pinodexmr/raspbian.sh
		sleep 2
		./raspbian.sh
		exit 1
	;;
	"2)")   
		#Commands for Debian
		echo -e "\e[32mCommands for Debian\e[0m"
		exit 1
	;;

	"3)")   
		#Commands for Armbian
		echo -e "\e[32mCommands for Armbian\e[0m"
		exit 1
        ;;

	"4)") exit
        ;;
esac
exit
