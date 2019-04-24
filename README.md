# pinode-xmr
SBC Plug and Play Monero Node. Auto-boot, Auto-update and WebUI

# To Use - Write Image to Micro SD (recommended 128GB Micro SD) insert into Pi and Power on.
# Find Pi IP address and navigate to it from your web browser (tips from https://www.raspberrypi.org/documentation/remote-access/ip-address.md)

# Login 
User: pinodexmr
Passwd: PiNodeXMR


#That's it. PiNodeXMR up and running. Connect your GUI with IP and Port 18081. Interface is available from any device on your network at the IP.

# ____________________________________________________________________________________________________


# Below is for info on its build...


# Create root user and PiNodeXMR user
# root and pi set to 9WNN5FPAlsmUzyLZ


#set pinodexmr sudo no password access in

sudo visudo

pinodexmr   ALL = NOPASSWD: ALL

# Dependencies

sudo apt-get install apache2 php7.0 libapache2-mod-php7.0 mysql-server mysql-client php7.0-mysql git screen shellinabox fail2ban ufw -y

# crontab - added - most are commands outputting to txt files for Web UI to read - All run once per minute unless otherwise stated

crontab -e

* * * * * /home/pinodexmr/temp.sh				#Output CPU temp to /var/www/html/
* 4 * * * /home/pinodexmr/df-h.sh				#Runs every 4 hours #Output SD card storage to /var/www/
* * * * * /home/pinodexmr/free-h.sh				#Output RAM usage to /var/www/html/
* * * * * /home/pinodexmr/monero-status.sh		#Output of ./monerod status to /var/www/html/
* * * * * /home/pinodexmr/node_version.sh		#Output of ./monerod version to /var/www/html/
* * * * * /home/pinodexmr/print_cn.sh			#Output of ./monerod print-cn to /var/www/html/
* * * * * /home/pinodexmr/print_pl.sh			
* * * * * /home/pinodexmr/print_pl_stats.sh
* * * * * /home/pinodexmr/TXPool-short-status.sh
* * * * * /home/pinodexmr/TXPool-status.sh
* * * * * /home/pinodexmr/TXPool-verbose-status.sh
* * * * 0 /home/pinodexmr/Updater.sh			#Runs weekly #Explained below

#UPDATER = Downloads https://raw.githubusercontent.com/shermand100/pinode-xmr/master/xmr-new-ver.sh which contains a file with the new arm7 monerod version number ONLY.
Updater script then compares this number with it's current version and only if the new version number is higher it:
Stops node -> Deletes current version and directory /home/pinodexmr/monero/ -> Creates new monero directory -> downloads new Monerod from https://downloads.getmonero.org/cli/linuxarm7 -> unpacks to /monero/ dir and starts updated node -> updates new version number -> deletes downloaded files -> repeats weekly.


# disabled ipv6 ( otherwise confused response from HOSTNAME command for IP address )

sudo nano /boot/cmdline.txt

ipv6.disable=1

# Swap file disabled - perhaps help preserve data on power loss

sudo dphys-swapfile swapoff
sudo dphys-swapfile uninstall
sudo update-rc.d dphys-swapfile remove

# Auto boot running Monerod, edited  sudo nano /etc/rc.local

su pinodexmr -c '/home/pinodexmr/boot.sh &'

# UFW setup

ufw allow 80
ufw allow 443
ufw allow 18080
ufw allow 18081
ufw allow 4200
ufw allow 22
ufw enable

# Root ssh login disabled, only user 'pinodexmr' allowed.
