<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/variables/p2poolChain.sh', 'w');
fwrite($fp, "#!/bin/bash\nP2POOLCHAIN=$VALUE");
fclose($fp);
echo "P2Pool chain set to $VALUE";
?>