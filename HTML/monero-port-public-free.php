<?php
include_once('./common.php');
$VALUE = $_POST["value"];
putvar("monero_rpcpay_port", $VALUE);

$fpa = fopen('/var/www/html/monero-free-public-port.txt', 'w');
fwrite($fpa, "Currently set to $VALUE");
fclose($fpa);

echo "Monero Free Public RPC port set to $VALUE ";
?>
