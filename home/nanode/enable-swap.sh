#!/bin/bash
sudo swapon /swapfile
sleep 3
free -h -w / > /var/www/html/free-h.txt