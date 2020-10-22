<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/difficulty.sh', 'w');
fwrite($fp, "#!/bin/bash\nDIFFICULTY=$VALUE
");
fclose($fp);

$fpa = fopen('/var/www/html/difficulty.txt', 'w');
fwrite($fpa, "Difficulty set to: $VALUE");
fclose($fpa);

echo "Difficulty of share required before client submit set to $VALUE";
 ?>