#!/bin/bash
##To run me on cmd line wget -O - https://raw.githubusercontent.com/shermand100/pinode-xmr/development/pinode-xmr-build.sh | bash
echo -e "\e[32mPreparing Menu...\e[0m"
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
		#Commands for Raspbian
		echo -e "\e[32mDownloading data for install\e[0m"
		sleep 3
		wget https://raw.githubusercontent.com/shermand100/pinode-xmr/development/raspbian.sh
		echo -e "\e[32mPiNode-XMR Raspbian configuration file received\e[0m"
		echo -e "\e[32mStarting Installation\e[0m"
		sudo chmod 755 /home/pi/raspbian.sh
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
		echo -e "\e[32mDownloading data for install\e[0m"
		sleep 3
		wget https://raw.githubusercontent.com/shermand100/pinode-xmr/development/armbian.sh
		echo -e "\e[32mPiNode-XMR Raspbian configuration file received\e[0m"
		echo -e "\e[32mStarting Installation\e[0m"
		sudo chmod 755 /home/pi/armbian.sh
		sleep 2
		./armbian.sh
		exit 1
        ;;

	"4)") exit
        ;;
esac
exit
