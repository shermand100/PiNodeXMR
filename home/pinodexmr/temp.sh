#!/bin/sh
#CPU temp Status
{
echo "Updates every 60 seconds" &
temp=$(cat /sys/devices/virtual/thermal/thermal_zone0/temp)
echo $(( temp / 1000 )) C &
date;
} > /var/www/html/temp.txt
