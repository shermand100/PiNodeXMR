#!/bin/bash
##To run me on cmd line wget -O - https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/Install-PiNode-XMR.sh | bash
echo -e "\e[32mPreparing Menu...\e[0m"
sleep 2
#Check user has whiptail - required to display menu
sudo apt-get install whiptail -y

CHOICE=$(whiptail --title "Welcome to the PiNode-XMR Project" --menu "For correct installation select your OS. (Currently Ubuntu Server best supported) \nBuild PiNodeXMR on top of..." 20 60 5 \
	"1)" "Ubunutu Server LTS (current 32/64bit)" \
	"2)" "Exit" 3>&2 2>&1 1>&3
)

case $CHOICE in
	"1)")
		#Commands for Ubuntu Server LTS (current)
		echo -e "\e[32mDownloading data for install\e[0m"
		sleep 3
		wget https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/ubuntu-installer.sh
		echo -e "\e[32mPiNode-XMR Ubuntu configuration file received\e[0m"
		echo -e "\e[32mStarting Installation\e[0m"
		sudo chmod 755 ~/ubuntu-installer.sh
		sleep 2
		./ubuntu-installer.sh
		exit 1
        ;;

	"2)")   
		exit
        ;;	
 
esac
exit
