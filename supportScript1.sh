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
if (whiptail --title "PiNode-XMR Support Script #1" --yesno "This script will download and install the pre-compiled Monerod for your detected hardware.\n\nWould you like to continue?" 12 78); then
#Remove current monero installation
#rm -r /home/pinodexmr/monero/build/release/bin/*

#Establish OS 32 or 64 bit
ARCH=`dpkg --print-architecture`
echo "dpkg --print-architecture is $ARCH" >> /home/pinodexmr/debug.log
# Translate dpkg output to URL extension with error catch
case "$ARCH" in
    "amd64")
        TYPE="64"
        ;;
    "arm64")
        TYPE="arm8"
        ;;
    "armhf")
        TYPE="arm7"
        ;;
    "riscv64")
        TYPE="riscv64"
        ;;
    "i386")
        TYPE="32"
        ;;
    *)
        echo "Error: Unsupported architecture '$ARCH'"
        echo "Error: Unsupported architecture '$ARCH'" >> /home/pinodexmr/debug.log
        exit 1
        ;;
esac

echo -e "\e[32mDownloading for architecture: $ARCH ...\e[0m"
sleep 2
URL="https://downloads.getmonero.org/cli/linux${TYPE}"
wget "$URL"

#Make temp folder to extract binaries
mkdir temp
tar -xvf linux${TYPE} -C ~/temp
#Move Monerod files to standard location
    #Create location
    mkdir -p /home/pinodexmr/monero/build/release/bin/
    #Move to Location
    mv /home/pinodexmr/temp/monero*/monero* /home/pinodexmr/monero/build/release/bin/
#Cleanup source package
rm linux${TYPE}
rm -R /home/pinodexmr/temp/
#Done
whiptail --title "Install complete" --msgbox "Monero pre-compiled '$ARCH' binaries have been downloaded and installed \n\nSelect ok to return to menu" 16 60

else
    sleep 2
fi
#End Assist User
###
