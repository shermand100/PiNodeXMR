<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/monero-port-public-free.sh', 'w');
fwrite($fp, "#!/bin/bash\nMONERO_PUBLIC_PORT=$VALUE
");
fclose($fp);

$fpa = fopen('/var/www/html/monero-free-public-port.txt', 'w');
fwrite($fpa, "Currently set to $VALUE");
fclose($fpa);

echo "Monero Free Public RPC port set to $VALUE "
 ?>