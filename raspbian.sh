#!/bin/bash

##Open Sources:
# Web-UI by designmodo Flat-UI free project at https://github.com/designmodo/Flat-UI
# Monero github https://github.com/moneroexamples/monero-compilation/blob/master/README.md
# Monero Blockchain Explorer https://github.com/moneroexamples/onion-monero-blockchain-explorer
# PiNode-XMR scripts and custom files at my repo https://github.com/monero-ecosystem/PiNode-XMR
# PiVPN - OpenVPN server setup https://github.com/pivpn/pivpn

###Begin

##User pinodexmr creation
echo -e "\e[32mStep 1: produce user 'pinodexmr'\e[0m" 
sleep 3
sudo adduser pinodexmr --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo -e "\e[32mUser 'pinodexmr' created\e[0m"
sleep 3

#Set pinodexmr password 'PiNodeXMR'
echo "pinodexmr:PiNodeXMR" | sudo chpasswd
echo -e "\e[32mpinodexmr password changed to 'PiNodeXMR'\e[0m"
sleep 3

##Replace file /etc/sudoers to set global sudo permissions/rules
echo -e "\e[32mDownload and replace /etc/sudoers file\e[0m"
sleep 3
wget https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/Raspbian-install/etc/sudoers
sudo chmod 0440 /home/pi/sudoers
sudo chown root /home/pi/sudoers
sudo mv /home/pi/sudoers /etc/sudoers
echo -e "\e[32mGlobal permissions changed\e[0m"
sleep 3

##Download user 'pinodexmr' script and put in home directory to continue
wget https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/Raspbian-install/raspbian-pinodexmr.sh
sudo mv /home/pi/raspbian-pinodexmr.sh /home/pinodexmr/
sudo chown pinodexmr /home/pinodexmr/raspbian-pinodexmr.sh
sudo chmod 755 /home/pinodexmr/raspbian-pinodexmr.sh

##Change system hostname to PiNodeXMR
echo -e "\e[32mChanging system hostname to 'PiNodeXMR'\e[0m"
sleep 3
echo 'PiNodeXMR' | sudo tee /etc/hostname
#sudo sed -i '6d' /etc/hosts
echo '127.0.0.1       PiNodeXMR' | sudo tee -a /etc/hosts
sudo hostname PiNodeXMR

##make script run when user logs in
echo '. /home/pinodexmr/raspbian-pinodexmr.sh' | sudo tee -a /home/pinodexmr/.profile
whiptail --title "PiNode-XMR Continue Install" --msgbox "I've installed everything I can as user 'pi'\n\nSystem will reboot, then login as 'pinodexmr' to continue using password 'PiNodeXMR'\n\nSelect ok to continue with reboot" 16 60
echo -e "\e[32m****************************************\e[0m"
echo -e "\e[32m**********PiNode-XMR rebooting**********\e[0m"
echo -e "\e[32m**********Reminder:*********************\e[0m"
echo -e "\e[32m**********User: 'pinodexmr'*************\e[0m"
echo -e "\e[32m**********Password: 'PiNodeXMR'*********\e[0m"
echo -e "\e[32m****************************************\e[0m"
sleep 5
#reboot for hostname changes. Continue as pinodexmr
sudo reboot

##Change from user 'pi' to 'pinodexmr' and lock 'pi'
#echo -e "\e[32mSwitching user to 'pinodexmr'\e[0m"
#sleep 3
#echo "PiNodeXMR" | su - pinodexmr
#sudo -H -u pinodexmr bash -c 'bash /home/pinodexmr/raspbian-pinodexmr.sh' 

#End of script as user 'pi'. Continues in directory /home/pinodexmr
