<?php 
  exec("sudo systemctl start moneroTorPrivate.service");
  exec("sudo systemctl enable moneroTorPrivate.service");
  echo "Monero Private Tor Node started. RPC required for wallet use.";
?>