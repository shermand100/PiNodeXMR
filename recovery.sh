#!/bin/bash
# Try to get system to a working state again

#shellcheck source=home/nanode/common.sh
. /home/nanode/common.sh

# Run an update just to be sure
apt-get update --fix-missing -y

# Force Apt to look for and correct any missing dependencies or broken packages when you attempt to install the offending package again. This will install any missing dependencies and repair existing installs
apt-get install -fy

# Reconfigure any broken or partially configured packages
dpkg --configure -a

apt clean

apt update

services-stop

# if $PURGE_BLOCKCHAIN is set (to anything), purge the blockchain
if [ -z ${PURGE_BLOCKCHAIN+x} ]; then
	rm -rf "/run/media/nanode/bitmonero/lmdb"
fi

services-start

