#!/bin/bash
sudo dphys-swapfile swapoff
sleep 3
free -h -w / > /var/www/html/free-h.txt