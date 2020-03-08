#!/bin/bash
##Start password config

# use temp file 
_temp="./dialog.$$"


whiptail --title "PiNode-XMR Master Password config" --msgbox "This password is required for SSH connections and the web terminal log in\n\nKeep it safe - without this you cannot access any node settings" 16 60
	

whiptail --passwordbox "Choose your new password and select Ok to continue.\n\nPassword must be at least 8 standard characters" --title "PiNode-XMR Master Password config" 16 60 2>$_temp

    # get user input
    password1=$( cat $_temp )
    shred $_temp 

    # ask user for new password A (second time)
		whiptail --passwordbox "Re-Enter Password" --title "PiNode-XMR Master Password config" 16 60 2>$_temp
		
	       # get user input
			password2=$( cat $_temp )
			shred $_temp

    # check if passwords match
    if [ "${password1}" != "${password2}" ]; then
      whiptail --title "FAIL -> Passwords don't Match" --msgbox "FAIL -> Passwords don't Match\nPlease try again ..." 16 45
	./setup-password-master.sh
	  exit 1
    fi
	# password zero
    if [ ${#password1} -eq 0 ]; then
      whiptail --title "FAIL -> Password cannot be empty" --msgbox "FAIL -> Password cannot be empty\nPlease try again ..." 16 45
	  ./setup-password-master.sh
      exit 1
    fi
	# check that password does not contain bad characters
    clearedResult=$(echo "${password1}" | tr -dc '[:alnum:]-.' | tr -d ' ')
    if [ ${#clearedResult} != ${#password1} ] || [ ${#clearedResult} -eq 0 ]; then
      whiptail --title "FAIL -> Contains bad characters (spaces, special chars)" --msgbox "FAIL -> Contains bad characters (spaces, special chars)\nPlease try again ..." 16 45
    ./setup-password-master.sh
      exit 1
    fi
	# password longer than 8
    if [ ${#password1} -lt 8 ]; then
      whiptail --title "FAIL -> Password length under 8" --msgbox "FAIL -> Password length under 8\nPlease try again ..." 16 45
      ./setup-password-master.sh
      exit 1
    fi
	
		exitstatus=$?
	if [ $exitstatus = 0 ]; then
	# New verified password
	newPassword="${password1}"
	#Set new passwords
	  echo "pinodexmr:$newPassword" | sudo chpasswd
	  echo "root:$newPassword" | sudo chpasswd
	#Set new boot status
	whiptail --title "PiNode-XMR Master Password config" --msgbox "New Master Password set for user:\n\npinodexmr" 16 45
	./setup.sh
	exit 1
	else
    echo "You chose Cancel."
	sleep 2
	./setup
	exit 1
	fi
	