#!/bin/sh

whiptail --title "PiNode-XMR Spy Node Detection" --ok-button NEXT --msgbox "This tool will compare your known network peers with a list of known 'spy' nodes." 20 78;
whiptail --title "PiNode-XMR Spy Node Detection" --ok-button NEXT --msgbox "It will make three comparisons, of decreasing severity.\nCurrently connected 'spy' Nodes\nWhite List 'spy' Nodes\nGray List 'spy' Nodes" 20 78;
whiptail --title "PiNode-XMR Spy Node Detection" --ok-button BEGIN --msgbox "Press next to compile these lists\n\nIt should only take a few moments" 20 78;

#Below Start of adapted Node connection status scripts

# use temp file 
_temp="./dialog.$$"

# Key - Boot_STATUS
# 2 = idle
# 3 || 5 = private node || mining node
# 4 = tor
# 6 = Public RPC pay
# 7 = Public free
# 8 = I2P
#Notes on how this works:
#1)Each status command is set as a variable and then on completion this variable is then returned into the file specified...
#The variable step is needed to prevent the previous stats file being overwritten to empty at the start of the command before the new stats are generated thus causing blank stats sections in the UI.
#2)I spent far too much time trying to incorporate 'target height' into the main status section, however this would often sit below the current height once sync'd...
#So next I used 'Current_Sync_Progress:((.result.height/.result.target_height)*100)|floor' to readout a percentage of sync'd rounded down to a whole number. This meant that when the current height was above target sync status read as 100%...
#However in tor mode target height sometimes outputs to 0 and the math fails killing the whole command. In the end the boolean 'Busy_Syncing:.result.busy_syncing' is used but not as pretty.

#Import Start Flag Values:
	#Establish Local IP
	. /home/pinodexmr/variables/deviceIp.sh
	#Load boot status - what condition was node last run
	. /home/pinodexmr/bootstatus.sh
	#Import unrestriced port number when running public node for internal use only
	. /home/pinodexmr/variables/monero-port-public-free.sh
	#Import Restricted Port Number (external use)	
	. /home/pinodexmr/variables/monero-port.sh
	#Import RPC username
	. /home/pinodexmr/variables/RPCu.sh
	#Import RPC password
	. /home/pinodexmr/variables/RPCp.sh

	#Load boot status - what condition was node last run
	. /home/pinodexmr/bootstatus.sh


	if [ $BOOT_STATUS -eq 2 ]
then	
		#System Idle
		echo "-- System Idle --" > /var/www/html/print_pl.txt
fi	
	
	if [ $BOOT_STATUS -eq 3 ] || [ $BOOT_STATUS -eq 5 ]
then	
		#Node Status
			PRINT_GPL="$(./monero/build/release/bin/monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT --rpc-login=${RPCu}:${RPCp}--rpc-ssl disabled print_pl | awk '$1=="gray" {print $3}')" && echo "$PRINT_GPL" > /home/pinodexmr/GPeerList.txt;
			PRINT_WPL="$(./monero/build/release/bin/monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT --rpc-login=${RPCu}:${RPCp} --rpc-ssl disabled print_pl | awk '$1=="white" {print $3}')" && echo "$PRINT_WPL" > /home/pinodexmr/WPeerList.txt;

fi

	if [ $BOOT_STATUS -eq 4 ]
then	
#Adapted command for tor rpc calls (payments) - RPC port and IP fixed due to tor hidden service settings linked in /etc/tor/torrc
			PRINT_PL="$(./monero/build/release/bin/monerod --rpc-bind-ip=${DEVICE_IP} --rpc-bind-port=18081 --rpc-login=${RPCu}:${RPCp} --rpc-ssl disabled print_pl | sed '1d' | sed 's/\x1b\[[0-9;]*m//g')" && echo "$PRINT_PL" > /var/www/html/print_pl.txt;
			date >> /var/www/html/print_pl.txt
fi

	if [ $BOOT_STATUS -eq 6 ]
then
		#Adapted command for restricted public rpc calls (payments)
			PRINT_GPL="$(./monero/build/release/bin/monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT --rpc-login=${RPCu}:${RPCp}--rpc-ssl disabled print_pl | awk '$1=="gray" {print $3}')" && echo "$PRINT_GPL" > /home/pinodexmr/GPeerList.txt;
			PRINT_WPL="$(./monero/build/release/bin/monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT --rpc-login=${RPCu}:${RPCp} --rpc-ssl disabled print_pl | awk '$1=="white" {print $3}')" && echo "$PRINT_WPL" > /home/pinodexmr/WPeerList.txt;
fi

	if [ $BOOT_STATUS -eq 7 ]
then
		#Adapted command for public free (restricted) rpc calls. No auth needed for local.
			PRINT_WPL="$(./monero/build/release/bin/monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PUBLIC_PORT --rpc-ssl disabled print_pl | awk '$1=="white" {print $3}')" && echo "$PRINT_WPL" > /home/pinodexmr/WPeerList.txt;
			PRINT_GPL="$(./monero/build/release/bin/monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PUBLIC_PORT --rpc-ssl disabled print_pl | awk '$1=="gray" {print $3}')" && echo "$PRINT_GPL" > /home/pinodexmr/GPeerList.txt;
			PRINT_CP="$(curl -s --digest -X POST http://${DEVICE_IP}:${MONERO_PUBLIC_PORT}/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_connections"}' -H 'Content-Type: application/json' | jq -Mr '.result.connections[] | .address," "')" && echo "$PRINT_CP" > /home/pinodexmr/CPeerList.txt

fi
	if [ $BOOT_STATUS -eq 8 ]
then	
		#Node Status
			PRINT_GPL="$(./monero/build/release/bin/monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT --rpc-login=${RPCu}:${RPCp}--rpc-ssl disabled print_pl | awk '$1=="gray" {print $3}')" && echo "$PRINT_GPL" > /home/pinodexmr/GPeerList.txt;
			PRINT_WPL="$(./monero/build/release/bin/monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT --rpc-login=${RPCu}:${RPCp} --rpc-ssl disabled print_pl | awk '$1=="white" {print $3}')" && echo "$PRINT_WPL" > /home/pinodexmr/WPeerList.txt;
fi

	if [ $BOOT_STATUS -eq 9 ]
then	
#Adapted command for tor rpc calls (payments) - RPC port and IP fixed due to tor hidden service settings linked in /etc/tor/torrc
			echo "It is not currently possible to retrieve connected peer information when running a public tor node." > /var/www/html/print_pl.txt
fi


#Download Ban_List
wget https://raw.githubusercontent.com/Boog900/monero-ban-list/refs/heads/main/ban_list.txt

#Sort Ban list ready for comm command
sort ban_list.txt > ban_list.sort

#Remove blank spaces from connected peer list lines
egrep -v " +" CPeerList.txt > CPeerList.rmspaces
mv CPeerList.rmspaces CPeerList.txt

#Trim port numbers from IPs of our node peer list to allow comparison
cat CPeerList.txt | rev | cut -c7- | rev > CPeerList.trim
cat WPeerList.txt | rev | cut -c7- | rev > WPeerList.trim
cat GPeerList.txt | rev | cut -c7- | rev > GPeerList.trim

sort CPeerList.trim > CPeerList.sort
sort WPeerList.trim > WPeerList.sort
sort GPeerList.trim > GPeerList.sort

#Remove trim list (no longer needed, now .sort)
rm CPeerList.trim
rm WPeerList.trim
rm GPeerList.trim

CONNECTED_PEERS_LIST_SIZE="$(wc -l < CPeerList.sort)"
WHITE_LIST_SIZE="$(wc -l < WPeerList.sort)"
GRAY_LIST_SIZE="$(wc -l < GPeerList.sort)"
BAN_LIST_SIZE="$(wc -l < ban_list.sort)"

NUM_CL_MATCHES="$(comm -12 CPeerList.sort ban_list.sort | wc -l)"
NUM_WL_MATCHES="$(comm -12 WPeerList.sort ban_list.sort | wc -l)"
NUM_GL_MATCHES="$(comm -12 GPeerList.sort ban_list.sort | wc -l)"

PC_CL_SATURATION=$(( $NUM_CL_MATCHES * 100 / $CONNECTED_PEERS_LIST_SIZE ))
PC_WL_SATURATION=$(( $NUM_WL_MATCHES * 100 / $WHITE_LIST_SIZE ))
PC_GL_SATURATION=$(( $NUM_GL_MATCHES * 100 / $GRAY_LIST_SIZE ))

whiptail --title "PiNode-XMR Spy Node Detection" --ok-button NEXT --msgbox "Size of Ban list (suspected Spy nodes) : $BAN_LIST_SIZE\nNumber of currently Connected Peers: $CONNECTED_PEERS_LIST_SIZE\nSize of White list: $WHITE_LIST_SIZE\nSize of Gray list: $GRAY_LIST_SIZE" 20 78;
whiptail --title "PiNode-XMR Spy Node Detection" --ok-button NEXT --msgbox "Number of currently Connected Peers: $CONNECTED_PEERS_LIST_SIZE\nYour Connected Peers matches to 'spy node' ban list $NUM_CL_MATCHES\nConnected Peer spy node saturation $PC_CL_SATURATION %" 20 78;
whiptail --title "PiNode-XMR Spy Node Detection" --ok-button NEXT --msgbox "Size of White list: $WHITE_LIST_SIZE\nWhite list spy node matches $NUM_WL_MATCHES\nWhite list spy node saturation $PC_WL_SATURATION %" 20 78;
whiptail --title "PiNode-XMR Spy Node Detection" --ok-button END --msgbox "Size of Gray list: $GRAY_LIST_SIZE\nGray list spy node matches $NUM_GL_MATCHES\nGray list spy node saturation $PC_GL_SATURATION %" 20 78;


echo "Size of Ban list (suspected Spy nodes) : $BAN_LIST_SIZE"
echo " "
echo "Number of currently Connected Peers to your node: $CONNECTED_PEERS_LIST_SIZE"
echo "Size of White list (Peers seen by other nodes ecently that you may connect to): $WHITE_LIST_SIZE"
echo "Size of Gray list (Not seen by your node but shared by others): $GRAY_LIST_SIZE"
echo " "
echo "Number of currently Connected Peers: $CONNECTED_PEERS_LIST_SIZE"
echo "Your Connected Peers that match to the 'spy node' ban list $NUM_CL_MATCHES"
echo "Connected Peer spy node saturation $PC_CL_SATURATION %"
echo " "
echo "Size of White list: $WHITE_LIST_SIZE"
echo "White list spy node matches $NUM_WL_MATCHES"
echo "White list spy node saturation $PC_WL_SATURATION %"
echo " "
echo "Size of Gray list: $GRAY_LIST_SIZE"
echo "Gray list spy node matches $NUM_GL_MATCHES"
echo "Gray list spy node saturation $PC_GL_SATURATION %"
echo " "
echo "End of Report"



#Cleanup
rm ban_list.txt
rm ban_list.sort
rm CPeerList.txt
rm CPeerList.sort
rm WPeerList.txt
rm WPeerList.sort
rm GPeerList.txt
rm GPeerList.sort