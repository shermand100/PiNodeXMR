<?php 
  exec("sudo systemctl stop monerod-start-tor.service");
  echo "Command Sent to stop sending Monerod traffic via tor SOCKS";
  exec (". /home/pinodexmr/remove-autostart.sh");
 ?>