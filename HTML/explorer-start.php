<?php 
  exec("sudo systemctl start blockExplorer.service");
  exec("sudo systemctl enable blockExplorer.service");
  echo "Start Command Sent for Block Explorer";
?>