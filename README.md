![PiNode-XMR logo](https://github.com/monero-ecosystem/PiNode-XMR/blob/master/Screenshots/PiNode-XMR%20logo.jpg)
# Quick Start Guide v5.22.11-Open-Build		
### This page is a quick overview to get you started. A complete and comprehensive manual showing all features can be found here at the Wiki: [Full Manual](https://github.com/monero-ecosystem/PiNode-XMR/wiki/Manual)

# Project Overview

PiNode-XMR is a completely free and open source suite of tools to help a user run their own Monero node with ease. PiNode-XMR is designed for use with single board computers (SBC) such as the Raspberry Pi, Pine64 or Odroid hardware to allow for very cheap node setup and minimal 24/7 running costs due to low power usage.

PiNode-XMR can provide a Full or Pruned Monero Node and optional integration with tor/I2P along with many other tools such as your own block explorer, transaction pool viewer and connected peer lists. After setup, normal interaction is available through a built in web interface accessible from any device on your local network:

![Demo](https://github.com/monero-ecosystem/PiNode-XMR/blob/master/Screenshots/PiNodeXMR_demo.gif)

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

`wget -O – install.pinodexmr.co.uk | bash`

And follow the menu prompts.



## Downloads
#### Download PiNode-XMR disk images 

Pre-configured disk images are available for the following devices:
* Raspberry Pi 3 (32-bit)
* Raspberry Pi 4 (64-bit)
* RockPro64 (64-bit)
* Rock64 (64-bit)
* Odroid XU4 / HC1 / HC2 (32-bit)

Note that 32-bit devices cannot run P2Pool

____
#### Direct Download links

To assist in managing disk images they are all held on our website PiNodeXMR.co.uk

[(Link) All pre-configured disk images @ PiNodeXMR.co.uk](https://www.pinode.co.uk/downloads)

____

See the full manual in the wiki for other links to pre-sync'd pruned node images.

## Contact and Support

* [Redit.com/r/PiNode](https://www.reddit.com/r/pinode/)
* Telegram group PiNode-XMR [t.me/PiNodeXMR](https://t.me/PiNodeXMR)

During install a debug file is generated at the path /home/pinodexmr/debug.log  Any errors from a failed install are passed to this file and may be helpful should you have a problem. Most commonly errors on first build are due to a dependency not being downloaded (server 404), the install command can be run multiple times.

I am slowly building a [FAQ page](https://github.com/monero-ecosystem/PiNode-XMR/wiki/FAQ)

*Hosting large image files such as the pre-sync'd version does come with it's costs. If you like the project or found the images helpful any contribution would be gratefully received:*

43HoAhqx9q3MR1crAjpQtYVhvzQhZgqPwSWVQMmPvYmr18qVUEjCHcsEasuCxS486rWSSg1gbGqanet67NWRsh1bQL9KkB9
