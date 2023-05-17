#!/bin/bash
# Just a root wrapper for the update scripts. Bit silly, I know

#shellcheck source=home/nodo/common.sh
. /home/nodo/common.sh

sudo -u nodo bash /home/nodo/update-nodo.sh
sudo -u nodo bash /home/nodo/update-monero.sh
sudo -u nodo bash /home/nodo/update-lws.sh
sudo -u nodo bash /home/nodo/update-explorer.sh

# Restart services afterwards,
# otherwise the device would be nothing more than a very warm brick
services-stop

services-start
