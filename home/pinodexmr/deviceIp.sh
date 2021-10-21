#!/bin/sh
#Establish IP
DEVICE_IP="$(hostname -I | awk '{print $1}')"
