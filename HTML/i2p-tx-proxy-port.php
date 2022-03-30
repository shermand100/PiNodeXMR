<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/i2p-tx-proxy-port.sh', 'w');
fwrite($fp, "#!/bin/bash\nI2P_TX_PROXY_PORT=$VALUE");
fclose($fp);

$fpa = fopen('/var/www/html/i2p-tx-proxy-port.txt', 'w');
fwrite($fpa, "Your I2P TX-Proxy port is set to: $VALUE");
fclose($fpa);

echo "Your I2P TX-Proxy port has been set to: $VALUE ";
?>