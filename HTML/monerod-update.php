<?php 
  exec("sudo systemctl start monerod-update.service");
  echo "Your PiNode-XMR has begun it's Update Script\n\nIf a new version is found to be available then update takes approx 5 mins\n\nCheck for completed update at 'Node Version' under 'Node Status' tab";
 ?>