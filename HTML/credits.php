<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/variables/credits.sh', 'w');
fwrite($fp, "#!/bin/bash\nCREDITS=$VALUE");
fclose($fp);

$fpa = fopen('/var/www/html/credits.txt', 'w');
fwrite($fpa, "Credits set to: $VALUE");
fclose($fpa);

echo "Number of credits awarded for valid share set to $VALUE";
?>