#!/bin/bash
#Load boot status - has node run before
. /home/pinodexmr/bootstatus.sh

if [ $BOOT_STATUS -lt 1 ]
then
	sudo raspi-config --expand-rootfs
	sleep "120"
	echo "#!/bin/sh
BOOT_STATUS=2" > /home/pinodexmr/bootstatus.sh
	sleep "2"
	#Output onion address
sudo cat /var/lib/tor/hidden_service/hostname > /var/www/html/onion-address.txt
	sleep "2"
	sudo reboot
	
else
. /home/pinodexmr/df-h.sh
. /home/pinodexmr/init.sh	
fi


