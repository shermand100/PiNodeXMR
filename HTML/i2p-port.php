<?php
include_once('./common.php');
$VALUE = $_POST["value"];
putvar("i2p_port", $VALUE);

$fpa = fopen('/var/www/html/i2p-port.txt', 'w');
fwrite($fpa, "Your I2P server/router port is set to: $VALUE");
fclose($fpa);

echo "Your I2P server/router port has been set to: $VALUE ";
?>
