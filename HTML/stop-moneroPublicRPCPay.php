<?php 
  exec("sudo systemctl stop moneroPublicRPCPay.service");
  exec("sudo systemctl disable moneroPublicRPCPay.service");
  echo "Stop Command Sent for Public RPC Pay Node";
  exec (". /home/pinodexmr/bootStatusSetIdle.sh");
?>