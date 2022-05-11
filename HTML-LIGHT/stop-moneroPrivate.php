<?php 
  exec("sudo systemctl stop moneroPrivate.service");
  exec("sudo systemctl disable moneroPrivate.service");
  echo "Stop Command Sent for Private Node";
  exec (". /home/pinodexmr/bootStatusSetIdle.sh");
?>