<?php
include_once('./common.php');
$VALUE = $_POST["value"];
putvar("payment_address", $VALUE);

$fpa = fopen('/var/www/html/payment-address.txt', 'w');
fwrite($fpa, "$VALUE has been set to receive to block reward on successful client mining.");
fclose($fpa);

echo "RPC Payment address set to $VALUE ";
?>
