<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/monero-port.sh', 'w');
fwrite($fp, "#!/bin/bash\nMONERO_PORT=$VALUE
");
fclose($fp);

$fpa = fopen('/var/www/html/monero-rpc-port.txt', 'w');
fwrite($fpa, "Has been set to: $VALUE");
fclose($fpa);


echo "Monero RPC port has been set to $VALUE ";
 ?>