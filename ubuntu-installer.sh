#!/bin/bash

##Open Sources:
# Monero github https://github.com/moneroexamples/monero-compilation/blob/master/README.md
# Monero Blockchain Explorer https://github.com/moneroexamples/onion-monero-blockchain-explorer
# PiNode-XMR scripts and custom files at my repo https://github.com/shermand100/pinode-xmr
# PiVPN - OpenVPN server setup https://github.com/pivpn/pivpn
# Atomic Swaps - https://github.com/AthanorLabs/atomic-swap
# P2Pool - https://github.com/SChernykh/p2pool
# ATS Fan controller - https://github.com/tuxd3v/ats#credits

#Welcome
if (whiptail --title "PiNode-XMR Ubuntu Installer" --yesno "To install PiNodeXMR using this installer the following condition is required\n\n* You are logged in as user 'pi' or 'ubuntu'\n* Would you like to continue?" 12 60); then

whiptail --title "PiNode-XMR Ubuntu Installer" --msgbox "Thanks for confirming\n\nPermissions and Hostnames will now be configured, this will only take a few seconds.\n\nOnce complete your Username will be 'pinodexmr' with Password 'PiNodeXMR'" 12 78

##Create new user 'pinodexmr'
sudo adduser pinodexmr --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password

#Set pinodexmr password 'PiNodeXMR'
echo "pinodexmr:PiNodeXMR" | sudo chpasswd
echo -e "\e[32mpinodexmr password changed to 'PiNodeXMR'\e[0m"
sleep 3

##Replace file /etc/sudoers to set global sudo permissions/rules
echo -e "\e[32mDownload and replace /etc/sudoers file\e[0m"
sleep 3
wget https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/etc/sudoers
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

##Perform system update and upgrade now. This then allows for reboot before next install step, preventing warnings about kernal upgrades when installing the new packages (dependencies).
#setup debug file to track errors
echo -e "\e[32mCreate Debug log\e[0m"
sudo touch /home/pinodexmr/debug.log
sudo chown pinodexmr /home/pinodexmr/debug.log
sudo chmod 777 /home/pinodexmr/debug.log
sleep 1

##Update and Upgrade system
echo -e "\e[32mReceiving and applying Ubuntu updates to latest versions\e[0m"
sleep 3
sudo apt-get update 2>&1 | tee -a /home/pinodexmr/debug.log
sudo apt-get --yes -o Dpkg::Options::="--force-confnew" upgrade 2>&1 | tee -a /home/pinodexmr/debug.log
sudo apt-get --yes -o Dpkg::Options::="--force-confnew" dist-upgrade 2>&1 | tee -a /home/pinodexmr/debug.log
sudo apt-get upgrade -y 2>&1 | tee -a /home/pinodexmr/debug.log

##Auto remove any obsolete packages
sudo apt-get autoremove -y 2>&1 | tee -a /home/pinodexmr/debug.log

#Download stage 2 Install script
echo -e "\e[32mDownloading stage 2 Installer script\e[0m"
sleep 3
wget https://raw.githubusercontent.com/shermand100/PiNodeXMR/master/ubuntu-install-continue.sh
sudo mv ~/ubuntu-install-continue.sh /home/pinodexmr/
sudo chown pinodexmr /home/pinodexmr/ubuntu-install-continue.sh
sudo chmod 755 /home/pinodexmr/ubuntu-install-continue.sh

##make script run when user logs in
echo '. /home/pinodexmr/ubuntu-install-continue.sh' | sudo tee -a /home/pinodexmr/.profile

whiptail --title "PiNode-XMR Continue Install" --msgbox "I've installed everything I can as the default user\n\nThe system now requires a reboot for changes to be made, allow 5 minutes then login as 'pinodexmr'\n\nSelect ok to continue with reboot" 16 60

echo -e "\e[32m****************************************\e[0m"
echo -e "\e[32m****************************************\e[0m"
echo -e "\e[32m**********PiNode-XMR rebooting**********\e[0m"
echo -e "\e[32m**********Reminder:*********************\e[0m"
echo -e "\e[32m**********User: 'pinodexmr'*************\e[0m"
echo -e "\e[32m**********Password: 'PiNodeXMR'*********\e[0m"
echo -e "\e[32m****************************************\e[0m"
echo -e "\e[32m****************************************\e[0m"
sudo reboot

else
exit 0
fi



