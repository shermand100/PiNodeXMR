<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/mining-address.sh', 'w');
fwrite($fp, "#!/bin/bash\nMINING_ADDRESS=$VALUE
");
fclose($fp);
echo "Mining address set to $VALUE ";
 ?>