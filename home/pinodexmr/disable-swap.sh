#!/bin/bash
sudo swapoff -v /swapfile
sleep 3
free -h -w / > /var/www/html/free-h.txt