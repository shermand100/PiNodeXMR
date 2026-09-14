<?php
require_once __DIR__ . '/pinode_security.php';

$VALUE = pn_p2pool_chain(pn_read_value());

pn_write_shell_var('/home/pinodexmr/variables/p2poolChain.sh', 'P2POOLCHAIN', $VALUE);

$label = $VALUE === '' ? 'Main' : $VALUE;
echo 'P2Pool chain set to ' . pn_h($label);
