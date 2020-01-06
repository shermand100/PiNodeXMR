#!/bin/bash

##User pinodexmr creation
echo -e "\e[32mStep 1 produce user 'pinodexmr'\e[0m" 
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
sudo su pinodexmr
cd
echo -e "\e[32mLock old user 'pi'\e[0m"
sleep 1
sudo passwd --lock pi
echo -e "\e[32mUser 'pi' Locked\e[0m"
sleep 1

##Update and Upgrade system
echo -e "\e[32mReceiving and applying Raspbian updates to latest versions\e[0m"
sleep 2
sudo apt-get update && sudo apt-get upgrade -y