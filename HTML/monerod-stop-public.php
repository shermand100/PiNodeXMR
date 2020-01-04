<?php 
  exec("sudo systemctl stop monerod-start-public.service");
  echo "Stop Command Sent for Public Node";
  exec (". /home/pinodexmr/remove-autostart.sh");
 ?>