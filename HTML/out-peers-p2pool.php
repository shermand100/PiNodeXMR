<?php
require_once __DIR__ . '/pinode_security.php';

$VALUE = pn_int_range(pn_read_value(), -1, 1000, 'Outbound peer limit');

pn_write_shell_var('/home/pinodexmr/variables/out-peers-p2pool.sh', 'OUT_PEERS_P2POOL', $VALUE);

echo 'Number of outbound connections limited to ' . pn_h($VALUE);
