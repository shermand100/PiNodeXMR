<?php 
  exec("sudo systemctl stop blockExplorer.service");
  exec("sudo systemctl disable blockExplorer.service");
  echo "Stop Command Sent for Block Explorer";
?>