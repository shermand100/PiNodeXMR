#!/bin/bash

##########
#supportScript #3
#This script's purpose is to be held in the PiNodeXMR online repository so as a dev I can aid a user who has a complex issue or customisiation request.
#It is triggered by the selection of supportScript #2 from the setup menu -> system settings -> support scripts
#3 scripts exist to allow for 3 simultanious support requests, each are independant from each other.
#By default this script will do nothing. Once a support request is completed this script will be reverted to default.
#This script does not persist on any users device (it is deleted at the end of initial install and subsequent updates within the cloned PiNode-XMR dir)
##########

###
#Start Default action below - no actions performed (Comment out as required)
#whiptail --title "PiNode-XMR Support Script #3" --msgbox "This script has not been configured to provide support at this time\n\nNo Actions performed\n\nReturning to Menu" 12 78;
#End Default action 
###

###
#Start Assist User
if (whiptail --title "PiNode-XMR Support Script #3" --yesno "This script is designed to replace your P2Pool build with the pre-compiled aarch64 version available at the official P2Pool GitHub repository\n\nWould you like to continue?" 12 78); then
    #Remove previous P2Pool directory
    rm -R p2pool
    #Download new P2Pool - v4.1 - File received as 'zip' file
    wget https://github.com/SChernykh/p2pool/releases/download/v4.1/p2pool-v4.1-linux-aarch64.tar.gz
    #Create new P2Pool directory - including /build to mimick correct path if building from source.
    mkdir -p ~/p2pool/build
    #Make temp folder to extract binaries
    mkdir temp && tar -xvf p2pool-v4.1-linux-aarch64.tar.gz -C ~/temp
    #Move P2Pool files to their standard location
    mv /home/pinodexmr/temp/p2pool-v4.1-linux-aarch64/* ~/p2pool/build
    #Delete downloaded 'zip' file
    rm p2pool-v4.1-linux-aarch64.tar.gz
    #Delete temp file
    rm -R /home/pinodexmr/temp/

whiptail --title "PiNode-XMR Support Script #2" --msgbox "Script complete\n\nP2Pool aarch64 binaries have been added to your node. Sorry for the inconvenience." 12 78;

else
    sleep 2
fi
#End Assist User
###