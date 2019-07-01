<?php 
  exec("sudo systemctl start disable-swap.service");
  echo "2GB swap-file disabled";
 ?>