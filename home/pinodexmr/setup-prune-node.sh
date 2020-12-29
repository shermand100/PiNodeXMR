#!/bin/bash
#Configure PiNode-XMR to run "Pruned"
#Load prune status - Has system already been pruned? 0 or 1
. /home/pinodexmr/prunestatus.sh

if [ $PRUNE_STATUS -lt 1 ]
then
#Stop node if running
		sudo systemctl stop monerod-start.service
		sudo systemctl stop monerod-start-mining.service
		sudo systemctl stop monerod-start-tor.service
		sudo systemctl stop monerod-start-public.service
		sudo systemctl stop monerod-start-i2p.service
		sudo systemctl stop monerod-start-free.service

		echo "Monerod stop command sent, allowing 30 seconds for safe shutdown"
		sleep 30
#Start prune binary
cd /home/pinodexmr/monero/build/release/bin/
./monero-blockchain-prune
	
#Update prune status to show binary run
	echo "#!/bin/bash
PRUNE_STATUS=1" > /home/pinodexmr/prunestatus.sh

#Append pruning to all start flags
echo " --prune-blockchain" >> /home/pinodexmr/monerod-start.sh
echo " --prune-blockchain" >> /home/pinodexmr/monerod-start-tor.sh
echo " --prune-blockchain" >> /home/pinodexmr/monerod-start-mining.sh
echo " --prune-blockchain" >> /home/pinodexmr/monerod-start-public.sh
echo " --prune-blockchain" >> /home/pinodexmr/monerod-start-public-free.sh
echo " --prune-blockchain" >> /home/pinodexmr/monerod-start-i2p.sh
sleep "1"
else

		whiptail --title "PiNode-XMR running 'pruned'" --msgbox "Your PiNode-XMR is already 'pruned'" 16 60

fi

./setup.sh
