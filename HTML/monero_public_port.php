<?php
require_once __DIR__ . '/pinode_security.php';

$VALUE = pn_port(pn_read_value(), 'Monero Restricted Public RPC port');

pn_write_shell_var('/home/pinodexmr/variables/monero-public-port.sh', 'MONERO_PUBLIC_PORT', $VALUE);

echo 'Monero Restricted Public RPC port set to ' . pn_h($VALUE) . ' ';
