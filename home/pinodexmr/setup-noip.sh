#!/bin/bash

#Configuration of Dynamic DNS service - instructions from https://www.noip.com/support/knowledgebase/installing-the-linux-dynamic-update-client/

sudo -- sh -c 'cd /usr/local/src/ && wget http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz && tar xf noip-duc-linux.tar.gz && cd noip-2.1.9-1/ && make install && /usr/local/bin/noip2 -C && /usr/local/bin/noip2'

whiptail --title "PiNode-XMR NoIP config" --msgbox "NoIP Dynamic DNS Installed.\n\nhit OK to return to main Menu" 8 78

./setup.sh