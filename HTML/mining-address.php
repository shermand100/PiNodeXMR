<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/mining-address.sh', 'w');
fwrite($fp, "#!/bin/bash\nMINING_ADDRESS=$VALUE");
fclose($fp);

$fpa = fopen('/var/www/html/mining_address.txt', 'w');
fwrite($fpa, "Currently set to $VALUE");
fclose($fpa);

echo "Mining address set to $VALUE ";
?>