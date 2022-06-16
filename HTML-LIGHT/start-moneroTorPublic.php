<?php 
  exec("sudo systemctl start moneroTorPublic.service");
  exec("sudo systemctl enable moneroTorPublic.service");
  echo "Command to pass Monerod traffic via tor SOCKS sent (Public tor node)";
?>