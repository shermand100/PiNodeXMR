<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/variables/in-peers-p2pool.sh', 'w');
fwrite($fp, "#!/bin/bash\nIN_PEERS_P2POOL=$VALUE");
fclose($fp);
echo "Number of inbound connections limited to $VALUE";
?>