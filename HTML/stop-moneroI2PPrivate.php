<?php 
  exec("sudo systemctl stop moneroI2PPrivate.service");
  exec("sudo systemctl disable moneroI2PPrivate.service");
  echo "Stop Command Sent for I2P Bridging Node";
  exec (". /home/pinodexmr/bootStatusSetIdle.sh");
?>