#!/bin/bash

##Open Sources:
# Web-UI by designmodo Flat-UI free project at https://github.com/designmodo/Flat-UI
# Monero github https://github.com/moneroexamples/monero-compilation/blob/master/README.md
# Monero Blockchain Explorer https://github.com/moneroexamples/onion-monero-blockchain-explorer
# PiNode-XMR scripts and custom files at my repo https://github.com/shermand100/pinode-xmr
# PiVPN - OpenVPN server setup https://github.com/pivpn/pivpn

#Welcome
if (whiptail --title "PiNode-XMR Armbian Installer" --yesno "To install PiNodeXMR using this installer the following conditions are required\n\n* You have logged in as 'root'\n* You created a user called 'pinodexmr'\n* You are still logged in as 'root' now\n\nWould you like to continue?" 12 60); then

whiptail --title "PiNode-XMR Armbian Installer" --msgbox "Thanks for confirming\n\nPermissions and Hostnames will now be configured, this will only take a few seconds." 12 78


##Replace file /etc/sudoers to set global sudo permissions/rules
echo -e "\e[32mDownload and replace /etc/sudoers file\e[0m"
sleep 3
wget https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/Armbian-install/etc/sudoers
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

##ZRAM Optimizations to improve system responsiveness and performance
# I don't tiptoe around the crypto they said I smoking endo
# it's a gaffe but I got the last laugh despite all the 
# wining and dining for us to be dining - ChiefGyk3D
echo "vm.vfs_cache_pressure=500" | sudo tee -a /etc/sysctl.conf
echo "vm.dirty_background_ratio=1" | sudo tee -a /etc/sysctl.conf
echo "vm.dirty_ratio=50" | sudo tee -a /etc/sysctl.conf
# Lock and load the settings
sudo sysctl -p

#Download stage 2 Install script
echo -e "\e[32mDownloading stage 2 Installer script\e[0m"
sleep 3
wget https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/Armbian-install/armbian-install-continue.sh
sudo mv /root/armbian-install-continue.sh /home/pinodexmr/
sudo chown pinodexmr /home/pinodexmr/armbian-install-continue.sh
sudo chmod 755 /home/pinodexmr/armbian-install-continue.sh

##make script run when user logs in
echo '. /home/pinodexmr/armbian-install-continue.sh' | sudo tee -a /home/pinodexmr/.profile

##Configure Swap file if needed
if (whiptail --title "PiNode-XMR Armbian Installer" --yesno "For Monero to compile successfully 2GB of RAM is required.\n\nIf your device does not have 2GB RAM it can be artificially created with a swap file\n\nDo you have 2GB RAM on this device?\n\n* YES\n* NO - I do not have 2GB RAM (create a swap file)" 18 60); then
	echo -e "\e[32mSwap file unchanged\e[0m"
	sleep 3
		else
			echo -e "\e[32mConfiguring 2GB Swap file (required for Monero build)\e[0m"
			yes n | sudo apt install dphys-swapfile -y
			sleep 3
			wget https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/Armbian-install/etc/dphys-swapfile
			sudo mv /root/dphys-swapfile /etc/dphys-swapfile
			sudo chmod 664 /etc/dphys-swapfile
			sudo chown root /etc/dphys-swapfile
			sudo dphys-swapfile setup
			sleep 5
			sudo dphys-swapfile swapon
			echo -e "\e[32mSwap file of 2GB Configured and enabled\e[0m"
			sleep 3
fi

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



