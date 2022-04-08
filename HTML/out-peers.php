<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/variables/out-peers.sh', 'w');
fwrite($fp, "#!/bin/bash\nOUT_PEERS=$VALUE");
fclose($fp);

echo "Number of outbound connections limited to $VALUE";
?>