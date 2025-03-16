<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/variables/mining-threads.sh', 'w');
fwrite($fp, "#!/bin/bash\nMINING_THREADS=$VALUE");
fclose($fp);

$fpa = fopen('/var/www/html/mining_threads.txt', 'w');
fwrite($fpa, "Currently set to $VALUE CPU threads");
fclose($fpa);

echo "CPU threads for mining set to $VALUE ";
?>