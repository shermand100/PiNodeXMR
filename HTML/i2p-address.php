<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/variables/i2p-address.sh', 'w');
fwrite($fp, "#!/bin/bash\nI2P_ADDRESS=$VALUE");
fclose($fp);

$fpa = fopen('/var/www/html/i2p-address.txt', 'w');
fwrite($fpa, "Your I2P address is set to: $VALUE");
fclose($fpa);

echo "Your I2P address has been set to: $VALUE ";
?>