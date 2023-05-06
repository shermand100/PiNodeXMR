#!/bin/bash

whiptail --title "PiNode-XMR NoIP config" --msgbox "PiNode-XMR will now install 'tor' and it's monitoring tool 'nyx'" 8 78

##Setup tor + hidden service + monitor file
echo -e "\e[32mSetup tor hidden service and monitor file\e[0m"
sleep 3
sudo apt update #gets latest sources for tor install
sudo apt install tor torsocks nyx -y
echo -e "\e[32mDownloading PiNode-XMR config file\e[0m"
sleep 3

wget https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/ubuntuServer-20.04/etc/tor/torrc

echo -e "\e[32mApplying Settings...\e[0m"
sleep 3
sudo mv /home/nodo/torrc /etc/tor/torrc
sudo chmod 644 /etc/tor/torrc
sudo chown root /etc/tor/torrc
#Insert user specific local IP for correct hiddenservice redirect (line 73 overwrite)
sudo sed -i "73s/.*/HiddenServicePort 18081 $(hostname -I | awk '{print $1}'):18081/" /etc/tor/torrc
echo -e "\e[32mRestarting tor service...\e[0m"
sudo service tor restart
sleep 3
#Output onion address
sudo cat /var/lib/tor/hidden_service/hostname > /var/www/html/onion-address.txt
echo -e "\e[32mSuccess! Returning to menu\e[0m"
sleep 3

./setup.sh
