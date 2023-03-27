#!/bin/bash

#shellcheck source=home/nanode/common.sh
. /home/nanode/common.sh

NEW_VERSION="${1:-$(getvar "versions.monero")}"
#Error Log:
touch "$DEBUG_LOG"
echo "
####################
Start update-monero.sh script $(date)
####################
" 2>&1 | tee -a "$DEBUG_LOG"

#Download variable for current monero release version
#FIXME: change url
# wget -q https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/master/release.sh -O /home/nanode/release.sh
# RELEASE="$(curl -s https://raw.githubusercontent.com/monero-ecosystem/MoneroNanode/master/release.txt)"

#ubuntu /dev/null odd requiremnt to set permissions
sudo chmod 666 /dev/null

#Stop Node to make system resources available.
services-stop

showtext "Downloading Monero"

{
wget --no-verbose --show-progress --progress=dot:giga -O arm64 https://downloads.getmonero.org/arm64
mkdir dl
tar -xjvf arm64 -C dl
mv dl/*/monero* /usr/bin/
chmod a+x /usr/bin/monero*
} 2>&1 | tee -a "$DEBUG_LOG"

#Update system version number
putvar "current_version" "$NEW_VERSION"
#cleanup old version number file

#Define Restart Monero Node
		# Key - BOOT_STATUS
		# 2 = idle
		# 3 = private node
		# 4 = tor
		# 5 = Public RPC pay
		# 6 = Public free
		# 7 = I2P
		# 8 = tor public
services-start

##End debug log
log "Update Complete
####################
End setup-update-monero.sh script $(date)
####################"
