<?php
include_once('./common.php');
$VALUE = $_POST["value"];
putvar("monero_port", $VALUE);

$fpa = fopen('/var/www/html/monero-rpc-port.txt', 'w');
fwrite($fpa, "Has been set to: $VALUE");
fclose($fpa);

echo "Monero RPC port has been set to $VALUE ";
?>
