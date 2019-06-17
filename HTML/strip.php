<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/strip.sh', 'w');
fwrite($fp, "#!/bin/bash\nSTRIP=$VALUE
");
fclose($fp);
echo "Monero update, un-package --strip value set to $VALUE";
 ?>