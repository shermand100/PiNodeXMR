![PiNode-XMR logo](https://github.com/shermand100/pinode-xmr/blob/master/Screenshots-v0.6.19/PiNode-XMR%20logo.jpg)
# User Manual v0.6.19		
### Associated disk image 'PiNodeXMR-v0.6.19-v0.14.1.0'		(version optimised for SD card use)

### Hardware requirements:

1. Raspberry Pi 3 B
2. 128GB MicroSD Card (or larger)
3. Ethernet connection

A final point on the hardware. This node is designed to be used 'headless'. The HDMI cable, mouse and keyboard is not required. This should allow you to tuck the node away somewhere and all interactions can be made with a device (pc or mobile) that is connected to the same network (your home one in most cases).

### Intro

Then let me start by saying I'm glad the internet has bought you to here. It's taken several months to get to this point of the project, which in itself has been part of a multi year hobby creating nodes for cryptocurrencies and producing guides for beginners to follow along the way. This however is the first disk image I have ever produced for download, and I have no doubt in it's stability or ability to perform it's purpose, however it does mark a change in my direction. Throughout the years I've had many requests from users if they could purchase pre-made nodes and although this is not something my lifestyle can accommodate, it does signal that perhaps users don't want to make their own node step by step, they too have busy lifestyles, they want them fast. 

To that end I hope you find this latest project invaluable to running your own Monero node, fast. The initial sync however will take some time, and for that reason I also supply this node pre-syn'd as an image. Security for the device has been configured but every copy of this device currently has the same password as I set it. It is important you change it to something unique, this is detailed later in in this document.

Dan

*This Manual is still aimed at a low beginner level user including un-compressing, SD formatting, image writing etc. After these chapters and node usage you'll find detailed breakdowns of how this node works for those that are interested in contributing. Finally all suggested software used in the setup stages are free*

### Setup:

The PiNode-XMR image is available to download as-is. It is un-compressed and ready to write using th same method you would for any other image. For those that are new these free programs will get you started:

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

From here click on "Web Terminal" from the top navigation bar. You will most probably get a warning that it isn't a secure site. I havn't yet configured SSL certificates yet so this is normal. Click proceed and login with the default Username (all lowercase despite screenshot) and password of:

Username: pinodexmr
Password: PiNodeXMR

![PiNode-XMR web terminal](https://github.com/shermand100/pinode-xmr/blob/master/Screenshots-v0.6.19/webterminal-first.png)

From here enter as the screenshot shows to do the final setup phase which will allow you to set a new device password (for SSH, root and pinodexmr user), RPC username and password (this is the username and password you'll need to login to your device from an external monero wallet, using the PiNode-XMR as remote node) and finally as an optional step to configure a noip.com client to allow dynamic DNS updates. 
For beginners this last optional step is because most internet connections and IP addresses provided by ISPs are dynamic and so change regulary. To keep the address of your PiNode-XMR static it is simplist to use hostnames instead. If you don't intend to use your node remotely and just for the benifit of a local desktop wallet for example then the Dynamic DNS step can be skipped.

So once logged in enter: `./setup.sh` as shown in the screenshot

This brings you to the landing page:
![screenshot setup1](https://github.com/shermand100/pinode-xmr/blob/master/Screenshots-v0.6.19/setup1.png)

*A note here that this menu whilst functional does require some cosmetic tweaking and unfortunatly if you break a parameter when entering new passwords the menu cycles back to the start, not just the section that failed. A work in progress.*

First of all you'll be asked to choose a new password for the device to replace the "PiNodeXMR" password you just used in this terminal. **It must not be left blank, at least 8 charcters long, standard AbC123 (Don't use uncommon special characters, spaces or quotes ' or " )**

A re-entry check will be carried out and then proceed to setting the RPC username and password. The same rules apply for password charcter entry.
Finally the option for Dynamic DNS client download via noip.com. If this is selected you will be promtped to make an account with noip.com first. Go to their website ansd create a free account. Once that has been verified continue with the PiNode-XMr menu and the client will download and configure itself, then asking for your Noip.com login. Keep the update interval as default (30), and when asked to 'run something at successful update' enter 'N'. That configures the .conf file. You will be asked to enter this information again for the client and that's it. Setup Complete.

## This manual is a work in progress, more coming soon
