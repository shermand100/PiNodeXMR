#!/bin/bash
##To run me on cmd line wget -O - https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/master/Install-PiNode-XMR.sh | bash
echo -e "\e[32mPreparing Menu...\e[0m"
sleep 2
#Check user has whiptail - required to display menu
sudo apt-get install whiptail -y

CHOICE=$(whiptail --title "Welcome to the PiNode-XMR Project" --menu "For correct installation select your OS. Build PiNodeXMR ontop of..." 20 60 5 \
	"1)" "Ubunutu Server 22.04/5 LTS (current 32/64bit)" \
	"2)" "Armbian Debian (Bullseye - Discontinued)" \
	"3)" "Armbian Debian (Buster - Discontinued)" \
	"4)" "Raspberry Pi OS (Discontinued)" \
	"5)" "Exit" 3>&2 2>&1 1>&3
)

case $CHOICE in
	"1)")
		#Commands for Ubuntu Server LTS (current)
		echo -e "\e[32mDownloading data for install\e[0m"
		sleep 3
		wget https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/ubuntuServer-20.04/ubuntu-installer.sh
		echo -e "\e[32mPiNode-XMR Ubuntu configuration file received\e[0m"
		echo -e "\e[32mStarting Installation\e[0m"
		sudo chmod 755 ~/ubuntu-installer.sh
		sleep 2
		./ubuntu-installer.sh
		exit 1
        ;;

	"2)")   
		#Commands for Armbian Bullseye (discontinued)
		echo -e "\e[32mDownloading data for install\e[0m"
		sleep 3
		wget https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/Armbian-install/armbian-bullseye-installer.sh
		echo -e "\e[32mPiNode-XMR Armbian configuration file received\e[0m"
		echo -e "\e[32mStarting Installation\e[0m"
		sudo chmod 755 ~/armbian-bullseye-installer.sh
		sleep 2
		./armbian-bullseye-installer.sh
		exit 1
    	;;	

	"3)")   
		#Commands for Armbian Buster (end of life)
		echo -e "\e[32mDownloading data for install\e[0m"
		sleep 3
		wget https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/Armbian-install/armbian-installer.sh
		echo -e "\e[32mPiNode-XMR Armbian configuration file received\e[0m"
		echo -e "\e[32mStarting Installation\e[0m"
		sudo chmod 755 ~/armbian-installer.sh
		sleep 2
		./armbian-installer.sh
		exit 1
        ;;

	"4)")   
				#Commands for Raspberry Pi OS
		echo -e "\e[32mDownloading data for install\e[0m"
		sleep 3
		wget https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/Raspbian-install/raspbian.sh
		echo -e "\e[32mPiNode-XMR Raspbian configuration file received\e[0m"
		echo -e "\e[32mStarting Installation\e[0m"
		sudo chmod 755 /home/pi/raspbian.sh
		sleep 2
		./raspbian.sh
		exit 1
		;;	

	"5)") exit
        ;;
esac
exit
