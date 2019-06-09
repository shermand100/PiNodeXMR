<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/limit-rate-up.sh', 'w');
fwrite($fp, "#!/bin/bash\nLIMIT_RATE_UP=$VALUE
");
fclose($fp);
echo "Upload Speed limit set to $VALUE kB/s";
 ?>