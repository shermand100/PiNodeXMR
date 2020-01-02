<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/monero-port.sh', 'w');
fwrite($fp, "#!/bin/bash\nMONERO_PORT=$VALUE
");
fclose($fp);
echo "Monero RPC port set to $VALUE ";
 ?>