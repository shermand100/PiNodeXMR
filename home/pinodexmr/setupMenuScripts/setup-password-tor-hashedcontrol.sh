#!/bin/bash
##Start torrc hashed control password config

# use temp file 
_temp="./dialog.$$"

#tor Password - set


	whiptail --title "PiNode-XMR tor password config" --passwordbox "\nPassword must be at least 8 standard characters" 12 45 2>$_temp
	#convert plain text to tor hash 1
	NEWTORHASHp1=$(cat $_temp)
    shred $_temp 
	
whiptail --clear

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
      whiptail \
	  --title "PiNode-XMR tor password config" --msgbox "FAIL -> Password length under 8\nPlease try again ..." 16 45
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

./setup.sh
