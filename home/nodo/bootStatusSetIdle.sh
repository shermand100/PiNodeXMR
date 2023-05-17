#!/bin/sh
#On stopping node, revert "boot status" to mode 2. Prevents stopped node re-starting on auto-boot until manual command is sent.
. /home/nodo/common.sh
putvar "boot_status" "2"
