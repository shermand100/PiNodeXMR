#!/bin/bash
##To run me on cmd line wget -O - https://raw.githubusercontent.com/shermand100/pinode-xmr/master/Install-PiNode-XMR.sh | bash
echo -e "\e[32mPreparing Menu...\e[0m"
sleep 2
#Check user has whiptail - required to display menu
sudo apt-get install whiptail -y

CHOICE=$(
whiptail --title "Welcome to the PiNode-XMR Project" --menu "For correct installation select your OS" 20 60 5 \
	"1)" "Raspbian (Buster)"   \
	"2)" "Ubuntu"  \
	"3)" "Armbian (Buster)" \
	"4)" "Exit"  3>&2 2>&1 1>&3	
)

case $CHOICE in
	"1)")
		#Commands for Raspbian
		echo -e "\e[32mDownloading data for install\e[0m"
		sleep 3
		wget https://raw.githubusercontent.com/shermand100/pinode-xmr/Raspbian-install/raspbian.sh
		echo -e "\e[32mPiNode-XMR Raspbian configuration file received\e[0m"
		echo -e "\e[32mStarting Installation\e[0m"
		sudo chmod 755 /home/pi/raspbian.sh
		sleep 2
		./raspbian.sh
		exit 1
	;;
	"2)")   
		#Commands for Ubuntu
		whiptail --title "Ubuntu Installer coming soon" --msgbox "Ubuntu is not yet available, but is a work in progress\n\n\Please select either the Raspbian or Armbian installer if your Hardware/OS is ready." 16 60;
		./Install-PiNode-XMR.sh
	;;

	"3)")   
		#Commands for Armbian
		echo -e "\e[32mDownloading data for install\e[0m"
		sleep 3
		wget https://raw.githubusercontent.com/shermand100/pinode-xmr/Armbian-install/armbian-installer.sh
		echo -e "\e[32mPiNode-XMR Armbian configuration file received\e[0m"
		echo -e "\e[32mStarting Installation\e[0m"
		sudo chmod 755 /home/pinodexmr/armbian-installer.sh
		sleep 2
		./armbian-installer.sh
		exit 1
        ;;

	"4)") exit
        ;;
esac
exit
