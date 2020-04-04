#!/bin/bash

#Import $DEVICE_TO_CONFIGURE variable
. /home/pinodexmr/setup-usb-path.sh
#Determine filesystem of device to configured
	FILESYSTEM="$(/sbin/blkid -o value -s TYPE /dev/$DEVICE_TO_CONFIGURE)"

#Check if /dev/sda contains the drive label "XMRBLOCKCHAIN" to indicate already holding data from previous version.
recoverUSB=$(lsblk -o LABEL "/dev/$DEVICE_TO_CONFIGURE" | grep -c XMRBLOCKCHAIN)

#If drive hold correct label
	if [ $recoverUSB -gt 0 ]; then
	
							CHOICE=$(whiptail --backtitle "Possible recovery" --title "PiNode-XMR Setup" --menu "PiNode-XMR found your USB device holds a label it recognizes and so can attempt recovery of the blockchain." 20 60 8 \
    "1)" "Attempt Blockchain recovery"   \
	"2)" "Don't recover. Re-format the drive to start again." 2>&1 >/dev/tty)
	
		case $CHOICE in
		"1)") 
		#Evidence this drive has contained Pinode-XMR blockchain format. Attempt re-mount and continue.
		##Note - for backwards compatibility check carried out for old ext4 partition. (New verion uses UDF).
		echo "Mounting Device...Please Wait..."
		sudo mount -t $FILESYSTEM -o rw /dev/$DEVICE_TO_CONFIGURE /home/pinodexmr/.bitmonero
		sleep 2
		
		# Set permissions of new mount
		sudo chown -R pinodexmr /home/pinodexmr/.bitmonero
		sudo chmod 777 -R /home/pinodexmr/.bitmonero
		
		#ADD UUID of USB drive to fstab. To auto-mount on boot. (add to 3rd line of fstab)
		UUID=$(lsblk -o UUID,LABEL | grep XMRBLOCKCHAIN | awk '{print $1}' | sed -n 1p)
		sudo sed -i '4d' /etc/fstab #removes existing entry is script run before (delete 4th line fstab)
		sudo sed "3 a UUID=$UUID /home/pinodexmr/.bitmonero $FILESYSTEM noexec,defaults 0 2" -i /etc/fstab
		echo "Drive data has been preserved for this configuration, initialized and will auto-mount on boot"
		sleep 2
			whiptail --title "PiNode-XMR Storage Helper" --msgbox "Your device /dev/$DEVICE_TO_CONFIGURE containing the Monero Blockchain has been:\n* Mounted to /home/pinodexmr/.bitmonero for PiNodeXMR use\n* /dev/$DEVICE_TO_CONFIGURE has been added to /etc/fstab to auto mount on future system boots\n\nYou are ready to resume your node" 20 60
		clear
		sleep 1
		./setup.sh

            ;;
			
        "2)")
			
		#Check size of selected storage device. Convert to human readable.
		raw_device_size=$(lsblk -o NAME,SIZE -b | grep $DEVICE_TO_CONFIGURE | awk 'NR==1{print $2/1000000000}') #device size divided by 1000000000 for GB
		device_size=$(printf "%.0f\n" $raw_device_size) #Division above produces decimals, this command removes decimal places
		
	if [ ${device_size} -lt 100 ]; then
		CHOICE=$(whiptail --backtitle "Consider larger device?" --title "PiNode-XMR Storage helper" --menu "PiNode-XMR detects that the storage device you intend to use is smaller than 100GB\n\nThe Monero blockchain is over 80GB in size and growing, for a full node consider using a larger device\n\nIf you plan to run a pruned node or believe this is incorrect you may continue anyway" 20 80 8 \
    "1)" "I'd like to continue with the storage device I have selected"   \
	"2)" "Cancel and keep the blockchain on my primary storage device"   \
	"3)" "I'd like to use a bigger device I have (make a hardware change)" 2>&1 >/dev/tty)
	
			case $CHOICE in
		
		"1)")
            ;;
			
		"2)") 
			whiptail --title "PiNode-XMR Storage Helper" --msgbox "No system changes have been made\n\nThe blockchain will be kept on your devices primary storage device." 20 60
			clear
			./setup.sh

            ;;
			
			"3)") echo whiptail --title "PiNode-XMR Storage Helper" --msgbox "No storage configuration has been changed\n\nYou may make hardware changes and run this setup again\n\nReturning to main menu" 20 60
			./setup.sh

            ;;
			
			esac
			else
			echo "Device found to be larger than 100GB, this is good"
			sleep 3
	fi
	
		#Run format-UDF script to do the work of configuring drive and mounting
		sudo /home/pinodexmr/format-udf.sh /dev/$DEVICE_TO_CONFIGURE XMRBLOCKCHAIN
		
		


            ;;
		esac
	
	else
	
if (whiptail --title "PiNode-XMR Setup" --yesno "This USB device doesn't hold the "XMRBLOCKCHAIN" label so setup is assuming this is a fresh install\n\n***Contents of this storage device will now be deleted***.\n\nAre you sure you want to continue?..." 20 60); then

		#Check size of selected storage device. Convert to human readable.
		raw_device_size=$(lsblk -o NAME,SIZE -b | grep $DEVICE_TO_CONFIGURE | awk 'NR==1{print $2/1000000000}') #device size divided by 1000000000 for GB
		device_size=$(printf "%.0f\n" $raw_device_size) #Division above produces decimals, this command removes decimal places
		
	if [ ${device_size} -lt 100 ]; then
		CHOICE=$(whiptail --backtitle "Consider larger device?" --title "PiNode-XMR Storage helper" --menu "PiNode-XMR detects that the storage device you intend to use is smaller than 100GB\n\nThe Monero blockchain is over 80GB in size and growing, for a full node consider using a larger device\n\nIf you plan to run a pruned node or believe this is incorrect you may continue anyway" 20 80 8 \
    "1)" "I'd like to continue with the storage device I have selected"   \
	"2)" "Cancel and keep the blockchain on my primary storage device"   \
	"3)" "I'd like to use a bigger device I have (make a hardware change)" 2>&1 >/dev/tty)
	
			case $CHOICE in
		
		"1)")
            ;;
			
		"2)") 
			whiptail --title "PiNode-XMR Storage Helper" --msgbox "No system changes have been made\n\nThe blockchain will be kept on your devices primary storage device." 20 60
			clear
			./setup.sh

            ;;
			
			"3)") echo whiptail --title "PiNode-XMR Storage Helper" --msgbox "No storage configuration has been changed\n\nYou may make hardware changes and run this setup again\n\nReturning to main menu" 20 60
			./setup.sh

            ;;
			
			esac
			else
			echo "Device found to be larger than 100GB, this is good"
			sleep 3
	fi
		
		#Run format-UDF script to do the work of configuring drive and mounting
		sudo /home/pinodexmr/format-udf.sh /dev/$DEVICE_TO_CONFIGURE XMRBLOCKCHAIN

else
			whiptail --title "PiNode-XMR Storage Helper" --msgbox "\n\nConfiguration aborted with no changes made\n\nReturning to main menu" 20 60
./setup.sh

fi
	
	fi

fi
./setup.sh

