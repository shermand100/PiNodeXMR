#!/bin/sh
#CPU temp Status

{ sudo  cat /sys/devices/virtual/thermal/thermal_zone0/temp | awk '{ print ($1 / 1000) "°C" }' & echo "Updates every 60 seconds" & date; } > /var/www/html/temp.txt