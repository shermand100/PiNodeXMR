<?php 
  exec("sudo systemctl start moneroCustomNode.service");
  exec("sudo systemctl enable moneroCustomNode.service");
  echo "Monero Node Started with your custom settings";
?>