<?php 
  exec("sudo systemctl stop moneroPublicFree.service");
  exec("sudo systemctl disable moneroPublicFree.service");
  echo "Stop Command Sent for Private Node";
  exec (". /home/pinodexmr/bootStatusSetIdle.sh");
?>