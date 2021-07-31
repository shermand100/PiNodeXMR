![PiNode-XMR logo](https://github.com/monero-ecosystem/PiNode-XMR/blob/master/Screenshots/PiNode-XMR%20logo.jpg)
# Quick Start Guide v4.21.06-Open-Build		
### This page is a quick overview to get you started. A complete and comprehensive manual showing all features can be found here at the Wiki: [Full Manual](https://github.com/monero-ecosystem/PiNode-XMR/wiki/Manual)

# Project Overview

PiNode-XMR is a completely free and open source suite of tools to help a user run their own Monero node with ease. PiNode-XMR is designed for use with single board computers (SBC) such as the Raspberry Pi, Pine64 or Odroid hardware to allow for very cheap node setup and minimal 24/7 running costs due to low power usage.

PiNode-XMR can provide a Full or Pruned Monero Node and optional integration with tor/I2P along with many other tools such as your own block explorer, transaction pool viewer and connected peer lists. After setup, normal interaction is available through a built in web interface accessible from any device on your local network:

![nodeStatus](https://github.com/monero-ecosystem/PiNode-XMR/raw/master/Screenshots/nodestatus.png)

## Quick Start

### Hardware
PiNode-XMR was originaly designed and built on Raspberry Pi OS, and has now expanded to support Armbain Buster. This allows for installation on many different devices.

A list of tested and supported hardware can be found here [PiNodeXMR Wiki: Hardware](https://github.com/monero-ecosystem/PiNode-XMR/wiki/Hardware)
However any similar device should work that has a Armbian Buster OS available, USB3 preferred, minimum overall specification should not be lower than a Pi3B.

Best value/performance as of Q2 2021 seems to be the Rock64.

Choose your device and storage, then download and write the official Buster OS image. If available use the 'lite' version of the OS, there is no need for the GUI as PiNodeXMR will produce it's own interface later. Many devices also support USB boot as an alternative to MicroSD cards, performance and longevity is greatly increased if you can take the extra step.

Once you have your basic OS:

**Raspberry Pi** users can log in as usual with user 'pi' and password 'raspberry'

**Armbian users** should login with the default (usually it's username 'root' with password '1234') and create a new user called 'pinodexmr'. Once Armbian users have created 'pinodexmr' they should remain logged in as user 'root'.

Finally to install the PiNode-XMR project simply run the single line:

`wget -O - https://raw.githubusercontent.com/monero-ecosystem/PiNode-XMR/master/Install-PiNode-XMR.sh | bash`

And follow the menu prompts.



## Downloads
#### Download PiNode-XMR disk image for Raspberry Pi 3b+ & 4
If using a Raspberry Pi you may use a pre-installed disk image. The PiNode-XMR image is available to download as-is. Meaning it is un-compressed and ready to write using the same method you would for any other disk image. 

____
#### Direct Downloads

[Download PiNodeXMR v4.21.01 Base image for Raspberry Pi3B/4](https://drive.google.com/file/d/13CiIJ2TrZ5nxdwLto2OKcuowzq1v7-b5/view?usp=sharing) 7GB


Name: PiNodeXMR-v4.21.01.img

Size: 7088381952 bytes (6760 MiB)

SHA256: BE0531C90EAE4D3D768D10826AF09084270475CB78E77793CBA5D7B304C73C99

____

See the full manual in the wiki for other links to pre-sync'd pruned node images.

## Contact and Support

* [Redit.com/r/PiNode](https://www.reddit.com/r/pinode/)
* Telegram group PiNode-XMR [t.me/PiNodeXMR](https://t.me/PiNodeXMR)

During install a debug file is generated at the path /home/pinodexmr/debug.log  Any errors from a failed install are passed to this file and may be helpful should you have a problem. Most commonly errors on first build are due to a dependency not being downloaded (server 404), the install command can be run multiple times.

I am slowly building a [FAQ page](https://github.com/monero-ecosystem/PiNode-XMR/wiki/FAQ)

*Hosting large image files such as the pre-sync'd version does come with it's costs. If you like the project or found the images helpful any contribution would be gratefully received:*

43HoAhqx9q3MR1crAjpQtYVhvzQhZgqPwSWVQMmPvYmr18qVUEjCHcsEasuCxS486rWSSg1gbGqanet67NWRsh1bQL9KkB9
