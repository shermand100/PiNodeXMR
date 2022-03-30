#!/bin/bash

##Open Sources:
# Web-UI by designmodo Flat-UI free project at https://github.com/designmodo/Flat-UI
# Monero github https://github.com/moneroexamples/monero-compilation/blob/master/README.md
# Monero Blockchain Explorer https://github.com/moneroexamples/onion-monero-blockchain-explorer
# PiNode-XMR scripts and custom files at my repo https://github.com/shermand100/pinode-xmr
# PiVPN - OpenVPN server setup https://github.com/pivpn/pivpn

#Welcome
if (whiptail --title "PiNode-XMR Ubuntu Installer" --yesno "To install PiNodeXMR using this installer the following condition is required\n\n* You are logged in as user 'ubuntu'\n* Would you like to continue?" 12 60); then

whiptail --title "PiNode-XMR Ubuntu Installer" --msgbox "Thanks for confirming\n\nPermissions and Hostnames will now be configured, this will only take a few seconds." 12 78


##Create new user 'pinodexmr'
sudo adduser pinodexmr --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password

#Set pinodexmr password 'PiNodeXMR'
echo "pinodexmr:PiNodeXMR" | sudo chpasswd
echo -e "\e[32mpinodexmr password changed to 'PiNodeXMR'\e[0m"
sleep 3

##Replace file /etc/sudoers to set global sudo permissions/rules
echo -e "\e[32mDownload and replace /etc/sudoers file\e[0m"
sleep 3
wget https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/ubuntuServer-20.04/etc/sudoers
sudo chmod 0440 ~/sudoers
sudo chown root ~/sudoers
sudo mv ~/sudoers /etc/sudoers
echo -e "\e[32mGlobal permissions changed\e[0m"
sleep 3

##Change system hostname to PiNodeXMR
echo -e "\e[32mChanging system hostname to 'PiNodeXMR'\e[0m"
sleep 3
echo 'PiNodeXMR' | sudo tee /etc/hostname
#sudo sed -i '6d' /etc/hosts
echo '127.0.0.1       PiNodeXMR' | sudo tee -a /etc/hosts
sudo hostname PiNodeXMR

##Disable IPv6 (confuses Monero start script if IPv6 is present)
echo -e "\e[32mDisable IPv6\e[0m"
sleep 3
echo 'net.ipv6.conf.all.disable_ipv6 = 1' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.default.disable_ipv6 = 1' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.lo.disable_ipv6 = 1' | sudo tee -a /etc/sysctl.conf

#Download stage 2 Install script
echo -e "\e[32mDownloading stage 2 Installer script\e[0m"
sleep 3
wget https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/ubuntuServer-20.04/ubuntu-install-continue.sh
sudo mv ~/ubuntu-install-continue.sh /home/pinodexmr/
sudo chown pinodexmr /home/pinodexmr/ubuntu-install-continue.sh
sudo chmod 755 /home/pinodexmr/ubuntu-install-continue.sh

##make script run when user logs in
echo '. /home/pinodexmr/ubuntu-install-continue.sh' | sudo tee -a /home/pinodexmr/.profile

whiptail --title "PiNode-XMR Continue Install" --msgbox "I've installed everything I can as user 'root'\n\nThe system now requires a reboot for changes to be made, allow 5 minutes then login as 'pinodexmr'\n\nSelect ok to continue with reboot" 16 60

echo -e "\e[32m****************************************\e[0m"
echo -e "\e[32m****************************************\e[0m"
echo -e "\e[32m**********PiNode-XMR rebooting**********\e[0m"
echo -e "\e[32m**********Reminder:*********************\e[0m"
echo -e "\e[32m**********User: 'pinodexmr'*************\e[0m"
echo -e "\e[32m****************************************\e[0m"
echo -e "\e[32m****************************************\e[0m"
sudo reboot

else
exit 0
fi



