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

#Output onion address
sudo cat /var/lib/tor/hidden_service/hostname > /var/www/html/onion-address.txt

##Start torrc hashed control password config

# use temp file 
_temp="./dialog.$$"

#tor Password - set


	whiptail --title "PiNode-XMR tor password config" --passwordbox "\nPassword must be at least 8 standard characters" 12 45 2>$_temp
	#convert plain text to tor hash 1
	NEWTORHASHp1=$(cat $_temp)
    shred $_temp 
	


    # ask user for new tor control password (second time)
	whiptail --title "PiNode-XMR tor password config" --passwordbox "Re-Enter Password" 16 45 2>$_temp
	#convert plain text to tor hash 2
	NEWTORHASHp2=$(cat $_temp)
    shred $_temp 

    # check if passwords match
    if [ "${NEWTORHASHp1}" != "${NEWTORHASHp2}" ]; then
      whiptail --title "PiNode-XMR tor password config" --msgbox "FAIL -> Passwords dont Match\nPlease try again ..." 16 45
	  ./setupMenuScripts/setup-password-tor-hashedcontrol.sh
	  exit 1
    fi
		  
	# password zero
    if [ ${#NEWTORHASHp1} -eq 0 ]; then
      whiptail --title "PiNode-XMR tor password config" --msgbox "FAIL -> Password cannot be empty\nPlease try again ..." 16 45
	  ./setupMenuScripts/setup-password-tor-hashedcontrol.sh
      exit 1
    fi
	
	# check that password does not contain bad characters
    clearedResult=$(echo "${NEWTORHASHp1}" | tr -dc '[:alnum:]-.' | tr -d ' ')
    if [ ${#clearedResult} != ${#NEWTORHASHp1} ] || [ ${#clearedResult} -eq 0 ]; then
      whiptail --title "PiNode-XMR tor password config" --msgbox "FAIL -> Contains bad characters (spaces, special chars)\nPlease try again ..." 16 45
      ./setupMenuScripts/setup-password-tor-hashedcontrol.sh
      exit 1
    fi
	
	# password longer than 8
    if [ ${#NEWTORHASHp1} -lt 8 ]; then
      whiptail --title "PiNode-XMR tor password config" --msgbox "FAIL -> Password length under 8\nPlease try again ..." 16 45
      ./setupMenuScripts/setup-password-tor-hashedcontrol.sh
      exit 1
    fi
	
    exitstatus=$?

	if [ $exitstatus = 0 ]; then
# New verified password
TORHASH="$(tor --hash-password $NEWTORHASHp1)"
#Set new tor hahsedcontrol Password to /etc/tor/torrc

sudo sed -i "59s/.*/HashedControlPassword $TORHASH/" /etc/tor/torrc
sudo systemctl restart tor

	whiptail \
	--title "PiNode-XMR tor password config" --msgbox "New tor Password set." 10 30
	else
	./setup.sh
	fi
fi
./setup.sh

#End Assist User
###
