#!/bin/sh
#CPU temp Status
{
temp=$(cat /sys/devices/virtual/thermal/thermal_zone0/temp)
echo $(( temp / 1000 )) C
echo "Updates every 60 seconds" &
date;
} > test.txt
