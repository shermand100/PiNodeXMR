#!/bin/bash

##Open Sources:
# Web-UI by designmodo Flat-UI free project at https://github.com/designmodo/Flat-UI
# Monero github https://github.com/moneroexamples/monero-compilation/blob/master/README.md
# Monero Blockchain Explorer https://github.com/moneroexamples/onion-monero-blockchain-explorer
# Nanode scripts and custom files at my repo https://github.com/shermand100/pinode-xmr
# PiVPN - OpenVPN server setup https://github.com/pivpn/pivpn

#shellcheck source=./common.sh
. ./common.sh

#Welcome
if (whiptail --title "Nanode Ubuntu Installer" --yesno "To install Nanode using this installer the following condition is required\n\n* You are logged in as user 'pi' or 'ubuntu'\n* Would you like to continue?" 12 60); then

whiptail --title "Nanode Ubuntu Installer" --msgbox "Thanks for confirming\n\nPermissions and Hostnames will now be configured, this will only take a few seconds.\n\nOnce complete your Username will be 'nanode' with Password 'Nanode'" 12 78

##Create new user 'nanode'
sudo adduser nanode --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password

#Set nanode password 'Nanode'
echo "nanode:Nanode" | sudo chpasswd
showtext "nanode password changed to 'Nanode'"

##Replace file /etc/sudoers to set global sudo permissions/rules
showtext "Download and replace /etc/sudoers file"
#FIXME: change url
wget https://raw.githubusercontent.com/monero-ecosystem/Nanode/ubuntuServer-20.04/etc/sudoers
sudo chmod 0440 ~/sudoers
sudo chown root ~/sudoers
sudo mv ~/sudoers /etc/sudoers
showtext "Global permissions changed"

##Change system hostname to Nanode
showtext "Changing system hostname to 'Nanode'"
echo 'Nanode' | sudo tee /etc/hostname
#sudo sed -i '6d' /etc/hosts
echo '127.0.0.1       Nanode' | sudo tee -a /etc/hosts
sudo hostname Nanode

##Disable IPv6 (confuses Monero start script if IPv6 is present)
showtext "Disable IPv6"
echo 'net.ipv6.conf.all.disable_ipv6 = 1' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.default.disable_ipv6 = 1' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.lo.disable_ipv6 = 1' | sudo tee -a /etc/sysctl.conf

##Perform system update and upgrade now. This then allows for reboot before next install step, preventing warnings about kernal upgrades when installing the new packages (dependencies).
#setup debug file to track errors
showtext "Create Debug log"
sudo touch "$DEBUG_LOG"
sudo chown nanode "$DEBUG_LOG"
sudo chmod 777 "$DEBUG_LOG"

##Update and Upgrade system
showtext "Receiving and applying Ubuntu updates to latest version"
{
sudo apt-get update
sudo apt-get --yes -o Dpkg::Options::="--force-confnew" upgrade
sudo apt-get --yes -o Dpkg::Options::="--force-confnew" dist-upgrade
sudo apt-get upgrade -y
##Auto remove any obsolete packages
sudo apt-get autoremove -y 2>&1 | tee -a "$DEBUG_LOG"
} 2>&1 | tee -a "$DEBUG_LOG"

#Download stage 2 Install script
showtext "Downloading stage 2 Installer script"
#FIXME: change url
wget https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/ubuntuServer-20.04/ubuntu-install-continue.sh
sudo mv ~/ubuntu-install-continue.sh /home/nanode/
sudo chown nanode /home/nanode/ubuntu-install-continue.sh
sudo chmod 755 /home/nanode/ubuntu-install-continue.sh

##make script run when user logs in
echo '. /home/nanode/ubuntu-install-continue.sh' | sudo tee -a /home/nanode/.profile

whiptail --title "Nanode Continue Install" --msgbox "I've installed everything I can as the default user\n\nThe system now requires a reboot for changes to be made, allow 5 minutes then login as 'nanode'\n\nSelect ok to continue with reboot" 16 60

showtext \
	"****************************************
	****************************************
	**********Nanode rebooting**************
	**********Reminder:*********************
	**********User: 'nanode'****************
	**********Password: 'Nanode'************
	****************************************
	****************************************"

sleep 3
sudo reboot

else
exit 0
fi



