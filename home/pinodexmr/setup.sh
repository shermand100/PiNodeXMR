#!/bin/bash


# use temp file 
_temp="./dialog.$$"

#Load menu status - to track setup progress - will be re-called throughout
. /home/pinodexmr/setupstatus.sh


if [ $SETUP_STATUS -eq 0 ]; then
dialog --title "PiNode-XMR Setup 1/3" --msgbox "Welcome to your private node.\n\nThis menu will allow you to configure your passwords and user name for securing your device and allowing secure external connections." 12 45
	echo "#!/bin/sh
SETUP_STATUS=1" > /home/pinodexmr/setupstatus.sh
fi

dialog --clear

#Load menu status - to track setup progress - will be re-called throughout
. /home/pinodexmr/setupstatus.sh

if [ $SETUP_STATUS -eq 1 ]; then
dialog --insecure --title "PiNode-XMR Setup 1/3" --passwordbox "Choose your new root/pinodexmr/SSH password and choose Ok to continue.\n\nPassword must be at least 8 standard characters" 12 45 2>$_temp

    # get user input
    password1=$( cat $_temp )
    shred $_temp 

    # ask user for new password A (second time)
		dialog --title "PiNode-XMR Setup 1/3" --insecure --passwordbox "Re-Enter Password" 6 45 2>$_temp
		
	       # get user input
			password2=$( cat $_temp )
			shred $_temp

    # check if passwords match
    if [ "${password1}" != "${password2}" ]; then
      dialog --title "PiNode-XMR Setup 1/3" --msgbox "FAIL -> Passwords don't Match\nPlease try again ..." 6 45
	./setup.sh
	  exit 1
    fi

	  
	# password zero
    if [ ${#password1} -eq 0 ]; then
      dialog --title "PiNode-XMR Setup 1/3" --msgbox "FAIL -> Password cannot be empty\nPlease try again ..." 6 45
	  ./setup.sh
      exit 1
    fi
	# check that password does not contain bad characters
    clearedResult=$(echo "${password1}" | tr -dc '[:alnum:]-.' | tr -d ' ')
    if [ ${#clearedResult} != ${#password1} ] || [ ${#clearedResult} -eq 0 ]; then
      dialog --title "PiNode-XMR Setup 1/3" --msgbox "FAIL -> Contains bad characters (spaces, special chars)\nPlease try again ..." 6 45
    ./setup.sh
      exit 1
    fi
	
	# password longer than 8
    if [ ${#password1} -lt 8 ]; then
      dialog --title "PiNode-XMR Setup 1/3" --msgbox "FAIL -> Password length under 8\nPlease try again ..." 6 45
      ./setup.sh
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
	dialog --title "PiNode-XMR Setup 1/3" --infobox "New Password set for root/SSH & user:\n\npinodexmr" 6 45 ; sleep 3
	else
	./setup.sh
	fi
			
	echo "#!/bin/sh
SETUP_STATUS=2" > /home/pinodexmr/setupstatus.sh

fi

dialog --clear

#Load menu status - to track setup progress - will be re-called throughout
. /home/pinodexmr/setupstatus.sh

#RPC Username:Password config - msg

#Page 3/?
if [ $SETUP_STATUS -eq 2 ]; then

	dialog \
    --title "PiNode-XMR Setup 2/3" \
    --msgbox "Now set your Monero RPC Username and Password\n\nYou use these to connect to your node externally (for example as a remote node in the GUI or a mobile device) " 12 45 
	
	dialog --clear
	
	#RPC Username - set
	dialog --title "PiNode-XMR Setup 2/3" --inputbox "New Username:" 10 60 2>$_temp
		
	       # get user input
			NEWRPCu=$( cat $_temp )
			shred $_temp
 
	exitstatus=$?
	if [ $exitstatus = 0 ]; then
	echo "#!/bin/sh
RPCu=${NEWRPCu}" > /home/pinodexmr/RPCu.sh
	dialog --title "PiNode-XMR Setup 2/3" --infobox "New RPC Username set:\n\n ${NEWRPCu}" 10 30 ; sleep 3
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

	dialog --insecure --title "PiNode-XMR Setup 3/3" --passwordbox "Choose your new external connection (RPC) password and choose Ok to continue.\n\nPassword must be at least 8 standard characters" 12 45 2>$_temp

    # get user input
    NEWRPCp1=$( cat $_temp )
    shred $_temp 
	
dialog --clear

    # ask user for new RPCp (second time)
		dialog --title "PiNode-XMR Setup 3/3" --insecure --passwordbox "Re-Enter Password" 6 45 2>$_temp
		
	       # get user input
			NEWRPCp2=$( cat $_temp )
			shred $_temp

    # check if passwords match
    if [ "${NEWRPCp1}" != "${NEWRPCp2}" ]; then
      dialog --title "PiNode-XMR - RPC Password" --msgbox "FAIL -> Passwords dont Match\nPlease try again ..." 6 45
	  ./setup.sh
	  exit 1
    fi
	
dialog --clear
	  
	# password zero
    if [ ${#NEWRPCp1} -eq 0 ]; then
      dialog --title "PiNode-XMR - RPC Password" --msgbox "FAIL -> Password cannot be empty\nPlease try again ..." 6 45
	  ./setup.sh
      exit 1
    fi
	# check that password does not contain bad characters
    clearedResult=$(echo "${NEWRPCp1}" | tr -dc '[:alnum:]-.' | tr -d ' ')
    if [ ${#clearedResult} != ${#NEWRPCp1} ] || [ ${#clearedResult} -eq 0 ]; then
      dialog --title "PiNode-XMR - RPC Password" --msgbox "FAIL -> Contains bad characters (spaces, special chars)\nPlease try again ..." 6 45
    ./setup.sh
      exit 1
    fi
	
	# password longer than 8
    if [ ${#NEWRPCp1} -lt 8 ]; then
      dialog --title "RaspiBlitz - RPC Password" --msgbox "FAIL -> Password length under 8\nPlease try again ..." 6 45
      ./setup.sh
      exit 1
    fi
	
dialog --clear
	exitstatus=$?
	
	if [ $exitstatus = 0 ]; then
# New verified password
	NEWRPCp="${NEWRPCp1}"
#Set new RPC Password
	echo "#!/bin/sh
RPCp=${NEWRPCp}" > /home/pinodexmr/RPCp.sh

	dialog --title "PiNode-XMR Setup 3/3" --infobox "New RPC Password set." 10 30 ; sleep 3
	fi
dialog --clear
	echo "#!/bin/sh
SETUP_STATUS=4" > /home/pinodexmr/setupstatus.sh

fi

#Load menu status - to track setup progress - will be re-called throughout
. /home/pinodexmr/setupstatus.sh

#Menu for configuration of Dynamic DNS service
if [ $SETUP_STATUS -eq 4 ]; then
dialog
HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Set up Dynamic DNS"
TITLE="PiNode-XMR Setup (Optional)"
MENU="If you have a dynamic external IP address you may use the service at NOIP.com to configure a static hostname:"

OPTIONS=(1 "configure hostname with NOIP.com"
         2 "Skip this Step")

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
    --msgbox "You will need a no-ip.com username and login before configuring your PiNode-XMR\n\nRegister on their site before continuing.\nOnce you have registered select 'ok' here\n(A client will be downloaded to send updates to NO-IP.com DNS register)" 12 45
			sudo -- sh -c 'cd /usr/local/src/ && wget http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz && tar xf noip-duc-linux.tar.gz && cd noip-2.1.9-1/ && make install && /usr/local/bin/noip2 -C && /usr/local/bin/noip2'
            echo "Dynamic DNS configured - NO-IP.com"
            ;;
        2)
            echo "Your PiNode-XMR setup is complete. Navigate to the \"Advanced Settings\" tab in the Web-UI and select a Start button to begin your Monero Node"
            ;;
esac

	echo "#!/bin/sh
SETUP_STATUS=0" > /home/pinodexmr/setupstatus.sh

fi