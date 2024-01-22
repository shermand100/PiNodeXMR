#!/bin/bash
sudo swapoff -a
sleep 3
free -h -w / > /var/www/html/free-h.txt