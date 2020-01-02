<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/monero-public-port.sh', 'w');
fwrite($fp, "#!/bin/bash\nMONERO_PUBLIC_PORT=$VALUE
");
fclose($fp);
echo "Monero Restricted Public RPC port set to $VALUE ";
 ?>