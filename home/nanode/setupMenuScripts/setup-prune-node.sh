#!/bin/bash
#Configure PiNode-XMR to run "Pruned"
#Load prune status - Has system already been pruned? 0 or 1
. /home/nanode/variables/pruneStatus.sh

if [ "$PRUNE_STATUS" -lt 1 ]
then
#Stop node if running
sudo systemctl stop monerodPrivate.service
sudo systemctl stop moneroMiningNode.service
sudo systemctl stop moneroTorPrivate.service
sudo systemctl stop moneroTorPublic.service
sudo systemctl stop moneroPublicFree.service
sudo systemctl stop moneroI2PPrivate.service
sudo systemctl stop moneroCustomNode.service
sudo systemctl stop moneroPublicRPCPay.service
		echo "Monerod stop command sent, allowing 30 seconds for safe shutdown"
		sleep 30
#Start prune binary
cd /home/nanode/monero/build/release/bin/
./monero-blockchain-prune
	
#Update prune status to show binary run
	echo "#!/bin/bash
PRUNE_STATUS=1" > /home/nanode/variables/pruneStatus.sh

#Append pruning to all start flags
echo " --prune-blockchain" >> /home/nanode/execScripts/moneroTorPublic.sh
echo " --prune-blockchain" >> /home/nanode/execScripts/moneroTorPrivate.sh
echo " --prune-blockchain" >> /home/nanode/execScripts/moneroMiningNode.sh
echo " --prune-blockchain" >> /home/nanode/execScripts/moneroPrivate.sh
echo " --prune-blockchain" >> /home/nanode/execScripts/moneroPublicFree.sh
echo " --prune-blockchain" >> /home/nanode/execScripts/moneroI2PPrivate.sh
echo " --prune-blockchain" >> /home/nanode/execScripts/moneroCustomNode.sh
echo " --prune-blockchain" >> /home/nanode/execScripts/moneroPublicRPCPay.sh

sleep "1"

whiptail --title "PiNode-XMR" --msgbox "Pune Process Complete" 16 60

else

		whiptail --title "PiNode-XMR running 'pruned'" --msgbox "Your PiNode-XMR is already 'pruned'" 16 60

fi

./setup.sh
