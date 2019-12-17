<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/credits.sh', 'w');
fwrite($fp, "#!/bin/bash\nCREDITS=$VALUE
");
fclose($fp);
echo "Number of credits required for RPC service set to $VALUE";
 ?>