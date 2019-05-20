#!/bin/bash
#Load boot status - has node run before
. /home/pinodexmr/bootstatus.sh

if [ $BOOT_STATUS -lt 1 ]
then
	sudo raspi-config --expand-rootfs
	echo "#!/bin/sh
BOOT_STATUS=2" > /home/pinodexmr/bootstatus.sh
	sleep "120"
	sudo reboot
	
else
. /home/pinodexmr/df-h.sh
. /home/pinodexmr/init.sh	
fi

