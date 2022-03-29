<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/mining-intensity.sh', 'w');
fwrite($fp, "#!/bin/bash\nMINING_INTENSITY=$VALUE");
fclose($fp);

$fpa = fopen('/var/www/html/mining_intensity.txt', 'w');
fwrite($fpa, "Currently set to $VALUE percent");
fclose($fpa);

echo "Mining intensity set to $VALUE percent ";
?>