#!/bin/bash
##Start password config

# use temp file 
_temp="./dialog.$$"

#Load menu status - to track setup progress - will be re-called throughout and allows user to only re-do one section on input error rather than whole script.
. /home/pinodexmr/setupstatus.sh

if [ $SETUP_STATUS -eq 0 ]; then
whiptail --title "PiNode-XMR Setup 1/4" --msgbox "First we'll set your master password for logging onto here." 16 60
	
	echo "#!/bin/sh
SETUP_STATUS=1" > /home/pinodexmr/setupstatus.sh

fi

#Load menu status - to track setup progress - will be re-called throughout
. /home/pinodexmr/setupstatus.sh

if [ $SETUP_STATUS -eq 1 ]; then

whiptail --passwordbox "Choose your new root/pinodexmr/SSH\npassword and choose Ok to continue.\n\nPassword must be at least 8 standard characters" --title "PiNode-XMR Setup 1/4" 16 60 2>$_temp

    # get user input
    password1=$( cat $_temp )
    shred $_temp 

    # ask user for new password A (second time)
		whiptail --passwordbox "Re-Enter Password" --title "PiNode-XMR Setup 1/4" 16 60 2>$_temp
		
	       # get user input
			password2=$( cat $_temp )
			shred $_temp

    # check if passwords match
    if [ "${password1}" != "${password2}" ]; then
      whiptail --title "FAIL -> Passwords don't Match" --msgbox "FAIL -> Passwords don't Match\nPlease try again ..." 16 45
	./setup-passwords.sh
	  exit 1
    fi
	# password zero
    if [ ${#password1} -eq 0 ]; then
      whiptail --title "FAIL -> Password cannot be empty" --msgbox "FAIL -> Password cannot be empty\nPlease try again ..." 16 45
	  ./setup-passwords.sh
      exit 1
    fi
	# check that password does not contain bad characters
    clearedResult=$(echo "${password1}" | tr -dc '[:alnum:]-.' | tr -d ' ')
    if [ ${#clearedResult} != ${#password1} ] || [ ${#clearedResult} -eq 0 ]; then
      whiptail --title "FAIL -> Contains bad characters (spaces, special chars)" --msgbox "FAIL -> Contains bad characters (spaces, special chars)\nPlease try again ..." 16 45
    ./setup-passwords.sh
      exit 1
    fi
	# password longer than 8
    if [ ${#password1} -lt 8 ]; then
      whiptail --title "FAIL -> Password length under 8" --msgbox "FAIL -> Password length under 8\nPlease try again ..." 16 45
      ./setup-passwords.sh
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
	whiptail --title "PiNode-XMR Setup 1/4" --msgbox "New Password set for root/SSH & user:\n\npinodexmr" 16 45
	else
		echo "#!/bin/sh
SETUP_STATUS=0" > /home/pinodexmr/setupstatus.sh
	./setup.sh
	fi
			
	echo "#!/bin/sh
SETUP_STATUS=2" > /home/pinodexmr/setupstatus.sh
fi

whiptail --clear

#Load menu status - to track setup progress - will be re-called throughout
. /home/pinodexmr/setupstatus.sh

#RPC Username:Password config

#Page 3/?
if [ $SETUP_STATUS -eq 2 ]; then

	whiptail --title "PiNode-XMR Setup 2/4" --msgbox "Now set your Monero RPC Username and Password\n\nYou use these to connect a wallet to your node from another device (for example as a remote node in the Monero GUI or a mobile device) " 16 45 
	
	#RPC Username - set
	whiptail --title "PiNode-XMR Setup 2/4" --inputbox "New Username:" 10 60 2>$_temp
		
	       # get user input
			NEWRPCu=$( cat $_temp )
			shred $_temp
 
	exitstatus=$?
	if [ $exitstatus = 0 ]; then
	echo "#!/bin/sh
RPCu=${NEWRPCu}" > /home/pinodexmr/RPCu.sh
	whiptail --title "PiNode-XMR Setup 2/4" --msgbox "New RPC Username set:\n\n ${NEWRPCu}" 10 30
	else
    echo "You chose Cancel."
	fi
	
	echo "#!/bin/sh
SETUP_STATUS=3" > /home/pinodexmr/setupstatus.sh
fi

dialog --clear

#Load menu status - to track setup progress - will be re-called throughout
. /home/pinodexmr/setupstatus.sh

#RPC Password - set

if [ $SETUP_STATUS -eq 3 ]; then

	whiptail --title "PiNode-XMR Setup 2/4" --passwordbox "Choose your new external connection (RPC) password and choose Ok to continue.\n\nPassword must be at least 8 standard characters" 12 45 2>$_temp

    # get user input
    NEWRPCp1=$( cat $_temp )
    shred $_temp 
	
whiptail --clear

    # ask user for new RPCp (second time)
		whiptail --title "PiNode-XMR Setup 2/4" --passwordbox "Re-Enter Password" 16 45 2>$_temp
		
	       # get user input
			NEWRPCp2=$( cat $_temp )
			shred $_temp

    # check if passwords match
    if [ "${NEWRPCp1}" != "${NEWRPCp2}" ]; then
      whiptail --title "PiNode-XMR - RPC Password" --msgbox "FAIL -> Passwords dont Match\nPlease try again ..." 16 45
	  ./setup-passwords.sh
	  exit 1
    fi
	
whiptail --clear
	  
	# password zero
    if [ ${#NEWRPCp1} -eq 0 ]; then
      whiptail --title "PiNode-XMR - RPC Password" --msgbox "FAIL -> Password cannot be empty\nPlease try again ..." 16 45
	  ./setup-passwords.sh
      exit 1
    fi
	# check that password does not contain bad characters
    clearedResult=$(echo "${NEWRPCp1}" | tr -dc '[:alnum:]-.' | tr -d ' ')
    if [ ${#clearedResult} != ${#NEWRPCp1} ] || [ ${#clearedResult} -eq 0 ]; then
      whiptail --title "PiNode-XMR - RPC Password" --msgbox "FAIL -> Contains bad characters (spaces, special chars)\nPlease try again ..." 16 45
    ./setup-passwords.sh
      exit 1
    fi
	
	# password longer than 8
    if [ ${#NEWRPCp1} -lt 8 ]; then
      whiptail \
	  --title "PiNode-XMR - RPC Password" --msgbox "FAIL -> Password length under 8\nPlease try again ..." 16 45
      ./setup-passwords.sh
      exit 1
    fi
	

	exitstatus=$?
	
	if [ $exitstatus = 0 ]; then
# New verified password
	NEWRPCp="${NEWRPCp1}"
#Set new RPC Password
	echo "#!/bin/sh
RPCp=${NEWRPCp}" > /home/pinodexmr/RPCp.sh

	dialog --title "PiNode-XMR Setup 2/4" --msgbox "New RPC Password set." 10 30
	else
	./setup-passwords.sh
	fi
	
	echo "#!/bin/sh
SETUP_STATUS=0" > /home/pinodexmr/setupstatus.sh

fi
whiptail --title "PiNode-XMR - RPC Password" --msgbox "The following has been changed;\n\n* pinodexmr & root password\n* RPC username\n* RPC password" 16 45
./setup.sh
