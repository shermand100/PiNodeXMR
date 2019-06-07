#!/bin/bash

#Load boot status - has node run before?
. /home/pinodexmr/bootstatus.sh
# Insert here condition to run this script at set checkpoint
if [ $BOOT_STATUS -eq 2 ]
then
##To be completed##

#Page 1/?
dialog \
    --title "PiNode-XMR Setup" \
    --msgbox "Welcome to your private node.\n\nThis menu will allow you to configure your passwords and other features allowing secure external conections." 12 45

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


#RPC Username:Password config - msg
dialog \
    --title "PiNode-XMR Setup" \
    --msgbox "Now set your Monero RPC Username and Password\n\nYou use these to connect to your node externally (for example as a remote node in the GUI or a mobile device) " 12 45 
#RPC Username - set
dialog --title "PiNode-XMR RPC Username" --inputbox "New Username: " 10 60 2>$_temp
		
	       # get user input
			NEWRPCu=$( cat $_temp )
			shred $_temp
 
exitstatus=$?
if [ $exitstatus = 0 ]; then
##	echo "#!/bin/sh
##RPCu=${NEWRPCu}" > /home/pinodexmr/RPCu.sh
echo "Uncomment commands to activate before release"
dialog --infobox "New RPC Username set: ${NEWRPCu}" 10 30 ; sleep 3
else
    echo "You chose Cancel."
fi
#RPC Password - set
dialog --insecure --title "PiNode-XMR RPC Password" --passwordbox "Choose your new external connection (RPC) password and choose Ok to continue.\n\nPassword must be at least 8 standard characters" 12 45 2>$_temp

    # get user input
    NEWRPCp1=$( cat $_temp )
    shred $_temp 

    # ask user for new RPCp (second time)
		dialog --title 'PiNode-XMR - RPC Password' --insecure --passwordbox "Re-Enter Password" 6 45 2>$_temp
		
	       # get user input
			NEWRPCp2=$( cat $_temp )
			shred $_temp

    # check if passwords match
    if [ "${NEWRPCp1}" != "${NEWRPCp2}" ]; then
      dialog --title "PiNode-XMR - RPC Password" --msgbox "FAIL -> Passwords dont Match\nPlease try again ..." 6 45
	  ./dialog.sh
	  exit 1
    fi

	  
	# password zero
    if [ ${#NEWRPCp1} -eq 0 ]; then
      dialog --title "PiNode-XMR - RPC Password" --msgbox "FAIL -> Password cannot be empty\nPlease try again ..." 6 45
	  ./dialog.sh
      exit 1
    fi
	# check that password does not contain bad characters
    clearedResult=$(echo "${NEWRPCp1}" | tr -dc '[:alnum:]-.' | tr -d ' ')
    if [ ${#clearedResult} != ${#NEWRPCp1} ] || [ ${#clearedResult} -eq 0 ]; then
      dialog --title "PiNode-XMR - RPC Password" --msgbox "FAIL -> Contains bad characters (spaces, special chars)\nPlease try again ..." 6 45
    ./dialog.sh
      exit 1
    fi
	
	# password longer than 8
    if [ ${#NEWRPCp1} -lt 8 ]; then
      dialog --title "RaspiBlitz - RPC Password" --msgbox "FAIL -> Password length under 8\nPlease try again ..." 6 45
      ./dialog.sh
      exit 1
    fi
	
	
exitstatus=$?
if [ $exitstatus = 0 ]; then
# New verified password
NEWRPCp="${NEWRPCp1}"
##Set new RPC Password
##	echo "#!/bin/sh
##RPCp=${NEWRPCp}" > /home/pinodexmr/RPCp.sh
echo "Uncomment commands to activate before release"
dialog --infobox "New RPC Password set." 10 30 ; sleep 3
fi

#Menu for configuration of Dynamic DNS service
HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Set up Dynamic DNS"
TITLE="PiNode-XMR"
MENU="Choose one of the following services:"

OPTIONS=(1 "NOIP.com"
         2 "DuckDNS.org"
         3 "Skip this Step")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
			dialog \
    --title "NO-IP.com auto-setup" \
    --msgbox "You will need a no-ip.com username and login before configuring your PiNode-XMR\n\nRegister on their site before continuing.\nOnce you have registered select 'ok'\n(A client will be downloaded to send updates to NO-IP.com DNS register)" 12 45
			sudo -- sh -c 'cd /usr/local/src/ && wget http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz && tar xf noip-duc-linux.tar.gz && cd noip-2.1.9-1/ && make install && /usr/local/bin/noip2 -C && /usr/local/bin/noip2'
            echo "Dynamic DNS configured - NO-IP.com"
            ;;
        2)
					dialog \
    --title "DuckDNS.org auto-setup" \
    --msgbox "" 12 45
			sudo -- sh -c ''
            echo "Dynamic DNS configured - DuckDNS.org"
            echo "You chose Option 2"
            ;;
        3)
            echo "You chose Option 3"
            ;;
esac