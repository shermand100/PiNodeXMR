<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/limit-rate-down.sh', 'w');
fwrite($fp, "#!/bin/bash\nLIMIT_RATE_DOWN=$VALUE
");
fclose($fp);
echo "Download Speed limit set to $VALUE kB/s";
 ?>