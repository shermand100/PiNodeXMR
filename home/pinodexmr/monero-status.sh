#!/bin/sh
#Establish IP/Port
DEVICE_IP="$(hostname -I | awk '{print $1}')"
#Import Start Flag Values:
	#Load boot status - what condition was node last run
	. /home/pinodexmr/bootstatus.sh
	#Import Restricted Port Number (external use)
	. /home/pinodexmr/monero-port.sh
	#Import RPC username
	. /home/pinodexmr/RPCu.sh
	#Import RPC password
	. /home/pinodexmr/RPCp.sh

# Key -
# 2 = idle
# 3 || 5 = private node || mining node
# 4 = tor
# 6 = Public RPC pay
# 7 = Public free
# 8 = I2P

# use temp file 
_temp="./dialog.$$"
	
	if [ $BOOT_STATUS -eq 2 ]
then	
		#System Idle
		echo "--System Idle--\nSelect a mode for your PiNode-XMR to start on the \"Node Control\" page.\nThen allow at least 5 minutes for stats to appear here. " > /var/www/html/Node_Status.txt
fi	
	
	
	if [ $BOOT_STATUS -eq 3 ] || [ $BOOT_STATUS -eq 5 ]
then	
		#Node Status
			#Status with % (legacy stats)
			#OUTPUT="$(./monero/build/release/bin/monerod --rpc-bind-ip=${DEVICE_IP} --rpc-bind-port=${MONERO_PORT} --rpc-login=${RPCu}:${RPCp} --rpc-ssl disabled status | sed -n 's/Height:/&/p')" && echo "$OUTPUT" > /var/www/html/Node_Status.txt
				#JSON output
				curl -su ${RPCu}:${RPCp} --digest -X POST http://${DEVICE_IP}:${MONERO_PORT}/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_info"}' -H 'Content-Type: application/json' | cat -s | jq -Mr {"Monero_Version:.result.version,Node_Status:.result.status,Current_Sync_Height:.result.height,Target_Block_Height:.result.target_height,Outgoing_Connections:.result.outgoing_connections_count,Incoming_Connections:.result.incoming_connections_count,Network_Type:.result.nettype,TX_Pool_Size:.result.tx_pool_size,White_Peerlist_Size:.result.white_peerlist_size,Grey_Peerlist_Size:.result.grey_peerlist_size,Update_Available:.result.update_available"} | sed 's/"//g;s/{//g;s/}//g;s/,//g;s/_/ /g;s/^$/ /g;' > /var/www/html/Node_Status.txt

fi

#tor
	if [ $BOOT_STATUS -eq 4 ]
then
		#Adapted command for tor rpc calls (payments) - RPC port and IP fixed due to tor hidden service settings linked in /etc/tor/torrc
			#Status with % (legacy stats)
			#OUTPUT="$(./monero/build/release/bin/monerod --rpc-bind-ip=127.0.0.1 --rpc-bind-port=18081 --rpc-login=${RPCu}:${RPCp} --rpc-ssl disabled status | sed -n 's/Height:/&/p')" && echo "$OUTPUT" > /var/www/html/Node_Status.txt
				#JSON output
				curl -su ${RPCu}:${RPCp} --digest -X POST http://127.0.0.1:${MONERO_PORT}/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_info"}' -H 'Content-Type: application/json' | cat -s | jq -Mr {"Monero_Version:.result.version,Node_Status:.result.status,Current_Sync_Height:.result.height,Target_Block_Height:.result.target_height,Outgoing_Connections:.result.outgoing_connections_count,Incoming_Connections:.result.incoming_connections_count,Network_Type:.result.nettype,TX_Pool_Size:.result.tx_pool_size,White_Peerlist_Size:.result.white_peerlist_size,Grey_Peerlist_Size:.result.grey_peerlist_size,Update_Available:.result.update_available"} | sed 's/"//g;s/{//g;s/}//g;s/,//g;s/_/ /g;s/^$/ /g;' > /var/www/html/Node_Status.txt
fi

	
	if [ $BOOT_STATUS -eq 6 ]
then
		#Adapted command for restricted public rpc calls (payments)
			#OUTPUT="$(./monero/build/release/bin/monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT --rpc-ssl disabled status | sed -n 's/Height:/&/p')" && echo "$OUTPUT" > /var/www/html/Node_Status.txt
			#JSON output
			curl -su --digest -X POST http://${DEVICE_IP}:${MONERO_PORT}/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_info"}' -H 'Content-Type: application/json' | cat -s | jq -Mr {"Monero_Version:.result.version,Node_Status:.result.status,Current_Sync_Height:.result.height,Target_Block_Height:.result.target_height,Outgoing_Connections:.result.outgoing_connections_count,Incoming_Connections:.result.incoming_connections_count,Network_Type:.result.nettype,TX_Pool_Size:.result.tx_pool_size,White_Peerlist_Size:.result.white_peerlist_size,Grey_Peerlist_Size:.result.grey_peerlist_size,Update_Available:.result.update_available"} | sed 's/"//g;s/{//g;s/}//g;s/,//g;s/_/ /g;s/^$/ /g;' > /var/www/html/Node_Status.txt

fi

	if [ $BOOT_STATUS -eq 7 ]
then
		#Adapted command for public free (restricted) rpc calls. No auth needed for local.
			#OUTPUT="$(./monero/build/release/bin/monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT --rpc-ssl disabled status | sed -n 's/Height:/&/p')" && echo "$OUTPUT" > /var/www/html/Node_Status.txt
			#JSON output
			curl -su --digest -X POST http://${DEVICE_IP}:${MONERO_PORT}/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_info"}' -H 'Content-Type: application/json' | cat -s | jq -Mr {"Monero_Version:.result.version,Node_Status:.result.status,Current_Sync_Height:.result.height,Target_Block_Height:.result.target_height,Outgoing_Connections:.result.outgoing_connections_count,Incoming_Connections:.result.incoming_connections_count,Network_Type:.result.nettype,TX_Pool_Size:.result.tx_pool_size,White_Peerlist_Size:.result.white_peerlist_size,Grey_Peerlist_Size:.result.grey_peerlist_size,Update_Available:.result.update_available"} | sed 's/"//g;s/{//g;s/}//g;s/,//g;s/_/ /g;s/^$/ /g;' > /var/www/html/Node_Status.txt

fi

#I2p
	if [ $BOOT_STATUS -eq 8 ]
then
		#Adapted command for tor rpc calls (payments)
			#OUTPUT="$(./monero/build/release/bin/monerod --rpc-bind-ip=$DEVICE_IP --rpc-bind-port=$MONERO_PORT --rpc-login=${RPCu}:${RPCp} --rpc-ssl disabled status | sed -n 's/Height:/&/p')" && echo "$OUTPUT" > /var/www/html/Node_Status.txt
				#JSON output
				curl -su ${RPCu}:${RPCp} --digest -X POST http://${DEVICE_IP}:${MONERO_PORT}/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_info"}' -H 'Content-Type: application/json' | cat -s | jq -Mr {"Monero_Version:.result.version,Node_Status:.result.status,Current_Sync_Height:.result.height,Target_Block_Height:.result.target_height,Outgoing_Connections:.result.outgoing_connections_count,Incoming_Connections:.result.incoming_connections_count,Network_Type:.result.nettype,TX_Pool_Size:.result.tx_pool_size,White_Peerlist_Size:.result.white_peerlist_size,Grey_Peerlist_Size:.result.grey_peerlist_size,Update_Available:.result.update_available"} | sed 's/"//g;s/{//g;s/}//g;s/,//g;s/_/ /g;s/^$/ /g;' > /var/www/html/Node_Status.txt

fi
