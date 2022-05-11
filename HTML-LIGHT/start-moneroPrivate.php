<?php 
  exec("sudo systemctl start moneroPrivate.service");
  exec("sudo systemctl enable moneroPrivate.service");
  echo "Monero Private Node Started (RPC Required for wallet use - clearnet)";
?>