<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/block-sync-size.sh', 'w');
fwrite($fp, "#!/bin/bash\nBLOCK_SYNC_SIZE=$VALUE
");
fclose($fp);
echo "Number of block sync batches limited to $VALUE";
 ?>