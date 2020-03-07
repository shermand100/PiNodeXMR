#!/bin/sh

(
	echo -n "This report generated " & date;
	echo -n "Private Node: " && sudo systemctl status monerod-start.service | sed -n '3'p | cut -c11-;
	echo -n "Mining  Node: " && sudo systemctl status monerod-start-mining.service | sed -n '3'p | cut -c11-;
	echo -n "Public  Node: " && sudo systemctl status monerod-start-public.service | sed -n '3'p | cut -c11-;
	echo -n "Tor     Node: " && sudo systemctl status monerod-start-tor.service | sed -n '3'p | cut -c11-;
	echo -n "Explorer    : " && sudo systemctl status explorer-start.service | sed -n '3'p | cut -c11-;
	) > /var/www/html/iamrunning_version.txt