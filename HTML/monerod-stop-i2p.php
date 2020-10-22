<?php 
  exec("sudo systemctl stop monerod-start-i2p.service");
  echo "Stop Command Sent for I2P Bridging Node";
  exec (". /home/pinodexmr/remove-autostart.sh");
 ?>