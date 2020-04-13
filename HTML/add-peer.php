<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/add-peer.sh', 'w');
fwrite($fp, "#!/bin/bash\nADD_PEER=$VALUE
");
fclose($fp);

$fpa = fopen('/var/www/html/add-peer.txt', 'w');
fwrite($fpa, "$VALUE has been set as your seed peer");
fclose($fpa);

echo "$VALUE has been set as your seed peer";
 ?>