#!/bin/sh
#Delete duplicate log files - weekly crontab [Sunday 12pm]
rm /home/nodo/.bitmonero/*bitmonero.log*
#Delete left over dialog files (created by failed inputs to password settings)
rm /home/nodo/*dialog*
