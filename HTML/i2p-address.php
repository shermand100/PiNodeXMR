<?php
include_once('./common.php');
$VALUE = $_POST["value"];
putvar("i2p_address", $VALUE);

$fpa = fopen('/var/www/html/i2p-address.txt', 'w');
fwrite($fpa, "Your I2P address is set to: $VALUE");
fclose($fpa);

echo "Your I2P address has been set to: $VALUE ";
?>
