<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/payment-address.sh', 'w');
fwrite($fp, "#!/bin/bash\nPAYMENT_ADDRESS=$VALUE
");
fclose($fp);

$fpa = fopen('/var/www/html/payment-address.txt', 'w');
fwrite($fpa, "$VALUE has been set to receive to block reward on successful client mining.");
fclose($fpa);

echo "RPC Payment address set to $VALUE ";
 ?>