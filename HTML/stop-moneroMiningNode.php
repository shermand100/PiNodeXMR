<?php
  exec("sudo systemctl stop moneroMiningNode.service");
  exec("sudo systemctl disable moneroMiningNode.service");
  echo "Stop Command Sent for Monero Mining Node";
  exec (". /home/pinodexmr/bootStatusSetIdle.sh");
?>