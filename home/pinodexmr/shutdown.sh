#!/bin/bash
#Stop Monerod
sudo systemctl stop monerod-start.service
#Allow time for Monerod to stop
sleep "60"
#Shutdown
sudo shutdown now