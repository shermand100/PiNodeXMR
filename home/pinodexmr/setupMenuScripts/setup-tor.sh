#!/bin/bash

whiptail --title "PiNode-XMR NoIP config" --msgbox "PiNode-XMR will now install 'tor' and it's monitoring tool 'nyx'" 8 78

##Setup tor + hidden service + monitor file
echo -e "\e[32mSetup tor hidden service and monitor file\e[0m"
sleep 3
sudo apt update
sudo apt install apt-transport-https -y

#Establish OS Distribution
DIST="$(lsb_release -c | awk '{print $2}')"
ARCH="$(dpkg --print-architecture)"

#Set apt sources to retrieve tor official repository (Print to temp file)
echo "deb [arch=$ARCH signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org $DIST main
deb-src [arch=$ARCH signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org $DIST main" > ~/temp_torSources.list

#Overwrite tor.list with new created temp file above.
sudo mv ~/temp_torSources.list /etc/apt/sources.list.d/tor.list

#add the gpg key used to sign the packages
wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor | sudo tee /usr/share/keyrings/tor-archive-keyring.gpg >/dev/null


#Install tor and tor debian keyring (keeps signing keys current)
sudo apt update
sudo apt install tor deb.torproject.org-keyring
#upgrade below will get latest tor if already installed.
sudo apt upgrade -y
echo -e "\e[32mDownloading PiNode-XMR config file\e[0m"
sleep 3

wget https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/etc/tor/torrc

echo -e "\e[32mApplying Settings...\e[0m"
sleep 3
sudo mv /home/pinodexmr/torrc /etc/tor/torrc
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
