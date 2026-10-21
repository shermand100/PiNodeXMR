<?php
require_once __DIR__ . '/pinode_security.php';

$VALUE = pn_int_range(pn_read_value(), -1, 1000, 'Inbound peer limit');

pn_write_shell_var('/home/pinodexmr/variables/in-peers-p2pool.sh', 'IN_PEERS_P2POOL', $VALUE);

echo 'Number of inbound connections limited to ' . pn_h($VALUE);
