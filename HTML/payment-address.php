<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/payment-address.sh', 'w');
fwrite($fp, "#!/bin/bash\nPAYMENT_ADDRESS=$VALUE
");
fclose($fp);
echo "RPC Payment address set to $VALUE ";
 ?>