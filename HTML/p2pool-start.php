<?php 
  exec("sudo systemctl start p2pool.service");
  exec("sudo systemctl enable p2pool.service");
  echo "Start Command Sent for P2Pool";
?>