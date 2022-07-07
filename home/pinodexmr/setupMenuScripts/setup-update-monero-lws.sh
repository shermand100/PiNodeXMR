#!/bin/bash
#(1) Define variables and updater functions

#Error Log:
touch /home/pinodexmr/debug.log
echo "
####################
" 2>&1 | tee -a /home/pinodexmr/debug.log
echo "Start setup-update-monero-lws.sh script $(date)" 2>&1 | tee -a /home/pinodexmr/debug.log
echo "
####################
" 2>&1 | tee -a /home/pinodexmr/debug.log

#Stop Monero-lws service (if started)
echo -e "\e[32mStop Monero-lws service (if started)\e[0m"	
sudo systemctl stop monero-lws.service
##Delete old version
echo -e "\e[32mDelete old version\e[0m"		
rm -rf /home/pinodexmr/monero-lws/ 2>&1 | tee -a /home/pinodexmr/debug.log
echo -e "\e[32mSuccess\e[0m"
sleep "2"
echo -e "\e[32mDownloading and Building new Monero-LWS\e[0m"
#Check dependencies (Should be installed already from Monero install)
sudo apt update && sudo apt install build-essential cmake libboost-all-dev libssl-dev libzmq3-dev doxygen graphviz -y 2>&1 | tee -a /home/pinodexmr/debug.log
echo -e "\e[32mDownloading VTNerd Monero-LWS\e[0m"
sleep 2
git clone --recursive https://github.com/vtnerd/monero-lws.git; 2>&1 | tee -a /home/pinodexmr/debug.log
echo -e "\e[32mConfiguring install\e[0m"
sleep 2									
cd monero-lws
git checkout release-v0.1_0.17 2>&1 | tee -a /home/pinodexmr/debug.log
mkdir build && cd build
cmake -DMONERO_SOURCE_DIR=/home/pinodexmr/monero -DMONERO_BUILD_DIR=/home/pinodexmr/monero/build/release .. 2>&1 | tee -a /home/pinodexmr/debug.log
echo -e "\e[32mBuilding VTNerd Monero-LWS\e[0m"
sleep 2								
make 2>&1 | tee -a /home/pinodexmr/debug.log
cd
if (whiptail --title "Monero-LWS Install" --yesno "\nWould you like to start Monero-LWS now?" 14 78); then
	sudo systemctl start monero-lws.service
fi

##End debug log
echo "Update Complete" 2>&1 | tee -a /home/pinodexmr/debug.log
sleep 5
echo "####################" 2>&1 | tee -a /home/pinodexmr/debug.log
echo "End setup-update-monero-lws.sh script $(date)" 2>&1 | tee -a /home/pinodexmr/debug.log
echo "####################" 2>&1 | tee -a /home/pinodexmr/debug.log

whiptail --title "Monero-LWS Updater" --msgbox "\nThe Monero-LWS installation is complete and SSL certificates have been preserved.\n\nReturning to Menu..." 20 78

./setup.sh