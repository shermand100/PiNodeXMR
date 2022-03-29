<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/monero-rpcpay-port.sh', 'w');
fwrite($fp, "#!/bin/bash\nMONERO_RPCPAY_PORT=$VALUE");
fclose($fp);

$fpa = fopen('/var/www/html/monero-port-rpc-pay.txt', 'w');
fwrite($fpa, "Currently set to $VALUE");
fclose($fpa);

echo "Monero RPC Pay port set to $VALUE ";
?>