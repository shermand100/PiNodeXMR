#!/bin/bash
#(1) Define variables and updater functions

#Error Log:
touch /home/nanode/debug.log
echo "
####################
" 2>&1 | tee -a /home/nanode/debug.log
echo "Start setup-update-monero-lws.sh script $(date)" 2>&1 | tee -a /home/nanode/debug.log
echo "
####################
" 2>&1 | tee -a /home/nanode/debug.log

#Stop Monero-lws service (if started)
echo -e "\e[32mStop Monero-lws service (if started)\e[0m"
sudo systemctl stop monero-lws.service
##Delete old version
echo -e "\e[32mDelete old version\e[0m"
rm -rf /home/nanode/monero-lws/ 2>&1 | tee -a /home/nanode/debug.log
echo -e "\e[32mSuccess\e[0m"
echo -e "\e[32mDownloading and Building new Monero-LWS\e[0m"
#Check dependencies (Should be installed already from Monero install)
sudo apt update && sudo apt install build-essential cmake libboost-all-dev libssl-dev libzmq3-dev doxygen graphviz -y 2>&1 | tee -a /home/nanode/debug.log
echo -e "\e[32mDownloading VTNerd Monero-LWS\e[0m"
git clone --recursive https://github.com/vtnerd/monero-lws.git; 2>&1 | tee -a /home/nanode/debug.log
echo -e "\e[32mConfiguring install\e[0m"
cd monero-lws
git checkout release-v0.2_0.18 2>&1 | tee -a /home/nanode/debug.log
mkdir build && cd build
cmake -DMONERO_SOURCE_DIR=/home/nanode/monero -DMONERO_BUILD_DIR=/home/nanode/monero/build/release .. 2>&1 | tee -a /home/nanode/debug.log
echo -e "\e[32mBuilding VTNerd Monero-LWS\e[0m"
make 2>&1 | tee -a /home/nanode/debug.log
cd
#Restarting Monero-LWS servcice
	sudo systemctl start monero-lws.service
#Update system reference current LWS version number to New version number
	chmod 755 /home/nanode/new-ver-lws.sh
	. /home/nanode/new-ver-lws.sh
	echo "#!/bin/bash
CURRENT_VERSION_LWS=$NEW_VERSION_LWS" > /home/nanode/current-ver-lws.sh 2>&1 | tee -a /home/nanode/debug.log

##End debug log
echo "Update Complete" 2>&1 | tee -a /home/nanode/debug.log
echo "####################" 2>&1 | tee -a /home/nanode/debug.log
echo "End setup-update-monero-lws.sh script $(date)" 2>&1 | tee -a /home/nanode/debug.log
echo "####################" 2>&1 | tee -a /home/nanode/debug.log

whiptail --title "Monero-LWS Updater" --msgbox "\nThe Monero-LWS installation is complete and SSL certificates have been preserved.\n\nReturning to Menu..." 20 78
