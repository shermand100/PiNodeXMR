#!/bin/bash
sudo systemctl stop monerod-start.service
sudo systemctl stop monerod-start-mining.service
sudo systemctl stop monerod-start-tor.service
#Shutdown
sudo shutdown