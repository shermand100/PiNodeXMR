<?php 
  exec("sudo systemctl start monerod-reboot.service");
  echo "Reboot Command Sent - allow 1m for process";
 ?>