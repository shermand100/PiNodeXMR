#!/bin/bash
#(1) Define variables and updater functions



#Stop Monero-lws service (if started)
echo -e "\e[32mStop Monero-lws service (if started)\e[0m"	
sudo systemctl stop monero-lws.service
##Delete old version
echo -e "\e[32mDelete old version\e[0m"		
rm -rf /home/pinodexmr/monero-lws/
echo -e "\e[32mSuccess\e[0m"
sleep "2"
echo -e "\e[32mDownloading and Building new Monero-LWS\e[0m"
#Check dependencies (Should be installed already from Monero install)
sudo apt update && sudo apt install build-essential cmake libboost-all-dev libssl-dev libzmq3-dev doxygen graphviz -y
echo -e "\e[32mDownloading VTNerd Monero-LWS\e[0m"
sleep 2
git clone --recursive https://github.com/vtnerd/monero-lws.git;
echo -e "\e[32mConfiguring install\e[0m"
sleep 2									
cd monero-lws
git checkout release-v0.1_0.17
mkdir build && cd build
cmake -DMONERO_SOURCE_DIR=/home/pinodexmr/monero -DMONERO_BUILD_DIR=/home/pinodexmr/monero/build/release ..
echo -e "\e[32mBuilding VTNerd Monero-LWS\e[0m"
sleep 2								
make
cd
if (whiptail --title "Monero-LWS Install" --yesno "\nWould you like to start Monero-LWS now?" 14 78); then
	sudo systemctl start monero-lws.service
fi
whiptail --title "Monero-LWS Updater" --msgbox "\nThe Monero-LWS installation is complete and SSL certificates have been preserved.\n\nReturning to Menu..." 20 78

./setup.sh