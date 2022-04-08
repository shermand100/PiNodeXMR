<?php 
  exec("sudo systemctl start moneroPublicFree.service");
  exec("sudo systemctl enable moneroPublicFree.service");
  echo "Service started for Monero Free Public Node";
?>