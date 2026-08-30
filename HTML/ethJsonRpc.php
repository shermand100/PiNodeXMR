<?php
require_once __DIR__ . '/pinode_security.php';

$VALUE = pn_rpc_url(pn_read_value(), 'Ethereum JSON-RPC node URL');

pn_write_shell_var('/home/pinodexmr/variables/eth-rpc-node.sh', 'ETH_RPC_NODE', $VALUE);
pn_write_file('/var/www/html/ethJsonRpc.txt', "$VALUE has been set as the public Ethereum JSON RPC node for this session.");

echo 'Ethereum JSON RPC node address set to ' . pn_h($VALUE) . ' ';
