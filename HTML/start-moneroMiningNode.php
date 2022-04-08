<?php
  exec("sudo systemctl start moneroMiningNode.service");
  exec("sudo systemctl enable moneroMiningNode.service");
  echo "Your PiNode-XMR will start a Private node with Mining \n\nBe aware of CPU temp rise";
?>