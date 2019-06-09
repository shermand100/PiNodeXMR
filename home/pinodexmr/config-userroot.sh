#!/bin/bash

#Load boot status - has node run before?
. /home/pinodexmr/bootstatus.sh
# Insert here condition to run this script at set checkpoint
if [ $BOOT_STATUS -gt 1 ]
then
dialog \
    --title "PiNode-XMR Setup" \
    --msgbox "Welcome to your private node.\n\nThis menu will allow you to configure your passwords and other features allowing secure external connections." 12 45

# tempfile 
_temp="./dialog.$$"

#Page 2/?
dialog --insecure --title "Set New Device Password" --passwordbox "Choose your new root/pinodexmr/SSH password and choose Ok to continue.\n\nPassword must be at least 8 standard characters" 12 45 2>$_temp

    # get user input
    password1=$( cat $_temp )
    shred $_temp 

    # ask user for new password A (second time)
		dialog --title 'PiNode-XMR - Set Device Password' --insecure --passwordbox "Re-Enter Password" 6 45 2>$_temp
		
	       # get user input
			password2=$( cat $_temp )
			shred $_temp

    # check if passwords match
    if [ "${password1}" != "${password2}" ]; then
      dialog --title "PiNode-XMR - Set Device Password" --msgbox "FAIL -> Passwords dont Match\nPlease try again ..." 6 45
	  ./dialog.sh
	  exit 1
    fi

	  
	# password zero
    if [ ${#password1} -eq 0 ]; then
      dialog --title "PiNode-XMR - Set Device Password" --msgbox "FAIL -> Password cannot be empty\nPlease try again ..." 6 45
	  ./dialog.sh
      exit 1
    fi
	# check that password does not contain bad characters
    clearedResult=$(echo "${password1}" | tr -dc '[:alnum:]-.' | tr -d ' ')
    if [ ${#clearedResult} != ${#password1} ] || [ ${#clearedResult} -eq 0 ]; then
      dialog --title "PiNode-XMR - Set Device Password" --msgbox "FAIL -> Contains bad characters (spaces, special chars)\nPlease try again ..." 6 45
    ./dialog.sh
      exit 1
    fi
	
	# password longer than 8
    if [ ${#password1} -lt 8 ]; then
      dialog --title "RaspiBlitz - Set Device Password" --msgbox "FAIL -> Password length under 8\nPlease try again ..." 6 45
      ./dialog.sh
      exit 1
    fi
	
	
	exitstatus=$?
	if [ $exitstatus = 0 ]; then
	# New verified password
	newPassword="${password1}"
	##Set new passwords
	#  echo "pinodexmr:$newPassword" | sudo chpasswd
	#  echo "root:$newPassword" | sudo chpasswd
	#Set new boot status - Password 1 set complete
	echo "#!/bin/sh
	BOOT_STATUS=3" > /home/pinodexmr/bootstatus.sh
	dialog --infobox "New Password set for root/SSH & user: pinodexmr" 10 30 ; sleep 3
	else
	./dialog.sh
	sleep "1"
	fi
fi	
. /home/pinodexmr/config-rpcuser.sh