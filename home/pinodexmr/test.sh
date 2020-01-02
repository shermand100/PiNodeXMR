#!/bin/bash

# External storage configuration
#Load menu status - to track setup progress - will be re-called throughout
. /home/pinodexmr/setupstatus.sh

if [ $SETUP_STATUS -eq 4 ]; then

dialog --title "PiNode-XMR Setup 3/3" --msgbox "PiNode-XMR will now configure your storage to hold the Monero blockchain" 16 60


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

    existsHDD=$(lsblk | grep -c sda)

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
TITLE="PiNode-XMR Setup"
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
TITLE="PiNode-XMR Setup"
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
TITLE="PiNode-XMR Setup"
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

# USB device selected, preparing
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
	TITLE="PiNode-XMR Setup"
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
		sudo mount /dev/sda /home/pinodexmr/.bitmonero
		sudo chown -R pinodexmr /home/pinodexmr/.bitmonero
		UUID=$(lsblk -o UUID,LABEL | grep XMRBLOCKCHAIN | awk '{print $1}')
		#ADD UUID to fstab. To mount on boot
		sudo sed "3 a UUID=${UUID} /home/pinodexmr/.bitmonero ext4 noexec,defaults 0 2" -i /etc/fstab
		echo "Drive has been initialized and will auto-mount on boot"
		sleep 3

	echo "#!/bin/sh
SETUP_STATUS=6" > /home/pinodexmr/setupstatus.sh
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
SETUP_STATUS=6" > /home/pinodexmr/setupstatus.sh
			
			
			

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
SETUP_STATUS=6" > /home/pinodexmr/setupstatus.sh
	
	fi

fi

#Load menu status - to track setup progress - will be re-called throughout
#. /home/pinodexmr/setupstatus.sh

#if [ $SETUP_STATUS -eq 4 ]; then
fi

#echo "#!/bin/sh
#SETUP_STATUS=5" > /home/pinodexmr/setupstatus.sh
#Load menu status - to track setup progress - will be re-called throughout
#. /home/pinodexmr/setupstatus.sh
