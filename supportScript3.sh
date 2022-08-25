#!/bin/bash

##########
#supportScript #2
#This script's purpose is to be held in the PiNodeXMR online repository so as a dev I can aid a user who has a complex issue or customisiation request.
#It is triggered by the selection of supportScript #2 from the setup menu -> system settings -> support scripts
#3 scripts exist to allow for 3 simultanious support requests, each are independant from each other.
#By default this script will do nothing. Once a support request is completed this script will be reverted to default.
#This script does not persist on any users device (it is deleted at the end of initial install and subsequent updates within the cloned PiNode-XMR dir)
##########

###
#Start Default action below - no actions performed (Comment out as required)
whiptail --title "PiNode-XMR Support Script #2" --msgbox "This script has not been configured to provide support at this time\n\nNo Actions performed\n\nReturning to Menu" 12 78;
#End Default action 
###

###
#Start Assist User
# if (whiptail --title "PiNode-XMR Support Script #2" --yesno "This script will now perform actions on your device configured exclusively for the benefit of user: ### \n\nIf you are not intended user: ### these actions are likely to affect your device negatively\n\nWould you like to continue?" 12 78); then
#     #Insert required support/customisation commands here
# else
#     sleep 2
# fi
#End Assist User
###