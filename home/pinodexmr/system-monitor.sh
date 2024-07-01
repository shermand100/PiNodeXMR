#!/bin/sh

(
	echo -n "This report generated " & date;
	echo -n "Status Scripts:" && sudo systemctl status moneroStatus.service | sed -n '3'p | cut -c13-;
	echo -n " Log-io Server:" && sudo systemctl status log-io-server.service | sed -n '3'p | cut -c13-;
	echo -n "   Log-io File:" && sudo systemctl status log-io-file.service | sed -n '3'p | cut -c13-;
	echo -n "  Private Node:" && sudo systemctl status moneroPrivate.service | sed -n '3'p | cut -c13-;
	echo -n "   Public Free:" && sudo systemctl status moneroPublicFree.service | sed -n '3'p | cut -c13-;
	echo -n "Public RPC Pay:" && sudo systemctl status moneroPublicRPCPay.service | sed -n '3'p | cut -c13-;
	echo -n "   Mining Node:" && sudo systemctl status moneroMiningNode.service | sed -n '3'p | cut -c13-;
	echo -n "      Tor Node:" && sudo systemctl status moneroTorPrivate.service | sed -n '3'p | cut -c13-;
	echo -n "    Tor Public:" && sudo systemctl status moneroTorPublic.service | sed -n '3'p | cut -c13-;
	echo -n "      I2P Node:" && sudo systemctl status moneroI2PPrivate.service | sed -n '3'p | cut -c13-;
	echo -n "   Custom Node:" && sudo systemctl status moneroCustomNode.service | sed -n '3'p | cut -c13-;
	echo -n "      Explorer:" && sudo systemctl status blockExplorer.service | sed -n '3'p | cut -c13-;
	echo -n " P2Pool Server:" && sudo systemctl status p2pool.service | sed -n '3'p | cut -c13-;
	echo -n "    Monero-LWS:" && sudo systemctl status monero-lws.service | sed -n '3'p | cut -c13-;
	echo -n "   Atomic Swap:" && sudo systemctl status atomic-swap.service | sed -n '3'p | cut -c13-;
	) > /var/www/html/iamrunning_version.txt
