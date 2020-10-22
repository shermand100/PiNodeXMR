<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/add-i2p-peer.sh', 'w');
fwrite($fp, "#!/bin/bash\nADD_I2P_PEER=$VALUE
");
fclose($fp);

$fpa = fopen('/var/www/html/add-i2p-peer.txt', 'w');
fwrite($fpa, "$VALUE has been set as your seed peer");
fclose($fpa);

echo "$VALUE has been set as your i2p seed peer";
 ?>