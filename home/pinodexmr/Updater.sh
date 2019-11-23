#!/bin/bash

#Establish IP
	DEVICE_IP="$(hostname -I)"
	echo "PiNode-XMR on ${DEVICE_IP} is checking for available updates"
	sleep "1"
#Download update file
	sleep "1"
	wget -q https://raw.githubusercontent.com/shermand100/pinode-xmr/master/xmr-new-ver.sh -O /home/pinodexmr/xmr-new-ver.sh
	echo "Version Info file recieved:"
#Permission Setting
	chmod 755 /home/pinodexmr/current-ver.sh
	chmod 755 /home/pinodexmr/xmr-new-ver.sh
#Load Variables
. /home/pinodexmr/current-ver.sh
. /home/pinodexmr/xmr-new-ver.sh
. /home/pinodexmr/strip.sh
echo $NEW_VERSION 'New Version'
echo $CURRENT_VERSION 'Current Version'
sleep "3"
if [ $CURRENT_VERSION -lt $NEW_VERSION ]
then
	echo -e "\e[32mNew Monero version available...Downloading\e[0m"
	sleep "2"
	wget https://downloads.getmonero.org/cli/linuxarm7
	echo -e "New version of Monero SHA256 hash is...\e[33m"
    cat ./linuxarm7 | sha256sum | head -c 64
	echo -e "\n\e[0mIt is strongly recommended that you compare the hash above with the official hash at \n\e[33m https://web.getmonero.org/downloads/#arm \n\e[0m For ARMv7 command-line tools only. \n Only proceed with this update if the hash values match to prevent installing malicious software.\n"
	
	asksure() {
	echo -e "\e[31mAre you sure the signatures match(Y/N)?\e[0m"
while read -r -n 1 -s answer; do
  if [[ $answer = [YyNn] ]]; then
    [[ $answer = [Yy] ]] && retval=0
    [[ $answer = [Nn] ]] && retval=1
    break
  fi
done

echo # just a final linefeed, optics...

return $retval
}

### using it
if asksure; then
  echo "Okay, performing update..."
else
  echo "Update canceled. Refer to the Monero community for guidance before attempting update again."
  rm /home/pinodexmr/linuxarm7
  sleep "1"
  echo "Deleted un-trusted download of Monero for ARMv7"
  
  exit 1
fi

	sudo systemctl stop monerod-start.service
	sudo systemctl stop monerod-start-mining.service
	sudo systemctl stop monerod-start-tor.service
	echo "Monerod stop command sent, allowing 30 seconds for safe shutdown"
	sleep "30"
	rm -rf /home/pinodexmr/monero-active/
	echo "Deleting Old Version"
	sleep "2"
	mkdir /home/pinodexmr/monero-active
	sleep "2"
	chmod 755 /home/pinodexmr/monero-active

	tar -xvf ./linuxarm7 -C /home/pinodexmr/monero-active --strip $STRIP
	echo "Software Update Complete - Resuming Node"
	sleep "2"
	sudo systemctl start monerod-start.service
	echo "Monero Node Started in background"
	echo "Tidying up leftover installation packages"
	#Clean-up stage
	#Update system version number
	echo "#!/bin/bash
CURRENT_VERSION=$NEW_VERSION" > /home/pinodexmr/current-ver.sh
	#Remove downloaded version check file
	rm /home/pinodexmr/xmr-new-ver.sh
	rm /home/pinodexmr/linuxarm7
else
	echo "Your node is up to date, no further action required, I'll check again next week."
fi
