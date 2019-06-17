#!/bin/bash
#Function description - Systemd is used as the init service to control the start and running of Monerod. It monitors the Monero process and will attempt to reboot/recover if it fails. This script sends the safe shutdown command to monerod, tricking systemd into thinking the process has crashed. Then Systemd will auto-restart the Monerod process after 30 seconds, effecting a reboot.
#Stop Monerod
. ~/monerod-stop.sh
