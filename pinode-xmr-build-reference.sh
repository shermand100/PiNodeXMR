#!/bin/bash


# use temp file 
_temp="./dialog.$$"

#Load menu status - to track setup progress - will be re-called throughout
. /home/pinodexmr/setupstatus.sh

if [ $SETUP_STATUS -eq 0 ]; then
		dialog
		HEIGHT=20
		WIDTH=60
		CHOICE_HEIGHT=4
		BACKTITLE="Welcome"
		TITLE="PiNode-XMR Setup"
		MENU="Welcome to PiNode-XMR.\n\nWhat do you require?"

		OPTIONS=(1 "First time setup"
		2 "Command line"
		3 "Update Monero")

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
		--msgbox "You will now be guided through the initial setup for your PiNode-XMR\n\nIf you intend to use an external USB device to store the blockchain (device over 100GB) you may attach it now.\n\nThis menu will allow you to set a USB storage device, secure user name/password and Dynamic DNS configuration (optional)" 20 60
            ;;
        2)
		echo "#!/bin/sh
SETUP_STATUS=99" > /home/pinodexmr/setupstatus.sh
            ;;
		3)
			dialog \
		--title "PiNode-XMR Update" \
		--msgbox "Your PiNode-XMR will check to see if an update is available" 20 60
		#Establish IP
		DEVICE_IP="$(hostname -I)"
		echo "PiNode-XMR on ${DEVICE_IP} is checking for available updates"
		sleep "1"
		#Download update file
		sleep "1"
		wget -q https://raw.githubusercontent.com/shermand100/pinode-xmr/master/xmr-new-ver.sh -O /home/pinodexmr/xmr-new-ver.sh
		echo "Version Info file recieved:"
		#Permission Setting
		chmod 755 /home/pinodexmr/current-ver.sh
		chmod 755 /home/pinodexmr/xmr-new-ver.sh
		#Load Variables
		. /home/pinodexmr/current-ver.sh
		. /home/pinodexmr/xmr-new-ver.sh
		. /home/pinodexmr/strip.sh
		echo $NEW_VERSION 'New Version'
		echo $CURRENT_VERSION 'Current Version'
		sleep "3"
		if [ $CURRENT_VERSION -lt $NEW_VERSION ]
		then
		echo -e "\e[32mNew Monero version available...Downloading\e[0m"
		sleep "2"
		wget https://downloads.getmonero.org/cli/linuxarm7
		echo -e "New version of Monero SHA256 hash is...\e[33m"
		cat ./linuxarm7 | sha256sum | head -c 64
		echo -e "\n\e[0mIt is strongly recommended that you compare the hash above with the official hash at \n\e[33m https://web.getmonero.org/downloads/#arm \n\e[0m For ARMv7 command-line tools only. \n Only proceed with this update if the hash values match to prevent installing malicious software.\n"
	
		asksure() {
		echo -e "\e[31mAre you sure the signatures match(Y/N)?\e[0m"
		while read -r -n 1 -s answer; do
		if [[ $answer = [YyNn] ]]; then
		[[ $answer = [Yy] ]] && retval=0
		[[ $answer = [Nn] ]] && retval=1
		break
	fi
	done

	echo # just a final linefeed, optics...

return $retval
}

### using it
if asksure; then
  echo "Okay, performing update..."
else
  echo "Update canceled. Refer to the Monero community for guidance before attempting update again."
  rm /home/pinodexmr/linuxarm7
  sleep "1"
  echo "Deleted un-trusted download of Monero for ARMv7"
  echo "Exiting in 5 seconds"
  sleep 5
	exit 1
fi

	sudo systemctl stop monerod-start.service
	sudo systemctl stop monerod-start-mining.service
	sudo systemctl stop monerod-start-tor.service
	echo "Monerod stop command sent, allowing 30 seconds for safe shutdown"
	sleep "30"
	rm -rf /home/pinodexmr/monero-active/
	echo "Deleting Old Version"
	sleep "2"
	mkdir /home/pinodexmr/monero-active
	sleep "2"
	chmod 755 /home/pinodexmr/monero-active

	tar -xvf ./linuxarm7 -C /home/pinodexmr/monero-active --strip $STRIP
	echo "Software Update Complete - Resuming Node"
	sleep 2
	. /home/pinodexmr/init.sh
	echo "Monero Node Started in background"
	echo "Tidying up leftover installation packages"
	#Clean-up stage
	#Update system version number
	echo "#!/bin/bash
CURRENT_VERSION=$NEW_VERSION" > /home/pinodexmr/current-ver.sh
	#Remove downloaded version check file
	rm /home/pinodexmr/xmr-new-ver.sh
	rm /home/pinodexmr/linuxarm7
		echo "#!/bin/sh
SETUP_STATUS=99" > /home/pinodexmr/setupstatus.sh
		echo "Update complete"
		sleep 3
else
	echo "Your node is up to date!"
sleep 3
	echo "#!/bin/sh
SETUP_STATUS=99" > /home/pinodexmr/setupstatus.sh
fi
            ;;
		esac
		fi
		
##Start first time config

#Load menu status - to track setup progress - will be re-called throughout
. /home/pinodexmr/setupstatus.sh

if [ $SETUP_STATUS -eq 0 ]; then
dialog --title "PiNode-XMR Setup 1/4" --msgbox "First we'll set your master password for logging onto here." 16 60
	echo "#!/bin/sh
SETUP_STATUS=1" > /home/pinodexmr/setupstatus.sh
#Fix PiNode-XMR Issue #12, swap file on image shrink for upload compresses to 1.2GB not correct 2GB. sudo dphys-swapfile setup re-sizes swap to 2GB.
	sudo dphys-swapfile setup
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

		#No suitable storage (note to self || means or)
		if [ ${existsHDD} -eq 0 ] || [ ${SDAsize} -lt 100 ] && [ ${MicroSDsize} -lt 100 ]; then
		dialog
		HEIGHT=20
		WIDTH=60
		CHOICE_HEIGHT=4
		BACKTITLE="No suitable storage found"
		TITLE="PiNode-XMR Setup 3/4"
		MENU="PiNode-XMR can not find any suitable storage locations for the Monero blockchain.\n\nPlease install the PiNode-XMR disk image on an SD card larger than 100GB to hold this software and the Monero Blockchain\nor\nAdd an external USB device of over 100GB\n\nIf you believe this is incorrect, you may continue anyway. To make hardware changes, shutdown?"

		OPTIONS=(1 "Continue using SD card"
		2 "Continue using USB (if detected)"
		3 "Shutdown")

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
		--msgbox "Although I have detected the SD card is too small for both the PiNode-XMR software and the Monero Blockchain I will continue anyway.\n\n***Storage Setup complete***" 20 60
		echo "#!/bin/sh
SETUP_STATUS=5" > /home/pinodexmr/setupstatus.sh
            ;;
		2)
			dialog \
		--title "PiNode-XMR Setup" \
		--msgbox "Although I think the USB device is too small (if at all detected) I will attempt to store the Monero blockchain on USB device 'sda'" 20 60
		echo "#!/bin/sh
SETUP_STATUS=6" > /home/pinodexmr/setupstatus.sh
            ;;
        3)
            echo "Shutting down in 20 seconds. To resolve the storage issue, write the PiNode-XMR image to a larger SD card or connect a USB drive larger than 100GB"
			#restore this setup status to beginning
			echo "#!/bin/sh
SETUP_STATUS=0" > /home/pinodexmr/setupstatus.sh
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
			#restore this setup status to beginning
			echo "#!/bin/sh
SETUP_STATUS=0" > /home/pinodexmr/setupstatus.sh
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
		MENU="PiNode-XMR found a suitable external USB storage device. This can be used to store the Monero Blockchain.\n\nIf this device has been used with PiNode-XMR before it can be configured to re-use the blockchain\n\nIf this device has not been used with PiNode-XMR before\n\n***All data will be lost***"

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
		--msgbox "USB storage device selected.\n\n I will detect if device contains Monero blockchain from previous installation.\n\nPress enter" 20 60
		echo "#!/bin/sh
SETUP_STATUS=6" > /home/pinodexmr/setupstatus.sh
		sleep 2
            ;;
        2)
            echo "Shutting down in 20 seconds. Your data on the USB device hasn't been altered"
			#restore this setup status to beginning
					echo "#!/bin/sh
SETUP_STATUS=0" > /home/pinodexmr/setupstatus.sh
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
		sudo mount -t ext4 -o rw /dev/sda /home/pinodexmr/.bitmonero
		sudo chown -R pinodexmr /home/pinodexmr/.bitmonero
		sudo chmod 777 -R /home/pinodexmr/.bitmonero
		UUID=$(lsblk -o UUID,LABEL | grep XMRBLOCKCHAIN | awk '{print $1}')
		#ADD UUID of USB drive to fstab. To auto-mount on boot. (add to 3rd line of fstab)
		sudo sed "3 a UUID=${UUID} /home/pinodexmr/.bitmonero ext4 noexec,defaults 0 2" -i /etc/fstab
		echo "Drive data has been preserved for this configuration, initialized and will auto-mount on boot"
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
			sudo mount -t ext4 -o rw /dev/sda /home/pinodexmr/.bitmonero
			sudo chown -R pinodexmr /home/pinodexmr/.bitmonero
			sudo chmod 777 -R /home/pinodexmr/.bitmonero
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
    --msgbox "This USB device doesn't hold the "XMRBLOCKCHAIN" label so setup is assuming this is a fresh install\n\n***Contents of the USB drive will now be deleted***.\n\nPress enter to continue. (Last chance to abort by unplugging device) " 20 60
            echo "***Preparing Drive***"
			sleep 1
			echo "***Deleting data***"
			sudo mkfs.ext4 /dev/sda -F -L XMRBLOCKCHAIN
			echo "***Drive format to ext4 complete***"
			sleep 3
			echo "***Mounting drive to /home/pinodexmr/.bitmonero***"
			sudo mount -t ext4 -o rw /dev/sda /home/pinodexmr/.bitmonero
			sudo chown -R pinodexmr /home/pinodexmr/.bitmonero
			sudo chmod 777 -R /home/pinodexmr/.bitmonero
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
	#All setup and storage/drive mounting configured. Onion blockexplorer can now be given access to .bitmonero directory.
	sudo systemctl start explorer-start.service
	echo "Storage accessible: Starting Monero Onion-Block-Explorer in background"
	sleep 3
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
fi
#Restore setup back to nil to allow script to be run again if needed
	echo "#!/bin/sh
SETUP_STATUS=0" > /home/pinodexmr/setupstatus.sh
#To allow Monero onion-block-explorer to be run from boot now storage has been configured. Referenced from init.sh
	echo "#!/bin/sh
SETUP_COMPLETE=1" > /home/pinodexmr/setupcomplete.sh