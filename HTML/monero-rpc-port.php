<?php
require_once __DIR__ . '/pinode_security.php';

$VALUE = pn_port(pn_read_value(), 'Monero RPC port');

pn_write_shell_var('/home/pinodexmr/variables/monero-port.sh', 'MONERO_PORT', $VALUE);
pn_write_file('/var/www/html/monero-rpc-port.txt', "Has been set to: $VALUE");

echo 'Monero RPC port has been set to ' . pn_h($VALUE) . ' ';
