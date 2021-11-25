#!/bin/sh
#CPU temp Status

cpu=$(cat /sys/class/thermal/thermal_zone0/temp)
echo "$((cpu / 1000))'C" > /var/www/html/temp.txt
echo "Updates every 60 seconds" >> /var/www/html/temp.txt
echo `date` >> /var/www/html/temp.txt