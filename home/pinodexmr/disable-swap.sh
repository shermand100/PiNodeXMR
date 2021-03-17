#!/bin/bash
sudo dphys-swapfile swapoff
sudo systemctl disable dphys-swapfile.service
sleep 3
free -h -w / > /var/www/html/free-h.txt