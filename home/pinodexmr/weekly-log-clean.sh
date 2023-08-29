#!/bin/sh
#Delete duplicate log files - weekly crontab [Sunday 12pm]
rm /home/pinodexmr/.bitmonero/*bitmonero.log*
#P2Pool log may be large if logrotate fails
rm /home/pinodexmr/p2pool/build/p2pool.log
#Delete left over dialog files (created by failed inputs to password settings)
rm /home/pinodexmr/*dialog*
#Atomic Swap log may be large if logrotate fails
rm /home/pinodexmr/.atomicswap/mainnet/atomicSwap.log
#Monero wallet (for Atomic Swap) log may be large if logrotate fails
rm /home/pinodexmr/.atomicswap/mainnet/monero-wallet-rpc.log
