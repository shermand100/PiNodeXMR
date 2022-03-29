<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/add-tor-peer.sh', 'w');
fwrite($fp, "#!/bin/bash\nADD_TOR_PEER=$VALUE");
fclose($fp);

$fpa = fopen('/var/www/html/add-tor-peer.txt', 'w');
fwrite($fpa, "$VALUE has been set as your tor seed peer");
fclose($fpa);

echo "$VALUE has been set as your tor seed peer";
?>