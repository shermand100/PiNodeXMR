#!/bin/bash

#Import $DEVICE_TO_CONFIGURE variable e.g /dev/sda
. /home/nodo/setupMenuScripts/setup-usb-path.sh

#To allow previous PiNodeXMR V4 user compatibility append +1 to partition number of drive if "/dev/sda" device.
	##Matched string is looking for "sd" in assumed "/dev/sd#" indicating USB device. Should not apply to NVMe devices on RockPro64 (assumed nvme0n1)
if [[ $DEVICE_TO_CONFIGURE =~ "sd" ]]; then
	fullDrivePath="/dev/$DEVICE_TO_CONFIGURE"1
	else
	fullDrivePath="/dev/$DEVICE_TO_CONFIGURE"
fi

#Check if device contains the drive label "XMRBLOCKCHAIN" to indicate already holding data from previous version. (value 1 indicates label exists)
recoverUSB=$(lsblk -o LABEL $fullDrivePath | grep -c XMRBLOCKCHAIN)	

#Determine filesystem of device to restore
	FILESYSTEM="$(sudo blkid -o value -s TYPE $fullDrivePath)"

#Define some basic functions to avoid repetition of code. All functions in PiNodeXMR project defined with prefix "fn_" for transparency.
	##Mount drive function
function fn_mountDrive () {
		echo "Mounting Device...Please Wait..."
		sudo mount -t $FILESYSTEM -o rw $fullDrivePath /home/nodo/.bitmonero
		sleep 2
}
	##Add UUID to fstab function (auto-mount on boot)
	###Note: PiNodeXMR will be confused here if more than one drive is connected with label 'XMRBLOCKCHAIN'. Only first entry in lsblk list will be added to /etc/fstab
function fn_addUuid () {
		UUID=$(lsblk -o UUID,LABEL | grep XMRBLOCKCHAIN | awk '{print $1}' | sed -n 1p)
		sudo sed -i '/bitmonero/d' /etc/fstab #removes existing entry if script run before (match 'bitmonero' and delete line)
		sudo sed "$ a UUID=$UUID /home/nodo/.bitmonero $FILESYSTEM noexec,defaults,nofail 0 2" -i /etc/fstab # '$' add to last line of file
}

	##Set permissions of mounted /.bitmonero dir
function fn_setPermissions () {
		sudo chown -R nodo /home/nodo/.bitmonero
		sudo chmod 777 -R /home/nodo/.bitmonero
}

	##Wipe selected filesystem
function fn_wipeFilesystem () {
			echo -e "\e[32mWiping old disk labels...\e[0m"			
			sudo wipefs -a $fullDrivePath
}

	##Create EXT4 partition and mount
function fn_createExt4 () {
			echo -e "\e[32mCreating single drive partition...\e[0m"
			echo 'type=83' | sudo sfdisk /dev/$DEVICE_TO_CONFIGURE
			sudo blockdev --rereadpt /dev/$DEVICE_TO_CONFIGURE
			echo -e "\e[32mBuilding EXT4 filesystem...\e[0m"
			yes |sudo mkfs.ext4 $fullDrivePath
			echo -e "\e[32mLabeling drive 'XMRBLOCKCHAIN'...\e[0m"
			sudo e2label $fullDrivePath XMRBLOCKCHAIN
			echo "Mounting Device...Please Wait..."
			sudo mount -t ext4 -o rw $fullDrivePath /home/nodo/.bitmonero
			sleep 2
}

	##Create NTFS partition and mount
function fn_createNtfs () {
			echo -e "\e[32mCreating single drive partition...\e[0m"
			echo 'type=7' | sudo sfdisk /dev/$DEVICE_TO_CONFIGURE
			sudo blockdev --rereadpt /dev/$DEVICE_TO_CONFIGURE
			echo -e "\e[32mBuilding NTFS filesystem...\e[0m"
			sudo mkfs.ntfs -fF $fullDrivePath
			echo -e "\e[32mLabeling drive 'XMRBLOCKCHAIN'...\e[0m"
			sleep 2
			sudo ntfslabel $fullDrivePath XMRBLOCKCHAIN
			echo "Mounting Device...Please Wait..."
			sleep 2
			sudo mount -t ntfs -o rw $fullDrivePath /home/nodo/.bitmonero
			sleep 2
}

#If drive hold correct label
	if [ $recoverUSB -gt 0 ]; then
	
							CHOICE=$(whiptail --backtitle "Possible recovery" --title "PiNode-XMR Setup" --menu "PiNode-XMR found your USB device holds a label it recognizes and so can attempt recovery of the blockchain." 20 60 8 \
    	"1)" "Attempt Blockchain recovery"   \
		"2)" "Don't recover. Re-format the drive to start again." 2>&1 >/dev/tty)
	
		case $CHOICE in
		"1)") 
		#Evidence this drive has contained Pinode-XMR blockchain format. Attempt re-mount and continue.
		fn_mountDrive

		#Add UUID to fstab
		fn_addUuid
		
		# Set permissions of new mount
		fn_setPermissions
		
		echo "Drive data has been preserved for this configuration, initialized and will auto-mount on boot"
		sleep 2
			whiptail --title "PiNode-XMR Storage Helper" --msgbox "Your device $fullDrivePath containing the Monero Blockchain has been:\n* Mounted to /home/nodo/.bitmonero for PiNodeXMR use\n* $fullDrivePath has been added to /etc/fstab to auto mount on future system boots." 20 60
            ;;
			
        "2)")
			
		#Check size of selected storage device. Convert to human readable.
		raw_device_size=$(lsblk -o NAME,SIZE -b | grep $DEVICE_TO_CONFIGURE | awk 'NR==1{print $2/1000000000}') #device size divided by 1000000000 for GB
		device_size=$(printf "%.0f\n" $raw_device_size) #Division above produces decimals, this command removes decimal places
		
		if [ ${device_size} -lt 100 ];
			then
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
   	       		;;
			
			"3)") echo whiptail --title "PiNode-XMR Storage Helper" --msgbox "No storage configuration has been changed\n\nYou may make hardware changes and run this setup again\n\nReturning to main menu" 20 60
  	      		;;
			
				esac
			else
			echo "Device found to be larger than 100GB, this is good"
			sleep 3
		
			CHOICE=$(whiptail --backtitle "Choose Drive Format" --title "PiNode-XMR Storage helper" --menu "Advanced setting:\n\nBy default PiNode-XMR will format the selected drive as 'EXT4'. This is a Linux type partition and will be fastest on this device. You may however select NTFS if you intend to copy the blockchain onto this device from another Windows computer.\n\n" 20 80 8 \
			"1)" "Format using Linux 'EXT4'"   \
			"2)" "Format using 'NTFS'" 2>&1 >/dev/tty)
	
				case $CHOICE in
				
			"1)")
			whiptail --title "WARNING" --msgbox "This drive will now be formatted as EXT4 for PiNode-XMR.\n\nALL DATA ON THE SELECTED DRIVE WILL BE DELETED IN THIS PROCESS\n\n\nUnplug the drive now if you do not want to loose the data!\n\nOr select Ok to continue." 20 60
			
			fn_wipeFilesystem
			fn_createExt4
			fn_setPermissions
			fn_addUuid

			whiptail --title "PiNode-XMR Storage Helper" --msgbox "Your selected drive has been configured as Linux filesystem ext4 labeled as 'XMRBLOCKCHAIN'\n\nIt has been mounted to /home/nodo/.bitmonero\nIt will auto mount to this location on system boot" 20 60
            ;;
			
			"2)")
			whiptail --title "WARNING" --msgbox "This drive will now be formatted as NTFS for PiNode-XMR.\n\nALL DATA ON THE SELECTED DRIVE WILL BE DELETED IN THIS PROCESS\n\n\nUnplug the drive now if you do not want to loose the data!\n\nOr select Ok to continue." 20 60

			fn_wipeFilesystem
			fn_createNtfs
			fn_setPermissions
			fn_addUuid

			whiptail --title "PiNode-XMR Storage Helper" --msgbox "Your selected drive has been configured as filesystem ntfs labeled as 'XMRBLOCKCHAIN'\n\nIt has been mounted to /home/nodo/.bitmonero\nIt will auto mount to this location on system boot" 20 60
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
           		 ;;
			
				"3)") echo whiptail --title "PiNode-XMR Storage Helper" --msgbox "No storage configuration has been changed\n\nYou may make hardware changes and run this setup again\n\nReturning to main menu" 20 60
          		 ;;
			
				esac
				else
				echo "Device found to be larger than 100GB, this is good"
				sleep 3
			fi
		
			CHOICE=$(whiptail --backtitle "Choose Drive Format" --title "PiNode-XMR Storage helper" --menu "Advanced setting:\n\nBy default PiNode-XMR will format the selected drive as 'EXT4'. This is a Linux type partition and will be fastest on this device. You may however select NTFS if you intend to copy the blockchain onto this device from another Windows computer.\n\n" 20 80 8 \
			"1)" "Format using Linux 'EXT4'"   \
			"2)" "Format using 'NTFS'" 2>&1 >/dev/tty)
	
			case $CHOICE in
			
			"1)")
			whiptail --title "WARNING" --msgbox "This drive will now be formatted as EXT4 for PiNode-XMR.\n\nALL DATA ON THE SELECTED DRIVE WILL BE DELETED IN THIS PROCESS\n\n\nUnplug the drive now if you do not want to loose the data!\n\nOr select Ok to continue." 20 60
			
			fn_wipeFilesystem
			fn_createExt4
			fn_setPermissions
			fn_addUuid

			whiptail --title "PiNode-XMR Storage Helper" --msgbox "Your selected drive has been configured as Linux filesystem ext4 labeled as 'XMRBLOCKCHAIN'\n\nIt has been mounted to /home/nodo/.bitmonero\nIt will auto mount to this location on system boot" 20 60
            ;;
			
			"2)")
			whiptail --title "WARNING" --msgbox "This drive will now be formatted as NTFS for PiNode-XMR.\n\nALL DATA ON THE SELECTED DRIVE WILL BE DELETED IN THIS PROCESS\n\n\nUnplug the drive now if you do not want to loose the data!\n\nOr select Ok to continue." 20 60
			
			fn_wipeFilesystem
			fn_createNtfs
			fn_setPermissions
			fn_addUuid
				
			whiptail --title "PiNode-XMR Storage Helper" --msgbox "Your selected drive has been configured as filesystem ntfs labeled as 'XMRBLOCKCHAIN'\n\nIt has been mounted to /home/nodo/.bitmonero\nIt will auto mount to this location on system boot" 20 60
            ;;
			
			esac

			else
			whiptail --title "PiNode-XMR Storage Helper" --msgbox "\n\nConfiguration aborted with no changes made\n\nReturning to main menu" 20 60
		fi
	fi
./setup.sh
