#!/bin/bash
#Load prune status - Has system already been pruned? 0 or 1
. /home/pinodexmr/prunestatus.sh

sleep "1"


if [ $PRUNE_STATUS -lt 1 ]
then
#Start prune binary
	. /home/pinodexmr/monero/monero-blockchain-prune
	
#Update prune status to show binary run
	echo "#!/bin/bash
PRUNE_STATUS=1" > /home/pinodexmr/prunestatus.sh
#Show UI flag for user info
	echo "The pruning function has already been enabled and cannot be run again with this button. Please consult the manual for more info" > /var/www/html/prune-text.txt
#Append pruning to all start flags
echo " --prune-blockchain" >> /home/pinodexmr/monerod-start.sh
echo " --prune-blockchain" >> /home/pinodexmr/monerod-start-tor.sh
echo " --prune-blockchain" >> /home/pinodexmr/monerod-start-mining.sh
sleep "1"
else
	echo "Pruning command has already been run"

fi

#Notes:
#