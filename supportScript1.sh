#!/bin/bash

##########
#supportScript #1
#This script's purpose is to be held in the PiNodeXMR online repository so as a dev I can aid a user who has a complex issue or customisiation request.
#It is triggered by the selection of supportScript #1 from the setup menu -> system settings -> support scripts
#3 scripts exist to allow for 3 simultanious support requests, each are independant from each other.
#By default this script will do nothing. Once a support request is completed this script will be reverted to default.
#This script does not persist on any users device (it is deleted at the end of initial install and subsequent updates within the cloned PiNode-XMR dir)
##########

###
#Start Default action below - no actions performed (Comment out as required)
# whiptail --title "PiNode-XMR Support Script #1" --msgbox "This script has not been configured to provide support at this time\n\nNo Actions performed\n\nReturning to Menu" 12 78;
#End Default action 
###

###
#Start Assist User
if (whiptail --title "PiNode-XMR Support Script #1" --yesno "This script will now perform actions on your device configured exclusively for the benefit of user: EL4955 \n\nThis script will download and install the pre-compiled Monerod for Raspberry Pi 5 hardware.\n\nWould you like to continue?" 12 78); then
#Remove current monero installation
rm -r /home/pinodexmr/monero/build/release/bin/*
#Download Monero Arm
wget https://downloads.getmonero.org/cli/linuxarm8
#Make temp folder to extract binaries
mkdir temp && tar -xvf linuxarm8 -C ~/temp
#Move Monerod files to standard location
mv /home/pinodexmr/temp/monero-aarch64-linux-gnu-v0.18*/monero* /home/pinodexmr/monero/build/release/bin/
rm linuxarm8
rm -R /home/pinodexmr/temp/
whiptail --title "Install complete" --msgbox "Monero pre-compiled Arm8 binaries have been downloaded and installed \n\nSelect ok to return to menu" 16 60

else
    sleep 2
fi
#End Assist User
###
