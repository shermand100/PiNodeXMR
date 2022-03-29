<?php 
  exec("sudo systemctl start monerod-start-tor-public.service");
  echo "Command to pass Monerod traffic via tor SOCKS sent (Public tor node)";
?>