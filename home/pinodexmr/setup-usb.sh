#!/bin/bash

#Import $DEVICE_TO_CONFIGURE variable e.g /dev/sda
. /home/pinodexmr/setup-usb-path.sh
#Append partition number of drive (+1)
	fullDrivePath="/dev/$DEVICE_TO_CONFIGURE"1
#Determine filesystem of device to configured
	FILESYSTEM="$(sudo blkid -o value -s TYPE $fullDrivePath)"

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
		sudo mount -t $FILESYSTEM -o rw "/dev/$DEVICE_TO_CONFIGURE"1 /home/pinodexmr/.bitmonero
		sleep 2
		
		# Set permissions of new mount
		sudo chown -R pinodexmr /home/pinodexmr/.bitmonero
		sudo chmod 777 -R /home/pinodexmr/.bitmonero
		
		#ADD UUID of USB drive to fstab. To auto-mount on boot. (add to 3rd line of fstab)
		UUID=$(lsblk -o UUID,LABEL | grep XMRBLOCKCHAIN | awk '{print $1}' | sed -n 1p)
		sudo sed -i '4d' /etc/fstab #removes existing entry is script run before (delete 4th line fstab)
		sudo sed "3 a UUID=$UUID /home/pinodexmr/.bitmonero $FILESYSTEM noexec,defaults,nofail 0 2" -i /etc/fstab
		echo "Drive data has been preserved for this configuration, initialized and will auto-mount on boot"
		sleep 2
			whiptail --title "PiNode-XMR Storage Helper" --msgbox "Your device /dev/$DEVICE_TO_CONFIGURE containing the Monero Blockchain has been:\n* Mounted to /home/pinodexmr/.bitmonero for PiNodeXMR use\n* /dev/$DEVICE_TO_CONFIGURE has been added to /etc/fstab to auto mount on future system boots." 20 60
		./setup.sh

            ;;
			
        "2)")
			
		#Check size of selected storage device. Convert to human readable.
		raw_device_size=$(lsblk -o NAME,SIZE -b | grep $DEVICE_TO_CONFIGURE | awk 'NR==1{print $2/1000000000}') #device size divided by 1000000000 for GB
		device_size=$(printf "%.0f\n" $raw_device_size) #Division above produces decimals, this command removes decimal places
		
	if [ ${device_size} -lt 100 ]; then
		CHOICE=$(whiptail --backtitle "Consider larger device?" --title "PiNode-XMR Storage helper" --menu "PiNode-XMR detects that the storage device you intend to use is smaller than 100GB\n\nThe Monero blockchain is over 100GB in size and growing, for a full node consider using a larger device\n\nIf you plan to run a pruned node or believe this is incorrect you may continue anyway" 20 80 8 \
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
		
	CHOICE=$(whiptail --backtitle "Choose Drive Format" --title "PiNode-XMR Storage helper" --menu "Advanced setting:\n\nBy default PiNode-XMR will format the selected drive as 'UDF'. This provides maximum compatibility if you intend to copy the blockchain onto this device from another computer.\n\nIf you intend to sync on this device from scratch you may choose another type for slightly improved performance." 20 80 8 \
    "1)" "[default] Format using 'UDF'"   \
	"2)" "Format using Linux 'EXT4'"   \
	"3)" "Format using 'NTFS'" 2>&1 >/dev/tty)
	
			case $CHOICE in
		
		"1)")
			whiptail --title "WARNING" --msgbox "This drive will now be formatted as UDF for PiNode-XMR.\n\nALL DATA ON THE SELECTED DRIVE WILL BE DELETED IN THIS PROCESS\n\n\nUnplug the drive now if you do not want to loose the data!\n\nOr select Ok to continue." 20 60
			#Run format-UDF script to do the work of configuring drive and mounting
			sudo /home/pinodexmr/format-udf.sh /dev/$DEVICE_TO_CONFIGURE XMRBLOCKCHAIN

            ;;
			
		"2)")
			whiptail --title "WARNING" --msgbox "This drive will now be formatted as EXT4 for PiNode-XMR.\n\nALL DATA ON THE SELECTED DRIVE WILL BE DELETED IN THIS PROCESS\n\n\nUnplug the drive now if you do not want to loose the data!\n\nOr select Ok to continue." 20 60
			#Perform wipefs. This is due to the UDF script applying the disk label to the root sd# which cannot be removed via the other methods below
			echo -e "\e[32mWiping old disk labels...\e[0m"			
			sudo wipefs -a /dev/$DEVICE_TO_CONFIGURE
			echo -e "\e[32mCreating single drive partition...\e[0m"
				echo 'type=83' | sudo sfdisk /dev/$DEVICE_TO_CONFIGURE
				sudo blockdev --rereadpt /dev/$DEVICE_TO_CONFIGURE				
			echo -e "\e[32mBuilding EXT4 filesystem...\e[0m"
				sudo mkfs.ext4 "/dev/$DEVICE_TO_CONFIGURE"1
			echo -e "\e[32mLabeling drive 'XMRBLOCKCHAIN'...\e[0m"
				sudo e2label "/dev/$DEVICE_TO_CONFIGURE"1 XMRBLOCKCHAIN
			echo "Mounting Device...Please Wait..."
				sudo mount -t ext4 -o rw "/dev/$DEVICE_TO_CONFIGURE"1 /home/pinodexmr/.bitmonero
				sleep 2
			# Set permissions of new mount
				sudo chown -R pinodexmr /home/pinodexmr/.bitmonero
				sudo chmod 777 -R /home/pinodexmr/.bitmonero
			#ADD UUID of USB drive to fstab. To auto-mount on boot. (add to 3rd line of fstab)
				UUID=$(lsblk -o UUID,LABEL | grep XMRBLOCKCHAIN | awk '{print $1}' | sed -n 1p)
				sudo sed -i '4d' /etc/fstab #removes existing entry is script run before (delete 4th line fstab)
				sudo sed "3 a UUID=$UUID /home/pinodexmr/.bitmonero ext4 noexec,defaults,nofail 0 2" -i /etc/fstab
			whiptail --title "PiNode-XMR Storage Helper" --msgbox "Your selected drive has been configured as Linux filesystem ext4 labeled as 'XMRBLOCKCHAIN'\n\nIt has been mounted to /home/pinodexmr/.bitmonero\nIt will auto mount to this location on system boot" 20 60
			./setup.sh

            ;;
			
			"3)")
			whiptail --title "WARNING" --msgbox "This drive will now be formatted as NTFS for PiNode-XMR.\n\nALL DATA ON THE SELECTED DRIVE WILL BE DELETED IN THIS PROCESS\n\n\nUnplug the drive now if you do not want to loose the data!\n\nOr select Ok to continue." 20 60
			#Perform wipefs. This is due to the UDF script applying the disk label to the root sd# which cannot be removed via the other methods below
			echo -e "\e[32mWiping old disk labels...\e[0m"			
			sudo wipefs -a /dev/$DEVICE_TO_CONFIGURE			
			echo -e "\e[32mCreating single drive partition...\e[0m"
				echo 'type=7' | sudo sfdisk /dev/$DEVICE_TO_CONFIGURE
				sudo blockdev --rereadpt /dev/$DEVICE_TO_CONFIGURE
			echo -e "\e[32mBuilding NTFS filesystem...\e[0m"
				sudo mkfs.ntfs -fF "/dev/$DEVICE_TO_CONFIGURE"1
			echo -e "\e[32mLabeling drive 'XMRBLOCKCHAIN'...\e[0m"
				sleep 2
				sudo ntfslabel "/dev/$DEVICE_TO_CONFIGURE"1 XMRBLOCKCHAIN
			echo "Mounting Device...Please Wait..."
				sleep 2
				sudo mount -t ntfs -o rw "/dev/$DEVICE_TO_CONFIGURE"1 /home/pinodexmr/.bitmonero
				sleep 2
			# Set permissions of new mount
				sudo chown -R pinodexmr /home/pinodexmr/.bitmonero
				sudo chmod 777 -R /home/pinodexmr/.bitmonero
			#ADD UUID of USB drive to fstab. To auto-mount on boot. (add to 3rd line of fstab)
				UUID=$(lsblk -o UUID,LABEL | grep XMRBLOCKCHAIN | awk '{print $1}' | sed -n 1p)
				sudo sed -i '4d' /etc/fstab #removes existing entry is script run before (delete 4th line fstab)
				sudo sed "3 a UUID=$UUID /home/pinodexmr/.bitmonero ntfs noexec,defaults,nofail,umask=000 0 2" -i /etc/fstab
			whiptail --title "PiNode-XMR Storage Helper" --msgbox "Your selected drive has been configured as filesystem ntfs labeled as 'XMRBLOCKCHAIN'\n\nIt has been mounted to /home/pinodexmr/.bitmonero\nIt will auto mount to this location on system boot" 20 60
			./setup.sh

            ;;
			
			esac
			fi
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
		
	CHOICE=$(whiptail --backtitle "Choose Drive Format" --title "PiNode-XMR Storage helper" --menu "Advanced setting:\n\nBy default PiNode-XMR will format the selected drive as 'UDF'. This provides maximum compatibility if you intend to copy the blockchain onto this device from another computer.\n\nIf you intend to sync on this device from scratch you may choose another type for slightly improved performance." 20 80 8 \
    "1)" "[default] Format using 'UDF'"   \
	"2)" "Format using Linux 'EXT4'"   \
	"3)" "Format using 'NTFS'" 2>&1 >/dev/tty)
	
			case $CHOICE in
		
		"1)")
			whiptail --title "WARNING" --msgbox "This drive will now be formatted as UDF for PiNode-XMR.\n\nALL DATA ON THE SELECTED DRIVE WILL BE DELETED IN THIS PROCESS\n\n\nUnplug the drive now if you do not want to loose the data!\n\nOr select Ok to continue." 20 60
			#Run format-UDF script to do the work of configuring drive and mounting
			sudo /home/pinodexmr/format-udf.sh /dev/$DEVICE_TO_CONFIGURE XMRBLOCKCHAIN

            ;;
			
		"2)")
			whiptail --title "WARNING" --msgbox "This drive will now be formatted as EXT4 for PiNode-XMR.\n\nALL DATA ON THE SELECTED DRIVE WILL BE DELETED IN THIS PROCESS\n\n\nUnplug the drive now if you do not want to loose the data!\n\nOr select Ok to continue." 20 60
			#Perform wipefs. This is due to the UDF script applying the disk label to the root sd# which cannot be removed via the other methods below
			echo -e "\e[32mWiping old disk labels...\e[0m"			
			sudo wipefs -a /dev/$DEVICE_TO_CONFIGURE
			echo -e "\e[32mCreating single drive partition...\e[0m"
				echo 'type=83' | sudo sfdisk /dev/$DEVICE_TO_CONFIGURE
				sudo blockdev --rereadpt /dev/$DEVICE_TO_CONFIGURE				
			echo -e "\e[32mBuilding EXT4 filesystem...\e[0m"
				sudo mkfs.ext4 "/dev/$DEVICE_TO_CONFIGURE"1
			echo -e "\e[32mLabeling drive 'XMRBLOCKCHAIN'...\e[0m"
				sudo e2label "/dev/$DEVICE_TO_CONFIGURE"1 XMRBLOCKCHAIN
			echo "Mounting Device...Please Wait..."
				sudo mount -t ext4 -o rw "/dev/$DEVICE_TO_CONFIGURE"1 /home/pinodexmr/.bitmonero
				sleep 2
			# Set permissions of new mount
				sudo chown -R pinodexmr /home/pinodexmr/.bitmonero
				sudo chmod 777 -R /home/pinodexmr/.bitmonero
			#ADD UUID of USB drive to fstab. To auto-mount on boot. (add to 3rd line of fstab)
				UUID=$(lsblk -o UUID,LABEL | grep XMRBLOCKCHAIN | awk '{print $1}' | sed -n 1p)
				sudo sed -i '4d' /etc/fstab #removes existing entry is script run before (delete 4th line fstab)
				sudo sed "3 a UUID=$UUID /home/pinodexmr/.bitmonero ext4 noexec,defaults,nofail 0 2" -i /etc/fstab
			whiptail --title "PiNode-XMR Storage Helper" --msgbox "Your selected drive has been configured as Linux filesystem ext4 labeled as 'XMRBLOCKCHAIN'\n\nIt has been mounted to /home/pinodexmr/.bitmonero\nIt will auto mount to this location on system boot" 20 60
			./setup.sh

            ;;
			
			"3)")
			whiptail --title "WARNING" --msgbox "This drive will now be formatted as NTFS for PiNode-XMR.\n\nALL DATA ON THE SELECTED DRIVE WILL BE DELETED IN THIS PROCESS\n\n\nUnplug the drive now if you do not want to loose the data!\n\nOr select Ok to continue." 20 60
			#Perform wipefs. This is due to the UDF script applying the disk label to the root sd# which cannot be removed via the other methods below
			echo -e "\e[32mWiping old disk labels...\e[0m"			
			sudo wipefs -a /dev/$DEVICE_TO_CONFIGURE			
			echo -e "\e[32mCreating single drive partition...\e[0m"
				echo 'type=7' | sudo sfdisk /dev/$DEVICE_TO_CONFIGURE
				sudo blockdev --rereadpt /dev/$DEVICE_TO_CONFIGURE
			echo -e "\e[32mBuilding NTFS filesystem...\e[0m"
				sudo mkfs.ntfs -fF "/dev/$DEVICE_TO_CONFIGURE"1
			echo -e "\e[32mLabeling drive 'XMRBLOCKCHAIN'...\e[0m"
				sleep 2
				sudo ntfslabel "/dev/$DEVICE_TO_CONFIGURE"1 XMRBLOCKCHAIN
			echo "Mounting Device...Please Wait..."
				sleep 2
				sudo mount -t ntfs -o rw "/dev/$DEVICE_TO_CONFIGURE"1 /home/pinodexmr/.bitmonero
				sleep 2
			# Set permissions of new mount
				sudo chown -R pinodexmr /home/pinodexmr/.bitmonero
				sudo chmod 777 -R /home/pinodexmr/.bitmonero
			#ADD UUID of USB drive to fstab. To auto-mount on boot. (add to 3rd line of fstab)
				UUID=$(lsblk -o UUID,LABEL | grep XMRBLOCKCHAIN | awk '{print $1}' | sed -n 1p)
				sudo sed -i '4d' /etc/fstab #removes existing entry is script run before (delete 4th line fstab)
				sudo sed "3 a UUID=$UUID /home/pinodexmr/.bitmonero ntfs noexec,defaults,nofail,umask=000 0 2" -i /etc/fstab
			whiptail --title "PiNode-XMR Storage Helper" --msgbox "Your selected drive has been configured as filesystem ntfs labeled as 'XMRBLOCKCHAIN'\n\nIt has been mounted to /home/pinodexmr/.bitmonero\nIt will auto mount to this location on system boot" 20 60
			./setup.sh

            ;;
			
			esac

else
			whiptail --title "PiNode-XMR Storage Helper" --msgbox "\n\nConfiguration aborted with no changes made\n\nReturning to main menu" 20 60
./setup.sh

fi
	
	fi

fi
./setup.sh

