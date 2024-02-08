#!/bin/bash

##########
#supportScript #2
#This script's purpose is to be held in the PiNodeXMR online repository so as a dev I can aid a user who has a complex issue or customisiation request.
#It is triggered by the selection of supportScript #2 from the setup menu -> system settings -> support scripts
#3 scripts exist to allow for 3 simultanious support requests, each are independant from each other.
#By default this script will do nothing. Once a support request is completed this script will be reverted to default.
#This script does not persist on any users device (it is deleted at the end of initial install and subsequent updates within the cloned PiNode-XMR dir)
##########

###
#Start Default action below - no actions performed (Comment out as required)
# whiptail --title "PiNode-XMR Support Script #2" --msgbox "This script has not been configured to provide support at this time\n\nNo Actions performed\n\nReturning to Menu" 12 78;
#End Default action 
###

###
#Start Assist User
if (whiptail --title "PiNode-XMR Support Script #1" --yesno "This script will now perform an update of your tor service. \n\n Would you like to continue?" 12 78); then
echo -e "\e[32mFetch repository updates\e[0m"
sleep 3
sudo apt update

echo -e "\e[32mInstall apt-transport-https\e[0m"
sleep 2
sudo apt install apt-transport-https -y

echo -e "\e[32mSet tor sources list\e[0m"
sleep 2

#Establish OS Distribution
DIST="$(lsb_release -c | awk '{print $2}')"

#Set apt sources to retrieve tor official repository (Print to temp file)
echo "deb     [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org $DIST main
deb-src [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org $DIST main" > ~/temp_torSources.list

#Overwrite tor.list with new created temp file above.
sudo mv ~/temp_torSources.list /etc/apt/sources.list.d/tor.list

echo -e "\e[32mSet tor pgp keys\e[0m"
sleep 2
# #add the gpg key used to sign the packages
sudo wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor | sudo tee /usr/share/keyrings/tor-archive-keyring.gpg >/dev/null

echo -e "\e[32mCheck for new tor version\e[0m"
sleep 2
# #Install tor and tor debian keyring (keeps signing keys current)
sudo apt update
echo -e "\e[32mInstall tor debian keyring (keeps signing keys current)\e[0m"
sleep 2
sudo apt install deb.torproject.org-keyring
# #upgrade below will get latest tor if already installed.
echo -e "\e[32mUpdate tor\e[0m"
sleep 2
sudo apt upgrade -y
whiptail --title "tor update complete" --msgbox "Latest tor update has been completed \n\nSelect ok to return to menu" 16 60

else
    sleep 2
fi
#End Assist User
###