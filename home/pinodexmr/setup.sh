#!/bin/bash


# use temp file 
_temp="./dialog.$$"

#Load menu status - to track setup progress - will be re-called throughout
. /home/pinodexmr/setupstatus.sh


if [ $SETUP_STATUS -eq 0 ]; then
dialog --title "PiNode-XMR Setup 1/4" --msgbox "Welcome to your private node.\n\nThis menu will allow you to configure your\npasswords and user name for securing your device\nand allowing secure external connections." 16 60
	echo "#!/bin/sh
SETUP_STATUS=1" > /home/pinodexmr/setupstatus.sh
fi

dialog --clear

#Load menu status - to track setup progress - will be re-called throughout
. /home/pinodexmr/setupstatus.sh

if [ $SETUP_STATUS -eq 1 ]; then
dialog --insecure --title "PiNode-XMR Setup 1/4" --passwordbox "Choose your new root/pinodexmr/SSH\npassword and choose Ok to continue.\n\nPassword must be at least 8 standard characters" 16 60 2>$_temp

    # get user input
    password1=$( cat $_temp )
    shred $_temp 

    # ask user for new password A (second time)
		dialog --title "PiNode-XMR Setup 1/4" --insecure --passwordbox "Re-Enter Password" 6 60 2>$_temp
		
	       # get user input
			password2=$( cat $_temp )
			shred $_temp

    # check if passwords match
    if [ "${password1}" != "${password2}" ]; then
      dialog --title "PiNode-XMR Setup 1/4" --msgbox "FAIL -> Passwords don't Match\nPlease try again ..." 6 60
	./setup.sh
	  exit 1
    fi

	  
	# password zero
    if [ ${#password1} -eq 0 ]; then
      dialog --title "PiNode-XMR Setup 1/4" --msgbox "FAIL -> Password cannot be empty\nPlease try again ..." 6 45
	  ./setup.sh
      exit 1
    fi
	# check that password does not contain bad characters
    clearedResult=$(echo "${password1}" | tr -dc '[:alnum:]-.' | tr -d ' ')
    if [ ${#clearedResult} != ${#password1} ] || [ ${#clearedResult} -eq 0 ]; then
      dialog --title "PiNode-XMR Setup 1/4" --msgbox "FAIL -> Contains bad characters (spaces, special chars)\nPlease try again ..." 6 45
    ./setup.sh
      exit 1
    fi
	
	# password longer than 8
    if [ ${#password1} -lt 8 ]; then
      dialog --title "PiNode-XMR Setup 1/4" --msgbox "FAIL -> Password length under 8\nPlease try again ..." 6 45
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
	dialog --title "PiNode-XMR Setup 1/4" --infobox "New Password set for root/SSH & user:\n\npinodexmr" 6 45 ; sleep 3
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
    --title "PiNode-XMR Setup 2/4" \
    --msgbox "Now set your Monero RPC Username and Password\n\nYou use these to connect to your node externally (for example as a remote node in the GUI or a mobile device) " 12 45 
	
	dialog --clear
	
	#RPC Username - set
	dialog --title "PiNode-XMR Setup 2/4" --inputbox "New Username:" 10 60 2>$_temp
		
	       # get user input
			NEWRPCu=$( cat $_temp )
			shred $_temp
 
	exitstatus=$?
	if [ $exitstatus = 0 ]; then
	echo "#!/bin/sh
RPCu=${NEWRPCu}" > /home/pinodexmr/RPCu.sh
	dialog --title "PiNode-XMR Setup 2/4" --infobox "New RPC Username set:\n\n ${NEWRPCu}" 10 30 ; sleep 3
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

	dialog --insecure --title "PiNode-XMR Setup 2/4" --passwordbox "Choose your new external connection (RPC) password and choose Ok to continue.\n\nPassword must be at least 8 standard characters" 12 45 2>$_temp

    # get user input
    NEWRPCp1=$( cat $_temp )
    shred $_temp 
	
dialog --clear

    # ask user for new RPCp (second time)
		dialog --title "PiNode-XMR Setup 2/4" --insecure --passwordbox "Re-Enter Password" 6 45 2>$_temp
		
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

	dialog --title "PiNode-XMR Setup 2/4" --infobox "New RPC Password set." 10 30 ; sleep 3
	fi
dialog --clear
	echo "#!/bin/sh
SETUP_STATUS=4" > /home/pinodexmr/setupstatus.sh

fi

# External storage configuration
#Load menu status - to track setup progress - will be re-called throughout
. /home/pinodexmr/setupstatus.sh

if [ $SETUP_STATUS -eq 4 ]; then

	dialog --title "PiNode-XMR Setup 3/4" --msgbox "PiNode-XMR will now configure your storage to hold the Monero blockchain" 16 60
	echo "*** Checking PiNode-XMR storage options ***"
	sleep 3
	
	#get size of "mmcblk" in bytes divided by 1000000000 for human readable format
	rawMicroSDsize=$(lsblk -o NAME,SIZE -b | grep "mmcblk0" | awk 'NR==1{print $2/1000000000}')
	
	#Round value of size in GB to remove decimal places (%.0f) ##Self note %.#g for significant figures)
	MicroSDsize=$(printf "%.0f\n" $rawMicroSDsize)
	
    echo "Found MicroSD card of size ${MicroSDsize} GB"
	sleep 3
	echo "*** Checking if USB storage is connected ***"
	sleep 3
	#Is sda connected? 1=yes 0=no
    existsHDD=$(lsblk | grep -c sda)
	#If sda=1 the find it's size
		if [ ${existsHDD} -gt 0 ]; then
		rawSDAsize=$(lsblk -o NAME,SIZE -b | grep "sda" | awk 'NR==1{print $2/1000000000}')
		SDAsize=$(printf "%.0f\n" $rawSDAsize)
		echo "Found USB storage of capacity ${SDAsize} GB"
		fi

		if [ ${existsHDD} -eq 0 ]; then
		echo "No external USB storage found"
		fi
	
	sleep 3

		if [ ${MicroSDsize} -lt 100 ]; then
		SDsuitability=$"not suitable"
		echo -e "\e[31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
		echo -e "\e[31mMicroSD card is not big enough for blockchain storage\e[0m"
		echo -e "\e[31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
		fi

		if [ ${SDAsize} -lt 100 ]; then
		USBsuitability=$"not suitable"
		echo -e "\e[31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
		echo -e "\e[31mUSB storage is not big enough for blockchain storage\e[0m"
		echo -e "\e[31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
		fi
	
	    if [ ${MicroSDsize} -gt 100 ]; then
		SDsuitabilityle=$"suitable"
		echo -e "\e[32m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
		echo -e "\e[32mMicroSD card found suitable for blockchain storage\e[0m"
		echo -e "\e[32m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
		fi

		if [ ${SDAsize} -gt 100 ]; then
		USBsuitability=$"not suitable"
		echo -e "\e[32m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
		echo -e "\e[32mUSB device found suitable for blockchain storage\e[0m"
		echo -e "\e[32m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
		fi

		sleep 3

		#Menu for install options

		#No suitable storage
		if [ ${existsHDD} -eq 0 ] && [ ${MicroSDsize} -lt 100 ]; then
		dialog
		HEIGHT=20
		WIDTH=60
		CHOICE_HEIGHT=4
		BACKTITLE="No suitable storage found"
		TITLE="PiNode-XMR Setup 3/4"
		MENU="PiNode-XMR can not find any suitable storage locations for the Monero blockchain. If you believe this is incorrect, continue on SD card?"

		OPTIONS=(1 "Continue anyway"
		2 "Shutdown")

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
		--title "PiNode-XMR Setup" \
		--msgbox "Storage setup complete, I will attempt to store the Monero blockchain on this MicroSD card." 20 60
		echo "#!/bin/sh
SETUP_STATUS=5" > /home/pinodexmr/setupstatus.sh
            ;;
        2)
            echo "Shutting down in 20 seconds. To resolve the storage issue, write the PiNode-XMR image to a larger SD card or connect a USB drive larger than 100GB"
			sleep 20
			sudo shutdown now
            ;;
		esac
		fi


#SD Suitable - no USB drive

		if [ ${existsHDD} -eq 0 ] && [ ${MicroSDsize} -gt 100 ]; then
		dialog
		HEIGHT=20
		WIDTH=60
		CHOICE_HEIGHT=4
		BACKTITLE="MicroSD Storage"
		TITLE="PiNode-XMR Setup 3/4"
		MENU="PiNode-XMR found suitable space on your SD card, and no external USB storage. Continue on SD card only, or shutdown to attach storage and try again."

		OPTIONS=(1 "Continue on MicroSD"
				2 "Shutdown")

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
		--title "PiNode-XMR Setup" \
		--msgbox "Storage setup complete, I will store the Monero Blockchain on this MicroSD card." 20 60
		echo "#!/bin/sh
SETUP_STATUS=5" > /home/pinodexmr/setupstatus.sh
            ;;
        2)
            echo "Shutting down in 20 seconds. You can connect a USB drive larger than 100GB and try again"
			sleep 20
			sudo shutdown now
            ;;
		esac
		fi		
	
		#USB drive Suitable
		if [ ${SDAsize} -gt 100 ]; then
		dialog
		HEIGHT=20
		WIDTH=60
		CHOICE_HEIGHT=4
		BACKTITLE="USB device Storage"
		TITLE="PiNode-XMR Setup 3/4"
		MENU="PiNode-XMR found a suitable external USB storage device. This can be used to store the Monero Blockchain.\n\n If you choose to continue it will be formatted for PiNode-XMR use (all other data will be lost).\n\nIf this device contains the blockchain already a recovery can be attempted."

		OPTIONS=(1 "Continue setting up USB device"
				2 "Don't use this USB device and Shutdown")

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
		--title "PiNode-XMR Setup" \
		--msgbox "USB storage device selected. Detecting if device contains Monero blockchain from previous installation." 20 60
		echo "#!/bin/sh
SETUP_STATUS=6" > /home/pinodexmr/setupstatus.sh
		sleep 2
            ;;
        2)
            echo "Shutting down in 20 seconds. Your data on the USB device hasn't been altered"
			sleep 20
			sudo shutdown now
            ;;
		esac
		fi
fi
# USB device selected for storage, preparing...

#Load menu status - to track setup progress - will be re-called throughout
. /home/pinodexmr/setupstatus.sh

if [ $SETUP_STATUS -eq 6 ]; then
#Check if /dev/sda contains the drive label "XMRBLOCKCHAIN" to indicate already holding data from previous version.
recoverUSB=$(lsblk -o LABEL "/dev/sda" | grep -c XMRBLOCKCHAIN)
#If drive hold correct label
	if [ $recoverUSB -eq 1 ]; then
	   dialog
	HEIGHT=20
	WIDTH=60
	CHOICE_HEIGHT=4
	BACKTITLE="Possible recovery"
	TITLE="PiNode-XMR Setup 3/4"
	MENU="PiNode-XMR found your USB device holds a label it recognizes and so can attempt recovery of the blockchain."

	OPTIONS=(1 "Attempt Blockchain recovery"
         2 "Don't recover. Re-format the drive to start again.")

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
		#Evidence this drive has contained Pinode-XMR blockchain format. Attempt re-mount and continue.
		sudo mount /dev/sda /home/pinodexmr/.bitmonero
		sudo chown -R pinodexmr /home/pinodexmr/.bitmonero
		UUID=$(lsblk -o UUID,LABEL | grep XMRBLOCKCHAIN | awk '{print $1}')
		#ADD UUID of USB drive to fstab. To auto-mount on boot. (add to 3rd line of fstab)
		sudo sed "3 a UUID=${UUID} /home/pinodexmr/.bitmonero ext4 noexec,defaults 0 2" -i /etc/fstab
		echo "Drive has been initialized and will auto-mount on boot"
		sleep 2
		echo "Storage device setup complete. Continuing PiNode-XMR setup."
		sleep 3
	echo "#!/bin/sh
SETUP_STATUS=5" > /home/pinodexmr/setupstatus.sh
            ;;
        2)
			dialog \
    --title "PiNode-XMR Setup" \
    --msgbox "Contents of the USB drive will now be deleted. Press enter to continue. (Last chance to abort by unplugging device) " 20 60
            echo "***Preparing Drive***"
			sleep 1
			echo "***Deleting data***"
			sudo mkfs.ext4 /dev/sda -F -L XMRBLOCKCHAIN
			echo "***Drive format to ext4 complete***"
			sleep 3
			echo "***Mounting drive to /home/pinodexmr/.bitmonero***"
			sudo mount /dev/sda /home/pinodexmr/.bitmonero
			sudo chown -R pinodexmr /home/pinodexmr/.bitmonero
			UUID=$(lsblk -o UUID,LABEL | grep XMRBLOCKCHAIN | awk '{print $1}')
			#ADD UUID to fstab. To mount on boot
			sudo sed "3 a UUID=${UUID} /home/pinodexmr/.bitmonero ext4 noexec,defaults 0 2" -i /etc/fstab
			echo "Drive has been initialized and will auto-mount on boot"
			sleep 3
			echo "***Storage setup complete***"
			sleep 3
			
			echo "#!/bin/sh
SETUP_STATUS=5" > /home/pinodexmr/setupstatus.sh
            ;;
	esac
	else
	dialog \
    --title "PiNode-XMR Setup" \
    --msgbox "This USB device doesn't hold the "XMRBLOCKCHAIN" label so setup is assuming this is a fresh install\n\n***Contents of the USB drive will now be deleted***. Press enter to continue. (Last chance to abort by unplugging device) " 20 60
            echo "***Preparing Drive***"
			sleep 1
			echo "***Deleting data***"
			sudo mkfs.ext4 /dev/sda -F -L XMRBLOCKCHAIN
			echo "***Drive format to ext4 complete***"
			sleep 3
			echo "***Mounting drive to /home/pinodexmr/.bitmonero***"
			sudo mount /dev/sda /home/pinodexmr/.bitmonero
			sudo chown -R pinodexmr /home/pinodexmr/.bitmonero
			UUID=$(lsblk -o UUID,LABEL | grep XMRBLOCKCHAIN | awk '{print $1}')
			#ADD UUID to fstab. To mount on boot
			sudo sed "3 a UUID=${UUID} /home/pinodexmr/.bitmonero ext4 noexec,defaults 0 2" -i /etc/fstab
			echo "Drive has been initialized and will auto-mount on boot"
			sleep 3
			echo "***Storage setup complete***"
			sleep 3
			echo "#!/bin/sh
SETUP_STATUS=5" > /home/pinodexmr/setupstatus.sh
	
	fi

fi
sleep 1
#Load menu status - to track setup progress - will be re-called throughout
. /home/pinodexmr/setupstatus.sh

#Menu for configuration of Dynamic DNS service
if [ $SETUP_STATUS -eq 5 ]; then
dialog
HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Set up Dynamic DNS"
TITLE="PiNode-XMR Setup (Optional) 4/4"
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