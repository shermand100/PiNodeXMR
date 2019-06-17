#!/bin/bash
#IP tables rule for Tor
sudo iptables -I OUTPUT -p tcp -d 127.0.0.1 -m tcp --dport 18081 -j ACCEPT
#Load boot status - what condition was node last run
. /home/pinodexmr/bootstatus.sh

#Establish IP
	DEVICE_IP="$(hostname -I)"
	echo "Your PiNode-XMR IP is: ${DEVICE_IP}"
	sleep "1"
#Download update file
	sleep "1"
	wget -q https://raw.githubusercontent.com/shermand100/pinode-xmr/master/xmr-new-ver.sh -O xmr-new-ver.sh
	echo "Version Info recieved:"
#Permission Setting
	chmod 755 /home/pinodexmr/current-ver.sh
	chmod 755 /home/pinodexmr/xmr-new-ver.sh
#Load Variables
. /home/pinodexmr/current-ver.sh
. /home/pinodexmr/xmr-new-ver.sh
. /home/pinodexmr/monero-port.sh
echo $NEW_VERSION 'New Version'
echo $CURRENT_VERSION 'Current Version'
echo $DEVICE_IP 'Device IP'
echo $MONERO_PORT 'Monero Port'
sleep "3"
if [ $CURRENT_VERSION -lt $NEW_VERSION ]
then
	rm -rf /home/pinodexmr/monero
	echo "Deleting Old Version"
	sleep "2"
	mkdir /home/pinodexmr/monero
	wget https://downloads.getmonero.org/cli/linuxarm7
	tar -xvf ./linuxarm7 -C /home/pinodexmr/monero --strip 2
	echo "Software Update Complete - Resuming Node if not first boot"
	sleep "2"
	echo "Tidying up leftover installation packages"
	#Clean-up stage
	#Update system version number
	echo "#!/bin/bash
CURRENT_VERSION=$NEW_VERSION" > /home/pinodexmr/current-ver.sh
	#Remove downloaded version check file
	rm /home/pinodexmr/xmr-new-ver.sh
	rm /home/pinodexmr/linuxarm7
else
	echo "Your node is up to date"

fi

if [ $BOOT_STATUS -eq 2 ]
then
		echo "Fist boot complete, system ready for first run command. See web-ui at $(hostname -I) for launch buttons."
else
	echo "loading ."	
fi

if [ $BOOT_STATUS -eq 3 ]
then
	sudo systemctl start monerod-start.service
	echo "Monero Node Started in background"
else
	echo "loading .."
fi

if [ $BOOT_STATUS -eq 4 ]
then
	sudo systemctl start monerod-start-tor.service
	echo "Monero tor Node Started in background"
else
		echo "loading ..."
fi

if [ $BOOT_STATUS -eq 5 ]
then
	sudo systemctl start monerod-start-mining.service
	echo "Monero Solo Mining Node Started in background"
else
		echo "loading ..."
fi
#Notes:
#