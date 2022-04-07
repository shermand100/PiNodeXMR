#!/bin/sh

(
	echo -n "This report generated " & date;
	echo -n "Status Scripts: " && sudo systemctl status statusOutputs.service | sed -n '3'p | cut -c13-;
	echo -n "Log-io Server: " && sudo systemctl status log-io-server.service | sed -n '3'p | cut -c13-;
	echo -n "Log-io File: " && sudo systemctl status log-io-file.service | sed -n '3'p | cut -c13-;	
	echo -n "Private Node: " && sudo systemctl status monerod-start.service | sed -n '3'p | cut -c13-;
	echo -n "Public  Free: " && sudo systemctl status monerod-start-free.service | sed -n '3'p | cut -c13-;
	echo -n "Public RPC Pay: " && sudo systemctl status monerod-start-public.service | sed -n '3'p | cut -c13-;		
	echo -n "Mining  Node: " && sudo systemctl status monerod-start-mining.service | sed -n '3'p | cut -c13-;
	echo -n "Tor     Node: " && sudo systemctl status monerod-start-tor.service | sed -n '3'p | cut -c13-;
	echo -n "Tor Public  : " && sudo systemctl status monerod-start-tor-public.service | sed -n '3'p | cut -c13-;
	echo -n "I2P     Node: " && sudo systemctl status monerod-start-i2p.service | sed -n '3'p | cut -c13-;
	echo -n "Custom  Node: " && sudo systemctl status monerod-custom.service | sed -n '3'p | cut -c13-;		
	# echo -n "Explorer    : " && sudo systemctl status explorer-start.service | sed -n '3'p | cut -c13-;
	echo -n "P2Pool Server: " && sudo systemctl status p2pool-start.service | sed -n '3'p | cut -c13-;
	echo -n "Monero-LWS  : " && sudo systemctl status monero-lws.service | sed -n '3'p | cut -c13-;	
	) > /var/www/html/iamrunning_version.txt