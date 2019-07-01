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
