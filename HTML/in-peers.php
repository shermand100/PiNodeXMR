<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/in-peers.sh', 'w');
fwrite($fp, "#!/bin/bash\nIN_PEERS=$VALUE
");
fclose($fp);
echo "Number of inbound connections limited to $VALUE";
 ?>