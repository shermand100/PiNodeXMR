<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/i2p-port.sh', 'w');
fwrite($fp, "#!/bin/bash\nI2P_PORT=$VALUE
");
fclose($fp);

$fpa = fopen('/var/www/html/i2p-port.txt', 'w');
fwrite($fpa, "Your I2P server/router port is set to: $VALUE");
fclose($fpa);

echo "Your I2P server/router port has been set to: $VALUE ";
 ?>