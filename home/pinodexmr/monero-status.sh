#!/bin/sh

# use temp file 
_temp="./dialog.$$"

# Key -
# 2 = idle
# 3 || 5 = private node || mining node
# 4 = tor
# 6 = Public RPC pay
# 7 = Public free
# 8 = I2P
# 9 tor public
#Notes on how this works:
#1)Each status command is set as a variable and then on completion this variable is then returned into the file specified...
#The variable step is needed to prevent the previous stats file being overwritten to empty at the start of the command before the new stats are generated thus causing blank stats sections in the UI.
#2)I spent far too much time trying to incorporate 'target height' into the main status section, however this would often sit below the current height once sync'd...
#So next I used 'Current_Sync_Progress:((.result.height/.result.target_height)*100)|floor' to readout a percentage of sync'd rounded down to a whole number. This meant that when the current height was above target sync status read as 100%...
#However in tor mode target height sometimes outputs to 0 and the math fails killing the whole command. In the end the boolean 'Busy_Syncing:.result.busy_syncing' is used but not as pretty.

#Define user customisable variables
defineVariables () {

#Import Start Flag Values:
	#Establish Local IP
	DEVICE_IP="$(hostname -I | awk '{print $1}')"
	#Load boot status - what condition was node last run
	. /home/pinodexmr/bootstatus.sh
	#Import Restricted Port Number (external use)
	. /home/pinodexmr/monero-port.sh
	#Import RPC username
	. /home/pinodexmr/RPCu.sh
	#Import RPC password
	. /home/pinodexmr/RPCp.sh

}

#Define status functions

	#Sync status
	syncStatus () {
	
	#Load boot status - what condition was node last run
	. /home/pinodexmr/bootstatus.sh

	if [ $BOOT_STATUS -eq 2 ]
then	
		#System Idle
		echo "--System Idle-- 
		Select a mode for your PiNode-XMR to start on the 'Node Control' page. Then allow at least 5 minutes for stats to appear here. " > /var/www/html/Node_Status.txt
fi	
	
	
	if [ $BOOT_STATUS -eq 3 ] || [ $BOOT_STATUS -eq 5 ]
then	
		#Node Status
				STATUS="$(curl -su ${RPCu}:${RPCp} --digest -X POST http://${DEVICE_IP}:${MONERO_PORT}/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_info"}' -H 'Content-Type: application/json' | cat -s | jq -Mr {"Monero_Version:.result.version,Node_Status:.result.status,Busy_Syncing:.result.busy_syncing,Current_Sync_Height:.result.height,P2P_Outgoing_Connections:.result.outgoing_connections_count,P2P_Incoming_Connections:.result.incoming_connections_count,RPC_Connections_Count:.result.rpc_connections_count,Network_Type:.result.nettype,TX_Pool_Size:.result.tx_pool_size,White_Peerlist_Size:.result.white_peerlist_size,Grey_Peerlist_Size:.result.grey_peerlist_size,Update_Available:.result.update_available"} | sed 's/"//g;s/{//g;s/}//g;s/,//g;s/_/ /g;s/^$/ /g;')" && echo "$STATUS" > /var/www/html/Node_Status.txt
		#Time stamps added temporarily to better identify most recent stats, (not frozen/old data from browser cache).
				date >> /var/www/html/Node_Status.txt
fi

#tor
	if [ $BOOT_STATUS -eq 4 ]
then
		#Adapted command for tor rpc calls (payments) - RPC port and IP fixed due to tor hidden service settings linked in /etc/tor/torrc
				STATUS="$(curl -su ${RPCu}:${RPCp} --digest -X POST http://${DEVICE_IP}:${MONERO_PORT}/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_info"}' -H 'Content-Type: application/json' | cat -s | jq -Mr {"Monero_Version:.result.version,Node_Status:.result.status,Busy_Syncing:.result.busy_syncing,Current_Sync_Height:.result.height,P2P_Outgoing_Connections:.result.outgoing_connections_count,P2P_Incoming_Connections:.result.incoming_connections_count,RPC_Connections_Count:.result.rpc_connections_count,Network_Type:.result.nettype,TX_Pool_Size:.result.tx_pool_size,White_Peerlist_Size:.result.white_peerlist_size,Grey_Peerlist_Size:.result.grey_peerlist_size,Update_Available:.result.update_available"} | sed 's/"//g;s/{//g;s/}//g;s/,//g;s/_/ /g;s/^$/ /g;')" && echo "$STATUS" > /var/www/html/Node_Status.txt
				date >> /var/www/html/Node_Status.txt
fi

	
	if [ $BOOT_STATUS -eq 6 ]
then
		#Adapted command for restricted public rpc calls (payments)
			STATUS="$(curl -su ${RPCu}:${RPCp} --digest -X POST http://${DEVICE_IP}:${MONERO_PORT}/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_info"}' -H 'Content-Type: application/json' | cat -s | jq -Mr {"Monero_Version:.result.version,Node_Status:.result.status,Busy_Syncing:.result.busy_syncing,Current_Sync_Height:.result.height,P2P_Outgoing_Connections:.result.outgoing_connections_count,P2P_Incoming_Connections:.result.incoming_connections_count,RPC_Connections_Count:.result.rpc_connections_count,Network_Type:.result.nettype,TX_Pool_Size:.result.tx_pool_size,White_Peerlist_Size:.result.white_peerlist_size,Grey_Peerlist_Size:.result.grey_peerlist_size,Update_Available:.result.update_available"} | sed 's/"//g;s/{//g;s/}//g;s/,//g;s/_/ /g;s/^$/ /g;')" && echo "$STATUS" > /var/www/html/Node_Status.txt
			date >> /var/www/html/Node_Status.txt

fi

	if [ $BOOT_STATUS -eq 7 ]
then
		#Adapted command for public free (restricted) rpc calls. No auth needed for local.
			STATUS="$(curl -s --digest -X POST http://${DEVICE_IP}:${MONERO_PORT}/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_info"}' -H 'Content-Type: application/json' | cat -s | jq -Mr {"Monero_Version:.result.version,Node_Status:.result.status,Busy_Syncing:.result.busy_syncing,Current_Sync_Height:.result.height,P2P_Outgoing_Connections:.result.outgoing_connections_count,P2P_Incoming_Connections:.result.incoming_connections_count,RPC_Connections_Count:.result.rpc_connections_count,Network_Type:.result.nettype,TX_Pool_Size:.result.tx_pool_size,White_Peerlist_Size:.result.white_peerlist_size,Grey_Peerlist_Size:.result.grey_peerlist_size,Update_Available:.result.update_available"} | sed 's/"//g;s/{//g;s/}//g;s/,//g;s/_/ /g;s/^$/ /g;')" && echo "$STATUS" > /var/www/html/Node_Status.txt
			date >> /var/www/html/Node_Status.txt
fi

	if [ $BOOT_STATUS -eq 8 ]
then
		#Adapted command for i2p rpc calls (payments)
				STATUS="$(curl -su ${RPCu}:${RPCp} --digest -X POST http://${DEVICE_IP}:${MONERO_PORT}/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_info"}' -H 'Content-Type: application/json' | cat -s | jq -Mr {"Monero_Version:.result.version,Node_Status:.result.status,Busy_Syncing:.result.busy_syncing,Current_Sync_Height:.result.height,P2P_Outgoing_Connections:.result.outgoing_connections_count,P2P_Incoming_Connections:.result.incoming_connections_count,RPC_Connections_Count:.result.rpc_connections_count,Network_Type:.result.nettype,TX_Pool_Size:.result.tx_pool_size,White_Peerlist_Size:.result.white_peerlist_size,Grey_Peerlist_Size:.result.grey_peerlist_size,Update_Available:.result.update_available"} | sed 's/"//g;s/{//g;s/}//g;s/,//g;s/_/ /g;s/^$/ /g;')" && echo "$STATUS" > /var/www/html/Node_Status.txt

fi

#tor public
	if [ $BOOT_STATUS -eq 9 ]
then
		#Adapted command for tor rpc calls (payments) - RPC port and IP fixed due to tor hidden service settings linked in /etc/tor/torrc
				STATUS="$(curl --digest -X POST http://${DEVICE_IP}:${MONERO_PORT}/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_info"}' -H 'Content-Type: application/json' | cat -s | jq -Mr {"Node_Status:.result.status,Busy_Syncing:.result.busy_syncing,Current_Sync_Height:.result.height,Network_Type:.result.nettype,TX_Pool_Size:.result.tx_pool_size,Update_Available:.result.update_available"} | sed 's/"//g;s/{//g;s/}//g;s/,//g;s/_/ /g;s/^$/ /g;')" && echo "$STATUS" > /var/www/html/Node_Status.txt
				date >> /var/www/html/Node_Status.txt
fi
		sleep 20
	}

	#connectionStatus function
	connectionStatus () {

	#Load boot status - what condition was node last run
	. /home/pinodexmr/bootstatus.sh

	if [ $BOOT_STATUS -eq 2 ]
then	
		#System Idle
		echo "--System Idle--" > /var/www/html/print_cn.txt
fi	
	
	
	if [ $BOOT_STATUS -eq 3 ] || [ $BOOT_STATUS -eq 5 ]
then	
		#Node Status
	PRINT_CN="$(curl -su ${RPCu}:${RPCp} --digest -X POST http://${DEVICE_IP}:${MONERO_PORT}/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_connections"}' -H 'Content-Type: application/json' | jq -Mr '.result.connections[] | "Connected to:","Node ID: "+.peer_id,"Connection ID: "+.connection_id,"Node IP: "+.address,"State: "+.state,"Node height: "+(.height|tostring),"Incoming connection: "+(.incoming|tostring),"Sent count: "+(.send_count|tostring),"Receive count: "+(.recv_count|tostring)," "')" && echo "$PRINT_CN" > /var/www/html/print_cn.txt
	date >> /var/www/html/print_cn.txt
fi	

	if [ $BOOT_STATUS -eq 4 ]
then	
		#Adapted command for tor rpc calls (payments) - RPC port and IP fixed due to tor hidden service settings linked in /etc/tor/torrc
	PRINT_CN="$(./monero/build/release/bin/monerod --rpc-bind-ip=${DEVICE_IP} --rpc-bind-port=18081 --rpc-login=${RPCu}:${RPCp} --rpc-ssl disabled print_cn | sed '1d')" && echo "$PRINT_CN" > /var/www/html/print_cn.txt
	date >> /var/www/html/print_cn.txt

fi

	
	if [ $BOOT_STATUS -eq 6 ]
then
		#Adapted command for restricted public rpc calls (payments)
	PRINT_CN="$(curl -s --digest -X POST http://${DEVICE_IP}:${MONERO_PORT}/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_connections"}' -H 'Content-Type: application/json' | jq -Mr '.result.connections[] | "Connected to:","Node ID: "+.peer_id,"Connection ID: "+.connection_id,"Node IP: "+.address,"State: "+.state,"Node height: "+(.height|tostring),"Incoming connection: "+(.incoming|tostring),"Sent count: "+(.send_count|tostring),"Receive count: "+(.recv_count|tostring)," "')" && echo "$PRINT_CN" > /var/www/html/print_cn.txt

fi

	if [ $BOOT_STATUS -eq 7 ]
then
		#Adapted command for public free (restricted) rpc calls. No auth needed for local.
	PRINT_CN="$(curl -s --digest -X POST http://${DEVICE_IP}:${MONERO_PORT}/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_connections"}' -H 'Content-Type: application/json' | jq -Mr '.result.connections[] | "Connected to:","Node ID: "+.peer_id,"Connection ID: "+.connection_id,"Node IP: "+.address,"State: "+.state,"Node height: "+(.height|tostring),"Incoming connection: "+(.incoming|tostring),"Sent count: "+(.send_count|tostring),"Receive count: "+(.recv_count|tostring)," "')" && echo "$PRINT_CN" > /var/www/html/print_cn.txt
	date >> /var/www/html/print_cn.txt
fi

	if [ $BOOT_STATUS -eq 8 ]
then	
		#Node connections I2P
	PRINT_CN="$(curl -su ${RPCu}:${RPCp} --digest -X POST http://${DEVICE_IP}:${MONERO_PORT}/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_connections"}' -H 'Content-Type: application/json' | jq -Mr '.result.connections[] | "Connected to:","Node ID: "+.peer_id,"Connection ID: "+.connection_id,"Node IP: "+.address,"State: "+.state,"Node height: "+(.height|tostring),"Incoming connection: "+(.incoming|tostring),"Sent count: "+(.send_count|tostring),"Receive count: "+(.recv_count|tostring)," "')" && echo "$PRINT_CN" > /var/www/html/print_cn.txt

fi

	if [ $BOOT_STATUS -eq 9 ]
then	
		#Adapted command for tor rpc calls (payments) - RPC port and IP fixed due to tor hidden service settings linked in /etc/tor/torrc
	echo "It is not currently possible to retrieve connected peer information when running a public tor node." > /var/www/html/print_cn.txt

fi
		sleep 20
	}

	#txPoolStatus
	txPoolStatus () {

	#Load boot status - what condition was node last run
	. /home/pinodexmr/bootstatus.sh

	if [ $BOOT_STATUS -eq 2 ]
then	
		#System Idle
		echo "--System Idle--" > /var/www/html/TXPool_Status.txt
fi	
	
	if [ $BOOT_STATUS -eq 3 ] || [ $BOOT_STATUS -eq 5 ]
then	
		#Node Status
		PRINT_POOL_STATS="$(./monero/build/release/bin/monerod --rpc-bind-ip=${DEVICE_IP} --rpc-bind-port=${MONERO_PORT} --rpc-login=${RPCu}:${RPCp} --rpc-ssl disabled print_pool_stats | sed '1d' | sed 's/\x1b\[[0-9;]*m//g')" && echo "$PRINT_POOL_STATS" > /var/www/html/TXPool_Status.txt
		date >> /var/www/html/TXPool_Status.txt
fi	

	if [ $BOOT_STATUS -eq 4 ]
then	
		#Adapted command for tor rpc calls (payments) - RPC port and IP fixed due to tor hidden service settings linked in /etc/tor/torrc
		PRINT_POOL_STATS="$(./monero/build/release/bin/monerod --rpc-bind-ip=${DEVICE_IP} --rpc-bind-port=18081 --rpc-login=${RPCu}:${RPCp} --rpc-ssl disabled print_pool_stats | sed '1d' | sed 's/\x1b\[[0-9;]*m//g')" && echo "$PRINT_POOL_STATS" > /var/www/html/TXPool_Status.txt
fi	
	
	if [ $BOOT_STATUS -eq 6 ]
then
		#Adapted command for restricted public rpc calls (payments)
		PRINT_POOL_STATS="$(./monero/build/release/bin/monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT --rpc-ssl disabled print_pool_stats | sed '1d' | sed 's/\x1b\[[0-9;]*m//g')" && echo "$PRINT_POOL_STATS" > /var/www/html/TXPool_Status.txt
fi

	if [ $BOOT_STATUS -eq 7 ]
then
		#Adapted command for public free (restricted) rpc calls. No auth needed for local.
		PRINT_POOL_STATS="$(./monero/build/release/bin/monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT --rpc-ssl disabled print_pool_stats | sed '1d' | sed 's/\x1b\[[0-9;]*m//g')" && echo "$PRINT_POOL_STATS" > /var/www/html/TXPool_Status.txt
		date >> /var/www/html/TXPool_Status.txt
fi

	if [ $BOOT_STATUS -eq 8 ]
then	
		#I2p Node Status
		PRINT_POOL_STATS="$(./monero/build/release/bin/monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT --rpc-login=${RPCu}:${RPCp} --rpc-ssl disabled print_pool_stats | sed '1d' | sed 's/\x1b\[[0-9;]*m//g')" && echo "$PRINT_POOL_STATS" > /var/www/html/TXPool_Status.txt
fi

	if [ $BOOT_STATUS -eq 9 ]
then	
		#Adapted command for tor rpc calls (payments) - RPC port and IP fixed due to tor hidden service settings linked in /etc/tor/torrc
		PRINT_POOL_STATS="$(./monero/build/release/bin/monerod --rpc-bind-ip=${DEVICE_IP} --rpc-bind-port=18081 --rpc-ssl disabled print_pool_stats | sed '1d' | sed 's/\x1b\[[0-9;]*m//g')" && echo "$PRINT_POOL_STATS" > /var/www/html/TXPool_Status.txt
fi
		sleep 20
	}

	#txPoolPending
	txPoolPending () {

	#Load boot status - what condition was node last run
	. /home/pinodexmr/bootstatus.sh

			if [ $BOOT_STATUS -eq 2 ]
then	
		#System Idle
		echo "--System Idle--" > /var/www/html/TXPool-short_Status.txt
fi	
	
	if [ $BOOT_STATUS -eq 3 ] || [ $BOOT_STATUS -eq 5 ]
then	
		#Node Status
		PRINT_TX_SHORT="$(./monero/build/release/bin/monerod --rpc-bind-ip=${DEVICE_IP} --rpc-bind-port=${MONERO_PORT} --rpc-login=${RPCu}:${RPCp} --rpc-ssl disabled print_pool_sh | sed '1d' | sed 's/\x1b\[[0-9;]*m//g')" && echo "$PRINT_TX_SHORT" > /var/www/html/TXPool-short_Status.txt
		date >> /var/www/html/TXPool-short_Status.txt
fi	

	if [ $BOOT_STATUS -eq 4 ]
then	
		#Adapted command for tor rpc calls (payments) - RPC port and IP fixed due to tor hidden service settings linked in /etc/tor/torrc
		PRINT_TX_SHORT="$(./monero/build/release/bin/monerod --rpc-bind-ip=${DEVICE_IP} --rpc-bind-port=18081 --rpc-login=${RPCu}:${RPCp} --rpc-ssl disabled print_pool_sh | sed '1d' | sed 's/\x1b\[[0-9;]*m//g')" && echo "$PRINT_TX_SHORT" > /var/www/html/TXPool-short_Status.txt
fi
	
	if [ $BOOT_STATUS -eq 6 ]
then
		#Adapted command for restricted public rpc calls (payments)
		PRINT_TX_SHORT="$(./monero/build/release/bin/monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT --rpc-ssl disabled print_pool_sh | sed '1d' | sed 's/\x1b\[[0-9;]*m//g')" && echo "$PRINT_TX_SHORT" > /var/www/html/TXPool-short_Status.txt
fi

	if [ $BOOT_STATUS -eq 7 ]
then
		#Adapted command for public free (restricted) rpc calls. No auth needed for local.
		PRINT_TX_SHORT="$(./monero/build/release/bin/monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT --rpc-ssl disabled print_pool_sh | sed '1d' | sed 's/\x1b\[[0-9;]*m//g')" && echo "$PRINT_TX_SHORT" > /var/www/html/TXPool-short_Status.txt
		date >> /var/www/html/TXPool-short_Status.txt
fi

	if [ $BOOT_STATUS -eq 8 ]
then	
		#I2p Node Status
		PRINT_TX_SHORT="$(./monero/build/release/bin/monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT --rpc-login=${RPCu}:${RPCp} --rpc-ssl disabled print_pool_sh | sed '1d' | sed 's/\x1b\[[0-9;]*m//g')" && echo "$PRINT_TX_SHORT" > /var/www/html/TXPool-short_Status.txt
fi

	if [ $BOOT_STATUS -eq 9 ]
then	
		#Adapted command for tor rpc calls (payments) - RPC port and IP fixed due to tor hidden service settings linked in /etc/tor/torrc
		PRINT_TX_SHORT="$(./monero/build/release/bin/monerod --rpc-bind-ip=${DEVICE_IP} --rpc-bind-port=18081 --rpc-ssl disabled print_pool_sh | sed '1d' | sed 's/\x1b\[[0-9;]*m//g')" && echo "$PRINT_TX_SHORT" > /var/www/html/TXPool-short_Status.txt
fi
		sleep 20
	}



#Call status functions and loop indefinately:
while true; do
defineVariables
syncStatus
connectionStatus
txPoolStatus
txPoolPending
done