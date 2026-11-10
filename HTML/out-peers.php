<?php
require_once __DIR__ . '/pinode_security.php';

$VALUE = pn_int_range(pn_read_value(), -1, 1000, 'Outbound peer limit');

pn_write_shell_var('/home/pinodexmr/variables/out-peers.sh', 'OUT_PEERS', $VALUE);

echo 'Number of outbound connections limited to ' . pn_h($VALUE);
