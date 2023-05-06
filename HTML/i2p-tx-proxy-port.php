<?php
include_once('./common.php');
$VALUE = $_POST["value"];
putvar("i2p_tx_proxy_port", $VALUE);

$fpa = fopen('/var/www/html/i2p-tx-proxy-port.txt', 'w');
fwrite($fpa, "Your I2P TX-Proxy port is set to: $VALUE");
fclose($fpa);

echo "Your I2P TX-Proxy port has been set to: $VALUE ";
?>
