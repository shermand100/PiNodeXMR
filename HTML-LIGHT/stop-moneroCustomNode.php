<?php 
  exec("sudo systemctl stop moneroCustomNode.service");
  exec("sudo systemctl disable moneroCustomNode.service");
  echo "Stop Command Sent for Custom Node";
  exec (". /home/pinodexmr/bootStatusSetIdle.sh");
?>