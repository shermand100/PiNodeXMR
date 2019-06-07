<?php
  echo "Your PiNode-XMR will begin Mining in 60 seconds\n\nBe aware of CPU temp rise";
  exec("/home/pinodexmr/monerod-start-mining.sh");
  echo "Your PiNode-XMR has started mining";
 ?>