#!/bin/sh

	#Load explorer start status - explorer commanded to run or not?
	. /home/pinodexmr/explorer-flag.sh

if [ $EXPLORER_START -eq 1 ]
then
sudo systemctl restart explorer-start.service
else
fi
