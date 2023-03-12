#!/bin/sh
#Delete duplicate log files - weekly crontab [Sunday 12pm]
rm /home/nanode/.bitmonero/*bitmonero.log*
#P2Pool log may large if logrotate fails
rm /home/nanode/p2pool/build/p2pool.log
#Delete left over dialog files (created by failed inputs to password settings)
rm /home/nanode/*dialog*