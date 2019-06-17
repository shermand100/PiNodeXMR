<?php 
  exec("sudo systemctl start monerod-prune.service");
  echo "One-time sequence started for Monero Blockchain Pruning\n\nThis will take some time.\n\n(If this button has been clicked before the command has not been sent).";
 ?>