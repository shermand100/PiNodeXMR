# PiNode-XMR
SBC Plug and Play Monero Node.

#### To Use - Unzip and write Image to Micro SD (recommended 128GB Micro SD) insert into Pi and Power on.
#### The Pi will boot and adapt itself to your SD card size. During this process it will self restart allowing 120 seconds for partitions to settle to where they should be.

#### After 5 mins from power on the node will have started and be ready for interaction.

#### To interact with it you'll just need it's IP address and then navigate to it from your web browser (Chrome works well. And tips for how to find the IP address can be found on the Raspberry Pi website https://www.raspberrypi.org/documentation/remote-access/ip-address.md)

##### To Login using the Web based terminal use:
User: pinodexmr
Passwd: PiNodeXMR

once logged in it is recommended to enter    ./setup.sh    and follow through the menu to configure custom passwords for ssh/root/user and RPC user&password. Optional setting at the end to configure Dynamic DNS client if you intend on connecting to your node remotely.

*SSH on port 22

#### That's it. PiNodeXMR up and running. Once synced connect your Monero GUI with IP and Port 18081. The Web-UI is available from any device on your network PC/smartphone/tablet.

# _________________________________________________________


# Below is for info on its build...

visudo

**This section is what I feel most need review. Can it be made more secure?**

#User privilege specification

root	ALL=(ALL:ALL) ALL

pinodexmr ALL=NOPASSWD: ALL

www-data ALL=(ALL) NOPASSWD: /bin/systemctl start monerod-start.service, /bin/systemctl stop monerod-start.service, /bin/systemctl start monerod-reboot.service, /bin/systemctl start monerod-update.service, /sbin/shutdown now, /bin/systemctl start shutdown.service, /bin/systemctl start monerod-start-mining.service, /bin/systemctl stop monerod-start-mining.service, /bin/systemctl start monerod-start-tor.service, /bin/systemctl stop monerod-start-tor.service, /bin/systemctl start kill.service, /bin/systemctl start monerod-prune.service, /bin/systemctl start enable.service, /bin/systemctl start disable-swap.service

passwordless permission for www-data to run those commands only. The systemd service file is configured to then run binaries and command as user "pinodexmr".


*Dependencies - those in italics are for onion-blockexplorer which has not been included this release*

apache2 php7.0 libapache2-mod-php7.0 mysql-server mysql-client php7.0-mysql git screen exfat-fuse exfat-utils tor tor-arm shellinabox fail2ban ufw exfat-fuse exfat-utils *git build-essential cmake libboost-all-dev miniupnpc libunbound-dev graphviz doxygen libunwind8-dev pkg-config libssl-dev libcurl4-openssl-dev libgtest-dev libreadline-dev libzmq3-dev libsodium-dev libhidapi-dev libhidapi-libusb0*

*crontab - all flock managed tasks are scripts to output monerod ~status~ > ###.txt in the html folder for apache to display in the Web-UI*


* * * * * /home/pinodexmr/temp.sh
* 4 * * * /home/pinodexmr/df-h.sh
* * * * * /home/pinodexmr/free-h.sh
* * * * * /usr/bin/flock -n /home/pinodexmr/flock/status.lock /home/pinodexmr/monero-status.sh
* * * * * /usr/bin/flock -n /home/pinodexmr/flock/version.lock /home/pinodexmr/node_version.sh
* * * * * /usr/bin/flock -n /home/pinodexmr/flock/print_cn.lock /home/pinodexmr/print_cn.sh
* * * * * /usr/bin/flock -n /home/pinodexmr/flock/print_pl.lock /home/pinodexmr/print_pl.sh
* * * * * /usr/bin/flock -n /home/pinodexmr/flock/print_pl_stats.lock /home/pinodexmr/print_pl_stats.sh
* * * * * /usr/bin/flock -n /home/pinodexmr/flock/TXPool-short-status.lock /home/pinodexmr/TXPool-short-status.sh
* * * * * /usr/bin/flock -n /home/pinodexmr/flock/TXPool-status.lock /home/pinodexmr/TXPool-status.sh
* * * * * /usr/bin/flock -n /home/pinodexmr/flock/TXPool-verbose-status.lock /home/pinodexmr/TXPool-verbose-status.sh

This version Updater script has been removed from weekly cron. This is so as not to disturb node uptime if using node remotely. Update now via manual button in "advanced settings"

#UPDATER = Downloads https://raw.githubusercontent.com/shermand100/pinode-xmr/master/xmr-new-ver.sh which contains a file with the new arm7 monerod version number ONLY.
Updater script then compares this number with it's "current-version.sh" and only if the new version number is higher it:
Stops node -> Deletes current version and directory /home/pinodexmr/monero/ -> Creates new monero directory -> downloads new Monerod from https://downloads.getmonero.org/cli/linuxarm7 -> unpacks to /monero/ (--strip $strip), dir and starts updated node -> updates new version number -> deletes downloaded files


*disabled ipv6 ( IP address for monero node start (rpc bind) derived from command "hostname -I" ipv6 confuses the bind command and fails monerod )*

/boot/cmdline.txt appended with ipv6.disable=1

*Swap file toggle*

sudo dphys-swapfile swapoff/swapoff

*Auto boot running Monerod, edited  sudo nano /etc/rc.local*

su pinodexmr -c '/home/pinodexmr/boot.sh &'

*UFW setup*

ufw allow 80
ufw allow 443
ufw allow 18080
ufw allow 18081
ufw allow 4200
ufw allow 22
ufw enable

*ssh*
Root ssh login disabled, only user 'pinodexmr' allowed.

