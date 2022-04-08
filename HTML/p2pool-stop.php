<?php 
  exec("sudo systemctl stop p2pool.service");
  exec("sudo systemctl disable p2pool.service");
  echo "Stop Command Sent for P2Pool";
?>