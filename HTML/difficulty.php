<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/difficulty.sh', 'w');
fwrite($fp, "#!/bin/bash\nDIFFICULTY=$VALUE
");
fclose($fp);
echo "Difficulty of share required before submit set to $VALUE";
 ?>