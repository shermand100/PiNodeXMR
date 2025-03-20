<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/variables/out-peers-p2pool.sh', 'w');
fwrite($fp, "#!/bin/bash\nOUT_PEERS_P2POOL=$VALUE");
fclose($fp);

echo "Number of outbound connections limited to $VALUE";
?>