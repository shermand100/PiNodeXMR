<?php
include_once('./common.php');
$VALUE = $_POST["value"];
putvar("monero_rpcpay_port", $VALUE);

$fpa = fopen('/var/www/html/monero-port-rpc-pay.txt', 'w');
fwrite($fpa, "Currently set to $VALUE");
fclose($fpa);

echo "Monero RPC Pay port set to $VALUE ";
?>
