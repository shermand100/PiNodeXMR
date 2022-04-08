<?php 
  exec("sudo systemctl start moneroPublicRPCPay.service");
  exec("sudo systemctl enable moneroPublicRPCPay.service");
  echo "Monero Public Node started - with RPC pay requiements.";
?>