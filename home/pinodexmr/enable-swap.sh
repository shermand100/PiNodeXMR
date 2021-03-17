#!/bin/bash
sudo dphys-swapfile swapon
sudo systemctl enable dphys-swapfile.service
sleep 3
free -h -w / > /var/www/html/free-h.txt