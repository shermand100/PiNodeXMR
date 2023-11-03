#!/bin/bash
##Start password config

# use temp file 
_temp="./dialog.$$"

	whiptail --title "PiNode-XMR RPC config" --msgbox "Monero RPC Password and Username:\n\nUse these to connect a wallet to your node from another device (for example as a remote node in the Monero GUI or a mobile device) " 16 45 
	
#RPC Password - set


	whiptail --title "PiNode-XMR RPC config" --passwordbox "\nPassword must be at least 8 standard characters" 12 45 2>$_temp

    # get user input
    NEWRPCp1=$( cat $_temp )
    shred $_temp 
	
whiptail --clear

    # ask user for new RPCp (second time)
		whiptail --title "PiNode-XMR RPC config" --passwordbox "Re-Enter Password" 16 45 2>$_temp
		
	       # get user input
			NEWRPCp2=$( cat $_temp )
			shred $_temp

    # check if passwords match
    if [ "${NEWRPCp1}" != "${NEWRPCp2}" ]; then
      whiptail --title "PiNode-XMR - RPC Password" --msgbox "FAIL -> Passwords dont Match\nPlease try again ..." 16 45
	  ./setupMenuScripts/setup-password-monerorpc.sh
	  exit 1
    fi
		  
	# password zero
    if [ ${#NEWRPCp1} -eq 0 ]; then
      whiptail --title "PiNode-XMR - RPC Password" --msgbox "FAIL -> Password cannot be empty\nPlease try again ..." 16 45
	  ./setupMenuScripts/setup-password-monerorpc.sh
      exit 1
    fi
	
	# check that password does not contain bad characters
    clearedResult=$(echo "${NEWRPCp1}" | tr -dc '[:alnum:]-.' | tr -d ' ')
    if [ ${#clearedResult} != ${#NEWRPCp1} ] || [ ${#clearedResult} -eq 0 ]; then
      whiptail --title "PiNode-XMR - RPC Password" --msgbox "FAIL -> Contains bad characters (spaces, special chars)\nPlease try again ..." 16 45
    ./setupMenuScripts/setup-password-monerorpc.sh
      exit 1
    fi
	
	# password longer than 8
    if [ ${#NEWRPCp1} -lt 8 ]; then
      whiptail \
	  --title "PiNode-XMR - RPC Password" --msgbox "FAIL -> Password length under 8\nPlease try again ..." 16 45
      ./setupMenuScripts/setup-password-monerorpc.sh
      exit 1
    fi
	

	exitstatus=$?
	
	if [ $exitstatus = 0 ]; then
# New verified password
	NEWRPCp="${NEWRPCp1}"
#Set new RPC Password
	echo "#!/bin/sh
RPCp=${NEWRPCp}" > /home/pinodexmr/variables/RPCp.sh

	whiptail \
	--title "PiNode-XMR RPC config" --msgbox "New RPC Password set.\n\nNext select a new RPC username" 10 30
	else
	./setup.sh
	fi
	
#RPC Username - set
	whiptail --title "PiNode-XMR RPC config" --inputbox "New Username:" 10 60 2>$_temp
		
	       # get user input
			NEWRPCu=$( cat $_temp )
			shred $_temp
 
	exitstatus=$?
	if [ $exitstatus = 0 ]; then
	echo "#!/bin/sh
RPCu=${NEWRPCu}" > /home/pinodexmr/variables/RPCu.sh

	whiptail --title "PiNode-XMR RPC config" --msgbox "New RPC Username set:\n\n ${NEWRPCu}" 10 30
	else
    echo "You chose Cancel."
	sleep 2
	./setup.sh
	exit 1
	fi

./setup.sh
