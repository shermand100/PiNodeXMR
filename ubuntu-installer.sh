#!/bin/bash

##Open Sources:
# Web-UI by designmodo Flat-UI free project at https://github.com/designmodo/Flat-UI
# Monero github https://github.com/moneroexamples/monero-compilation/blob/master/README.md
# Monero Blockchain Explorer https://github.com/moneroexamples/onion-monero-blockchain-explorer
# Nanode scripts and custom files at my repo https://github.com/shermand100/pinode-xmr
# PiVPN - OpenVPN server setup https://github.com/pivpn/pivpn

#Welcome
if (whiptail --title "Nanode Ubuntu Installer" --yesno "To install Nanode using this installer the following condition is required\n\n* You are logged in as user 'pi' or 'ubuntu'\n* Would you like to continue?" 12 60); then

whiptail --title "Nanode Ubuntu Installer" --msgbox "Thanks for confirming\n\nPermissions and Hostnames will now be configured, this will only take a few seconds.\n\nOnce complete your Username will be 'nanode' with Password 'Nanode'" 12 78


##Create new user 'nanode'
sudo adduser nanode --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password

#Set nanode password 'Nanode'
echo "nanode:Nanode" | sudo chpasswd
echo -e "\e[32mnanode password changed to 'Nanode'\e[0m"

##Replace file /etc/sudoers to set global sudo permissions/rules
echo -e "\e[32mDownload and replace /etc/sudoers file\e[0m"
wget https://raw.githubusercontent.com/monero-ecosystem/Nanode/ubuntuServer-20.04/etc/sudoers
sudo chmod 0440 ~/sudoers
sudo chown root ~/sudoers
sudo mv ~/sudoers /etc/sudoers
echo -e "\e[32mGlobal permissions changed\e[0m"

##Change system hostname to Nanode
echo -e "\e[32mChanging system hostname to 'Nanode'\e[0m"
echo 'Nanode' | sudo tee /etc/hostname
#sudo sed -i '6d' /etc/hosts
echo '127.0.0.1       Nanode' | sudo tee -a /etc/hosts
sudo hostname Nanode

##Disable IPv6 (confuses Monero start script if IPv6 is present)
echo -e "\e[32mDisable IPv6\e[0m"
echo 'net.ipv6.conf.all.disable_ipv6 = 1' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.default.disable_ipv6 = 1' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.lo.disable_ipv6 = 1' | sudo tee -a /etc/sysctl.conf

##Perform system update and upgrade now. This then allows for reboot before next install step, preventing warnings about kernal upgrades when installing the new packages (dependencies).
#setup debug file to track errors
echo -e "\e[32mCreate Debug log\e[0m"
sudo touch /home/nanode/debug.log
sudo chown nanode /home/nanode/debug.log
sudo chmod 777 /home/nanode/debug.log

##Update and Upgrade system
echo -e "\e[32mReceiving and applying Ubuntu updates to latest versions\e[0m"
sudo apt-get update 2>&1 | tee -a /home/nanode/debug.log
sudo apt-get --yes -o Dpkg::Options::="--force-confnew" upgrade 2>&1 | tee -a /home/nanode/debug.log
sudo apt-get --yes -o Dpkg::Options::="--force-confnew" dist-upgrade 2>&1 | tee -a /home/nanode/debug.log
sudo apt-get upgrade -y 2>&1 | tee -a /home/nanode/debug.log

##Auto remove any obsolete packages
sudo apt-get autoremove -y 2>&1 | tee -a /home/nanode/debug.log

#Download stage 2 Install script
echo -e "\e[32mDownloading stage 2 Installer script\e[0m"
wget https://raw.githubusercontent.com/monero-ecosystem/Nanode/ubuntuServer-20.04/ubuntu-install-continue.sh
sudo mv ~/ubuntu-install-continue.sh /home/nanode/
sudo chown nanode /home/nanode/ubuntu-install-continue.sh
sudo chmod 755 /home/nanode/ubuntu-install-continue.sh

##make script run when user logs in
echo '. /home/nanode/ubuntu-install-continue.sh' | sudo tee -a /home/nanode/.profile

whiptail --title "Nanode Continue Install" --msgbox "I've installed everything I can as the default user\n\nThe system now requires a reboot for changes to be made, allow 5 minutes then login as 'nanode'\n\nSelect ok to continue with reboot" 16 60

echo -e "\e[32m****************************************\e[0m"
echo -e "\e[32m****************************************\e[0m"
echo -e "\e[32m**********Nanode rebooting**********\e[0m"
echo -e "\e[32m**********Reminder:*********************\e[0m"
echo -e "\e[32m**********User: 'nanode'*************\e[0m"
echo -e "\e[32m**********Password: 'Nanode'*********\e[0m"
echo -e "\e[32m****************************************\e[0m"
echo -e "\e[32m****************************************\e[0m"
sudo reboot

else
exit 0
fi



