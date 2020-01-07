#!/bin/bash

#Configuration of Dynamic DNS service - instructions from https://www.noip.com/support/knowledgebase/installing-the-linux-dynamic-update-client/

whiptail --title "PiNode-XMR NoIP config" --msgbox "You will need a no-ip.com username and login before configuring your PiNode-XMR\n\nRegister on their site before continuing.\nOnce you have registered select 'ok' here\n(A client will be downloaded to send updates to NO-IP.com DNS register)" 8 78

sudo -- sh -c 'cd /usr/local/src/ && wget http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz && tar xf noip-duc-linux.tar.gz && cd noip-2.1.9-1/ && make install && /usr/local/bin/noip2 -C && /usr/local/bin/noip2'

whiptail --title "PiNode-XMR NoIP config" --msgbox "NoIP Dynamic DNS Installed.\n\nhit OK to return to main Menu" 8 78

./setup.sh