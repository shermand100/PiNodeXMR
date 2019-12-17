![PiNode-XMR logo](https://github.com/shermand100/pinode-xmr/blob/master/Screenshots-v0.6.19/PiNode-XMR%20logo.jpg)
# User Manual v0.6.19		
### Associated disk image 'PiNodeXMR-v0.6.19-v0.14.1.0'		(version optimised for SD card use)
#### Downloads
##### For Raspberry Pi
[PiNode-XMR-RPI2&3-v0.6.19-v0.14.1.0.img  5.2GB  Block 0](http://bit.ly/PiNodeXMR_v0619_v01410_block0img)

[PiNode-XMR-RPI2&3-v0.6.19-v0.14.1.0.img  78.1GB  Block 1860473](http://bit.ly/PiNode_XMR_v0619_v01410_block1860473_img)

##### For Odroid
[PiNode-XMR-ODROID-XU4-HC1&2-v0.6.19-v0.14.1.0.img 5GB Block 0](http://bit.ly/PiNode-XMR_ODROID-XU4-HC1-2)

*Hosting large image files such as the pre-sync'd version does come with it's costs. If you like the project or found the images helpful any contribution would be gratefully received:*

43HoAhqx9q3MR1crAjpQtYVhvzQhZgqPwSWVQMmPvYmr18qVUEjCHcsEasuCxS486rWSSg1gbGqanet67NWRsh1bQL9KkB9

## Hardware requirements:

1. Raspberry Pi 2/3 B or Odroid XU4/HC1/HC2
2. 128GB MicroSD Card (or larger)
3. Ethernet connection (can be replaced by WiFi after config)

A final point on the hardware. This node is designed to be used 'headless'. The HDMI cable, mouse and keyboard is not required. This should allow you to tuck the node away somewhere and all interactions can be made with a device (pc or mobile) that is connected to the same network (your home one in most cases).
With a little further configuration this node will allow wallet connections from your mobile app on the move.

## Contents:

* [Intro](https://github.com/shermand100/pinode-xmr#intro)
* [Setup](https://github.com/shermand100/pinode-xmr#setup)
* [Web-UI: Getting started & General Usage](https://github.com/shermand100/pinode-xmr#web-ui-starting-your-node-and-general-usage)
   * [Welcome Page](https://github.com/shermand100/pinode-xmr#welcome-page--)
   * [Advanced Settings & Starting Monero](https://github.com/shermand100/pinode-xmr#advanced-settings---starting-monero)
   * [Node Status](https://github.com/shermand100/pinode-xmr#node-status--)
   * [Transaction Status](https://github.com/shermand100/pinode-xmr#transaction-status)
   * [Connection Status](https://github.com/shermand100/pinode-xmr#connection-status)
   * [Log](https://github.com/shermand100/pinode-xmr#log)
   * [Web Terminal: WiFi setup, Pruning & Advances Users](https://github.com/shermand100/pinode-xmr#web-terminal-advanced-users-wi-fi-pruning-and-more)
      * [Updating](https://github.com/shermand100/pinode-xmr#web-terminal-updater)
* [A note on tor](https://github.com/shermand100/pinode-xmr#tor)
* [Connecting a Wallet -LAN](https://github.com/shermand100/pinode-xmr#connecting-a-wallet---lan)
  * [Monero GUI](https://github.com/shermand100/pinode-xmr#monero-gui)
  * [Monerujo app](https://github.com/shermand100/pinode-xmr#monerujo-app)
* [Connecting a wallet - External Connections](https://github.com/shermand100/pinode-xmr/blob/master/README.md#connecting-a-wallet---external-connections)
  * [IP address considerations](https://github.com/shermand100/pinode-xmr/blob/master/README.md#ip-address-considerations)
  * [Port Forwarding](https://github.com/shermand100/pinode-xmr/blob/master/README.md#port-forwarding)
  
## Intro

Then let me start by saying I'm glad the internet has bought you to here. It's taken several months to get to this point of the project, which in itself has been part of a multi year hobby creating nodes for cryptocurrencies and producing guides for beginners to follow along the way. This however is the first disk image I have ever produced for download, and I have no doubt in it's stability or ability to perform it's purpose, however it does mark a change in my direction. Throughout the years I've had many requests from users if they could purchase pre-made nodes and although this is not something my lifestyle can accommodate, it does signal that perhaps users don't want to make their own node step by step, they too have busy lifestyles, they want them fast. 

To that end I hope you find this latest project invaluable to running your own Monero node, fast. The initial sync however will take some time, and for that reason I also supply this node pre-sync'd as an image. Security for the device has been configured but every copy of this device currently has the same password as I set it. It is important you change it to something unique, this is detailed later on in this document.

Dan

*This Manual is still aimed at a low beginner level user including SD formatting and image writing. After these chapters and node usage you'll find detailed breakdowns of how this node works for those that are interested in contributing. Finally all suggested software used in the setup stages are downloadable for free*

## Setup:

The PiNode-XMR image is available to download as-is. It is un-compressed and ready to write using the same method you would for any other image. For those that are new these free programs will get you started:

1. Format the micro-sd card. For all users I recommend [SDFormatter](https://www.sdcard.org/downloads/formatter/)
2. Write the image file to the formatted card. 
   - Windows users [Win32DiskImager](https://sourceforge.net/projects/win32diskimager/)
   - Mac users [Etcher](https://etcher.io/)


Once complete insert the card into your device and power on.


On first time power-on the software will check to see if it has booted before. On it's first usage it will resize it's rootfs partition automatically to make best use of whichever size MicroSD card you've purchased ready for the Monero Blockchain.

During this process it will restart itself and will pause for 120 seconds. This is normal. I recommend that once plugged in simply leave the node for 5 mins, after this time it will have self configured and you will be safe to configure it as you wish (covered in a bit). 

Every subsequent power-on event will skip this step and immediately run the Monero software without delay in the condition it was last run in, Clearnet/tor/Mining. Pruned or not.

To continue with setup simply type the IP address of the Node into the web browser of a device . If you don't know how to find the IP address you can [read about some methods on the Raspberry Pi doc library.](https://www.raspberrypi.org/documentation/remote-access/ip-address.md) 

When you enter this IP address into the web browser of a device on the same network as your Node you'll be presented with the following screen...


![PiNode-XMR landing page](https://github.com/shermand100/pinode-xmr/blob/master/Screenshots-v0.6.19/index.png)

From here click on "Web Terminal" from the top navigation bar. You will most probably get a warning that it isn't a secure site. I haven't yet configured SSL certificates yet so this is normal. Click proceed and login with the default Username (all lowercase despite screenshot) and password of:

Username: pinodexmr
Password: PiNodeXMR

![PiNode-XMR web terminal](https://github.com/shermand100/pinode-xmr/blob/master/Screenshots-v0.6.19/webterminal-first.png)

From here enter as the screenshot shows to do the final setup phase which will allow you to set a new device password (for SSH, root and pinodexmr user), RPC username and password (this is the username and password you'll need to login to your device from an external Monero wallet, using the PiNode-XMR as remote node) and finally as an optional step to configure a noip.com client to allow dynamic DNS updates. 
For beginners this last optional step is because most internet connections and IP addresses provided by ISPs are dynamic and so change regularly. To keep the address of your PiNode-XMR static it is simplest to use hostnames instead. If you don't intend to use your node remotely and just for use with a local desktop wallet for example then the Dynamic DNS step can be skipped.

So once logged in enter: `./setup.sh` as shown in the screenshot

This brings you to the landing page:


![screenshot setup1](https://github.com/shermand100/pinode-xmr/blob/master/Screenshots-v0.6.19/setup1.png)

*A note here that this menu whilst functional does require some cosmetic tweaking and unfortunately if you break a parameter when entering new passwords the menu cycles back to the start, not just the section that failed. A work in progress.*

First of all you'll be asked to choose a new password for the device to replace the "PiNodeXMR" password you just used in this terminal.

**It must not be left blank, at least 8 characters long, standard AbC123 (Don't use uncommon special characters, spaces or quotes ' or " )**

A re-entry check will be carried out and then proceed to setting the RPC username and password. The same rules apply for password character entry.
Finally the option for Dynamic DNS client download via noip.com. If this is selected you will be prompted to make an account with NoIp.com first. Go to their website and create a free account. Once that has been verified continue with the PiNode-XMr menu and the client will download and configure itself, then asking for your NoIp.com login. Keep the update interval as default (30), and when asked to 'run something at successful update' enter 'N'. That configures the .conf file. You will be asked to enter this information again for the client and that's it. Setup Complete.

## Web-UI: Starting your Node and General Usage

### Welcome page -
I won't duplicate the homepage screenshot used above as there's not a lot to say about it apart from the PiNode-XMR version number (presented version.MM.YY). However a shout out to the guys at https://designmodo.com/ for the template of the Web-UI. Their template has made this build much quicker. Check out their site if you're ever in the need of an interface for a project.

I'll also take this opportunity to mention that most of the displays of Node and Hardware data within all the UI are updated every 60 seconds (with the exception of the 'storage usage' section on the 'Node Status' page which updates every 4 hours), so in most cases hammering the refresh button won't provide new data until it is sourced and processed in the background.

## Advanced Settings - Starting Monero

![Advanced Settings](https://github.com/shermand100/pinode-xmr/blob/master/Screenshots-v0.6.19/advancedsettings.png)

This is the main page for starting/stopping and setting variables on your node. It can either be started as a Clearnet,tor or Mining node, and you may switch between modes as you wish. The node has memory, so if power is lost and restored the node will reboot and continue in the mode it was last set (clearnet/tor/mining).

**To switch from one mode type to another use the appropriate stop button for the service that is running. To indicate which version is running your node will tell you on the “node status” page.
Stop the current service before starting a new one.**

- *Bandwidth:* Here are some drop-down boxes for you to interact with if you think the node is hogging too much of your network bandwidth. If you select a value from the list the new variable is  considered “pending”. It takes a node stop+start for changes to take effect.

- *Onion Address:* On your PiNode-XMR's first boot it generated a unique tor onion hostname to you. It is displayed here. 

- *Mining:* TBH it's a feature I expected people to ask for and it was simple enough to implement so it's included. The Raspberry Pi is absolutely unsuitable for this purpose, but there it is. 
Enter your address on the right and the page will confirm submission with a read-back. Hit start (once all previous instances of the node have been stopped) and enjoy your sub 1H/s. Setting mining intensity (default 50%) can  be found in the build/developer notes at the end of this manual.

- *Update:* This version has the auto-update removed. This is to prevent downtime at inconvenient times if you rely on this as a remote node. I will try new released Monero versions on my test node before activating your update button and inform you which “--strip” setting to use for the update. This seems the safest way to avoid bricking nodes.

- *Shutdown:* To gently shutdown+power off the node use the stop buttons as  normal and then hit this “shutdown” button. It will complete it's shutdown
 process in 60 seconds.

- *Kill:* (Not power off) Try not to use this, but it's there. I guess it's in case you cant remember what mode your node is in and the “status” page isn't helping. Ideally use each stop button in turn for a safe shutdown then maybe you could hit this to be sure? Dunno, this'll probably disappear in a future release.

## Node Status -

![Node Status](https://github.com/shermand100/pinode-xmr/blob/master/Screenshots-v0.6.19/nodestatus.png)

This is the go-to page for the overall health of the node showing summaries for the Monero software and you'll also find hardware info such as RAM usage, CPU temperature and storage usage. At the bottom of this page you'll also find a toggle button to enable/disable the 2GB swap file. This 2GB swap file is designed for use when asking the node to perform intensive tasks such as the initial sync, pruning or if you were to ever import a new blockchain from an external device. Under normal operation of the node once sync'd it is advised to disable the swapfile to preserve the read/write health of your storage device.

## Transaction Status

![Transaction Status](https://github.com/shermand100/pinode-xmr/blob/master/Screenshots-v0.6.19/transactions.png)

A very useful page. Here you can check to see if a transaction you have broadcast has done so successfully. Most web browsers have a search function (CTRL+F) use this to search the page by Transaction ID and if broadcast it will find it in the lower box.

The Overview above gives a picture of the general network condition and estimates (if there is a backlog) how long it will take to clear with full blocks.

## Connection Status

![Connection Status](https://github.com/shermand100/pinode-xmr/blob/master/Screenshots-v0.6.19/connectionstatus.png)

Displays OUT and IN peers along with their 'state' which is commonly either 'normal' or 'synchronising' it also gives some detail to data consumption.

The White/Grey list are nodes that are recently active/silent respectively. A healthy node should have plenty of 'white' nodes but the list ca take some time to grow.

That list of nodes is viewable in full at the bottom of the page.

## Log:

![Log](https://github.com/shermand100/pinode-xmr/blob/master/Screenshots-v0.6.19/logs.png)

A 5 MB rolling log is kept here. Should you suspect your node is not performing as it should you may find a clue as to why here. I strongly suggest that if you find [WARN] flags here that you consult google first. Monero is plenty developed by now that most questions have been answered by other users, and most warnings (once investigated of course) can be safely ignored and are connection related as peers drop off the network.

## Web-Terminal: Advanced Users (Wi-Fi, Pruning and more)

The Web-Terminal allows a more advanced user a huge amount of control over their node. The PiNode-XMR is built upon the Raspbian image "2019-04-08-raspbian-stretch-lite" and has all of the standard features intact.

- *WiFi:* One of the most asked for features is wifi. This can easily be configured at a beginner level *Note-ODROID has no built in hardware, additional Wifi adaptor required* ~as the standard command `sudo raspi-config` will bring up the Raspberry Pi's hardware interface. This allows setting Wi-Fi SSID and password under 'network options' settings. Once configured the device will ask to reboot.~ This is a known bug, sorry, I mis-configured the file it relates to. Instead for Wifi enter `sudo nano /etc/wpa_supplicant/wpa_supplicant.conf` Where you will find 2 fields to complete. Enter the SSID between the "" and password below. Leave the "" around what you enter. To leave the text editor save your changes with `ctrl+o` and exit with `ctrl+x` For the changes to take effect a reboot is required. `sudo reboot`

**However if Wi-Fi is to be used then the Ethernet cable must be unplugged. If you do not, the device will assign itself 2 IP addresses, one for each connection method, and Monerod will fail to boot**

- *Pruning:* I have tried to keep this as simple as possible for new users. For now it is enabled by entering one command in the web-terminal. It is necessary to stop your currently running Monerod using the buttons in the "advanced settings" page then in the web-terminal use `./monerod-prune.sh` to start the prune. By using the command this way the pruning binary will display it's progress and once complete will edit all start commands to use the pruning feature on future starts. The `./monerod-prune.sh` command can only be used once, and the node doesn't currently have a script to reverse the process. Once you have signalled your node to be a pruned node it is fixed as such. I will include instructions at a later date for how to revert back to full-node.

- *tor-arm:* Detailed bandwidth stats are available when running as a tor node using the ARM utility. (Available for Raspbery Pi image only) It is installed and running as default. To view these stats enter the command

`arm`
and when prompted for the controller password use: `PiNodeXMR`

![tor-ARM screenshot](https://github.com/shermand100/pinode-xmr/blob/a20080a60e69d095be5dac6382ad621f75d96c9c/Screenshots-v0.6.19/arm.png)

Exit the utility by using `CTRL+c`

 *Mining_Intensity:* The default mining intensity is set to 50% and is configurable through the web terminal command
 
     nano /home/pinodexmr/mining-intensity.sh
     
 Where the value '50' can be between 0-100. Save changes with > ctrl+O exit the editor with > ctrl+x.
 Monerod will require a restart for mining intensity changes to take effect. Carefully monitor your CPU temp, the Pi will auto-throttle CPU voltage at ~82'C

## Web-Terminal: Updater

The web terminal is also used to process the updates of the underlying monero version. 

The Process to update:

* Stop your running node with the relevent stop button in the 'advanced settings' tab.
* To update to Monero version 'Carbon Chamaeleon' 0.15, select '--strip 1' also on the 'advanvaced settings' tab.
* Log into the Web Terminal as usual and enter

        ./Updater.sh
   
The updater script will run and bring your node up to the latest version. At the end of the process it will then start your node in the last mode it was run.

## tor

Your PiNode-XMR utilises tor in Monero's default manner. To quote https://github.com/monero-project/monero#using-tor :

> ' The feature allows connecting over IPv4 and Tor simulatenously - IPv4 is used for relaying blocks and relaying transactions received by peers whereas Tor is used solely for relaying transactions received over local RPC. This provides privacy and better protection against surrounding node (sybil) attacks. '

and https://github.com/monero-project/monero/blob/master/ANONYMITY_NETWORKS.md#behavior :

> ' If any anonymity network is enabled, transactions being broadcast that lack a valid "context" (i.e. the transaction did not come from a p2p connection), will only be sent to peers on anonymity networks. If an anonymity network is enabled but no peers over an anonymity network are available, an error is logged and the transaction is kept for future broadcasting over an anonymity network. The transaction will not be broadcast unless an anonymity connection is made or until monerod is shutdown and restarted with only public connections enabled. '

## Connecting a Wallet - LAN
### Monero GUI
To use your Monero GUI on a device that is on the same local network as your node enter the IP address you have been using to view the interface into the remote node page of the GUI, port 18081 and the RPC username/password you set in the ./setup.sh menu. You may also select ' mark as trusted daemon ' as it's your trusted node.

![GUI-screenshot](https://github.com/shermand100/pinode-xmr/blob/master/Screenshots-v0.6.19/GUIremote.png)

Your wallet will then scan the node's blockchain for any transaction outputs that belong to your wallet, this can take a few minutes the first time but subsequent connections will only scan for changes since the last connection being much faster.

### Monerujo app
Unfortunatly the app won't allow a screenshot, but it's very similar to the GUI method.
With your mobile device connected by WiFi to the same network as your node simply enter the node IP in the 'hostname' field, port is 18081. 'Node name' is for your reference on your apps node list, call it what you want. Username and Password are required and are the RPC username and password you set in the ./setup.sh menu.

## Connecting a Wallet - External Connections

### IP address considerations

*Some background on this section...*

Most users of a PiNode-XMR node will be doing so from their domestic internet connection rather than through the internet connection of a large corporation. In almost all cases IP addresses are leased to you by your domestic internet provider, and that lease typically expires after a few days. When the lease expires on your IP address you may be given a new address or you may be re-assigned the same number for a few more days. This would happen without your knowledge and is completely normal.
Where this causes a problem for us is that we're reading this chapter with the view to connect our mobile wallet for example to our PiNode-XMR at home so we can spend our funds whilst on the go and out of range of our home WiFi. However if whilst we're "on the go" our home IP address were to change because what is called the DHCP lease expired we would not know our new IP address that was assigned to us and connection wouldn't be possible. So we have some options and everyone's situation will be different:

* Just hope it doesn't change
  * As simple as it sounds it really may not change for several months, you could keep getting leased the same IP but every service provider policy is different. Some users have been known to be re-leased the same IP over and over and others change frequently between addresses assigned to your area. You never know. You could get lucky.
* Ask your Internet Provider for a static IP.
  * Providers may be able to offer what's known as a static IP - one that doesn't expire. These however can come with a fee or are only available on their top tier packages. You get the idea but it can't hurt to ask.
* Dynamic DNS
  * This is a solution that is included with your PiNode-XMR if you wish to download and enable it. It can be found at the end of the ./setup.sh process.  The idea behind this is that you make an account with a Dynamic DNS provider, in this case noip.com. The company noip.com instead of giving you an IP address let you choose a hostname (for example I chose whilst trialling was pinodexmr.hopto.org). This can also be easier to remember. A small program runs on the PiNode-XMR that monitors it's public IP address and if a change is detected it notifies noip.com of the new IP address. Noip.com then updates it's index so when I request my wallet connection to pinodexmr.hopto.org noip.com refers the traffic to whatever my new public IP address is from it's index and I never have a problem with my dynamic IP address. It's worth mentioning that your internet traffic is not routed through them, they are what's known as a DNS server, the same as when you type www.bbc.co.uk a DNS server turns those words into an IP address and you are referred to your destination. Like an address book for the internet pointing traffic to it's destination.
  
 *There are lots of online services that provide Dynamic DNS and I plan to add more so you as a user have more choice. I've no affiliation with noip.com. I just chose them because they're free and have a simple linux installer. I should also mention their software is not installed on the PiNode-XMR by default, it is only downloaded if selected from the ./setup.sh script*
 
* VPN
  * Using a VPN you may be able to connect your mobile device to your home network so your wallet connects as though you are still at home. I have not used this method, but it may be the preferable method for privacy as all traffic from the wallet to the node would be encrypted, masking that you are even using Monero at all. {Community input?}

### Port forwarding

So once you've got an IP address that consistently points to the network the PiNode-XMR is in we're ready for the last step, port forwarding.

The IP address or hostname if you use Dynamic DNS points to your router. If you open your router settings you should see some options for port forwarding. The idea here is that you are going to tell the router that any external traffic it receives on port 18081 (Monero's RPC port) should be directed to the PiNode-XMR IP (usually 192.168.xx.xxx) and port 18081.

Every router has a different configuration menu so you may have to refer to it's manual if you're unsure. Alternatively there are some nice examples for multiple brands here with pictures.

https://www.noip.com/support/knowledgebase/general-port-forwarding-guide/

(I know noip.com again :) but they refer to how to check if your port is open using the hostname which may be of use if users take the Dynamic DNS route)

This then opens an internet connection to the outside world, it is therefore essential you have changed your password from the default to something long and un-guessable. I've also installed a program called fail2ban which should offer some additional protection. If an external user makes 3 unsuccessful login attempts within 10 minutes, their IP address is banned for 10 minutes. This helps mitigate against brute force attacks.

You can now connect your mobile wallet to your PiNode-XMR from anywhere in the world! Using your static IP or DNS hostname, port 18081 and the RPC username and password you set in ./setup.sh
