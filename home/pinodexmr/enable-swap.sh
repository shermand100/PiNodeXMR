#!/bin/bash
dphys-swapfile swapon
sleep 3
free -h -w / > /var/www/html/free-h.txt