<?php 
  exec("sudo systemctl stop moneroTorPublic.service");
  exec("sudo systemctl disable moneroTorPublic.service");
  echo "Command Sent to stop sending Monerod traffic via tor SOCKS";
  exec (". /home/pinodexmr/bootStatusSetIdle.sh");
?>