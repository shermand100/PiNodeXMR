#!/bin/bash

##Open Sources:
# Web-UI by designmodo Flat-UI free project at https://github.com/designmodo/Flat-UI
# Monero github https://github.com/moneroexamples/monero-compilation/blob/master/README.md
# Monero Blockchain Explorer https://github.com/moneroexamples/onion-monero-blockchain-explorer
# PiNode-XMR scripts and custom files at my repo https://github.com/shermand100/pinode-xmr
###Begin
##User pinodexmr creation
echo -e "\e[32mStep 1: produce user 'pinodexmr'\e[0m" 
sleep 2
sudo adduser pinodexmr --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "pinodexmr:PiNodeXMR" | sudo chpasswd
echo -e "\e[32mUser 'pinodexmr' created and password 'PiNodeXMR' set\e[0m"
sleep 2


##Replace file /etc/sudoers to set global sudo permissions/rules
echo -e "\e[32mDownlaod and replace /etc/sudoers file\e[0m"
sleep 2
wget https://raw.githubusercontent.com/shermand100/pinode-xmr/master/etc/sudoers
sudo chmod 0440 /home/pi/sudoers
sudo chown root /home/pi/sudoers
sudo mv /home/pi/sudoers /etc/sudoers
echo -e "\e[32mGlobal permissions changed\e[0m"
sleep 1

##Change from user 'pi' to 'pinodexmr' and lock 'pi'
echo -e "\e[32mSwitching user to 'pinodexmr'\e[0m"
sleep 1
sudo su pinodexmr && cd && ./raspbian-pinodexmr.sh

#End of script as user 'pi'. Continues in directory /home/pinodexmr

