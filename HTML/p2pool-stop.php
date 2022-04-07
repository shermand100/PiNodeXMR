<?php 
  exec("sudo systemctl stop p2pool-start.service");
  echo "Stop Command Sent for Private Node";
  exec (". /home/pinodexmr/remove-autostart.sh");
?>