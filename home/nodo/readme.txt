# To Use - Write Image to Micro SD (recommended 128GB Micro SD) insert into Pi and Power on.
# Find Pi IP address and navigate to it from your web browser (tips from https://www.raspberrypi.org/documentation/remote-access/ip-address.md)

# Login 
User: nodo
Passwd: PiNodeXMR


#That's it. PiNodeXMR up and running. Connect your GUI with IP you used above and Port 18081. Interface is available from any device on your network at the IP you used.

# ____________________________________________________________________________________________________


# For info on it's build...


# Create root user and PiNodeXMR user
# root and pi set to 9WNN5FPAlsmUzyLZ


#set nodo sudo no password access in

sudo visudo

nodo   ALL = NOPASSWD: ALL

# Dependencies

sudo apt-get install apache2 php7.0 libapache2-mod-php7.0 mysql-server mysql-client php7.0-mysql git screen shellinabox fail2ban ufw -y

# crontab - added - most are commands outputting to txt files for Web UI to read - All run once per minute unless otherwise stated

crontab -e

* * * * * /home/nodo/temp.sh				#Output CPU temp to /var/www/html/
* 4 * * * /home/nodo/df-h.sh				#Runs every 4 hours #Output SD card storage to /var/www/
* * * * * /home/nodo/free-h.sh				#Output RAM usage to /var/www/html/
* * * * * /home/nodo/monero-status.sh		#Output of ./monerod status to /var/www/html/
* * * * * /home/nodo/node_version.sh		#Output of ./monerod version to /var/www/html/
* * * * * /home/nodo/print_cn.sh			#Output of ./monerod print-cn to /var/www/html/
* * * * * /home/nodo/print_pl.sh			
* * * * * /home/nodo/print_pl_stats.sh
* * * * * /home/nodo/TXPool-short-status.sh
* * * * * /home/nodo/TXPool-status.sh
* * * * * /home/nodo/TXPool-verbose-status.sh
* * * * 0 /home/nodo/Updater.sh			#Runs weekly #Explained below

#UPDATER = Downloads https://raw.githubusercontent.com/shermand100/pinode-xmr/master/xmr-new-ver.sh which contains a file with the new arm7 monerod version number ONLY.
Updater script then compares this number with it's current version and only if the new version number is higher it:
Stops node -> Deletes current version and directory /home/nodo/monero/ -> Creates new monero directory -> downloads new Monerod from https://downloads.getmonero.org/cli/linuxarm7 -> unpacks to /monero/ dir and starts updated node -> updates new version number -> deletes downloaded files -> repeats weekly.


# disabled ipv6 ( otherwise confused response from HOSTNAME command for IP address )

sudo nano /boot/cmdline.txt

ipv6.disable=1

# Swap file disabled - perhaps help preserve data on power loss

sudo dphys-swapfile swapoff
sudo dphys-swapfile uninstall
sudo update-rc.d dphys-swapfile remove

# Auto boot running Monerod, edited  sudo nano /etc/rc.local

su nodo -c '/home/nodo/boot.sh &'

# UFW setup

ufw allow 80
ufw allow 443
ufw allow 18080
ufw allow 18081
ufw allow 4200
ufw allow 22
ufw enable

# Root ssh login disabled, only user 'nodo' allowed.