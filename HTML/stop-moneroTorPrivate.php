<?php 
  exec("sudo systemctl stop moneroTorPrivate.service");
  exec("sudo systemctl disable moneroTorPrivate.service");
  echo "Command Sent to stop sending Monerod traffic via tor SOCKS";
  exec (". /home/pinodexmr/bootStatusSetIdle.sh");
?>