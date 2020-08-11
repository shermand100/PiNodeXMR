#!/bin/bash
		sudo systemctl stop monerod-start.service
		sudo systemctl stop monerod-prune.service
		sudo systemctl stop monerod-start-free.service
		sudo systemctl stop monerod-start-mining.service
		sudo systemctl stop monerod-start-tor.service
		sudo systemctl stop monerod-start-i2p.service
		sudo systemctl stop monerod-start-public.service
		sudo systemctl stop explorer-start.service
#Shutdown
sudo shutdown