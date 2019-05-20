#!/bin/bash
#Stop Monerod
. ~/monerod-stop.sh
#Wait for process end
sleep "30"
#Start Monerod
. ~/monerod-start.sh