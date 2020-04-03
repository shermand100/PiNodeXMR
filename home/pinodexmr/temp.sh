#!/bin/sh
#CPU temp Status
{ sudo  cat /sys/class/thermal/thermal_zone1/temp | awk '{ print ($1 / 1000) "°C" }' & echo "Updates every 60 seconds" & date; } > /var/www/html/temp.txt