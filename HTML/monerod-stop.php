<?php 
  exec("sudo systemctl stop monerod-start.service");
  echo "Stop Command Sent for Private Node";
  exec (". /home/pinodexmr/remove-autostart.sh");
 ?>