<?php 
  exec("sudo systemctl start moneroI2PPrivate.service");
  exec("sudo systemctl enable moneroI2PPrivate.service");
  echo "Start Command Sent to bridge transaction broadcast through I2P";
?>