#!/bin/sh
#On stopping node, revert "boot status" to mode 2. Prevents stopped node re-starting on auto-boot until manual command is sent.
	echo "#!/bin/sh
BOOT_STATUS=2" > /home/pinodexmr/bootstatus.sh
