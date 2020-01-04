<?php
  exec("sudo systemctl stop monerod-start-mining.service");
  echo "Stop Request Sent\n\nSystem Idle\n\nUse a Manual Start Button from this page to run the Monerod service";
  exec (". /home/pinodexmr/remove-autostart.sh");
 ?>