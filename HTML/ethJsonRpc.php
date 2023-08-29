<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/variables/eth-rpc-node.sh', 'w');
fwrite($fp, "#!/bin/bash\nETH_RPC_NODE=$VALUE");
fclose($fp);

$fpa = fopen('/var/www/html/ethJsonRpc.txt', 'w');
fwrite($fpa, "$VALUE has been set as the public Ethereum JSON RPC node for this session.");
fclose($fpa);

echo "Ethereum JSON RPC node address set to $VALUE ";
?>