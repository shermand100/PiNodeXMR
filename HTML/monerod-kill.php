<?php 
  exec("sudo systemctl start kill.service");
  echo "The command 'sudo killall -9 monerod' has been sent\n\nTo avoid corruption of the blockchain this command should be avoided where possible\n\nSorry something went wrong though...";
 ?>