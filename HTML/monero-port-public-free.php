<?php
require_once __DIR__ . '/pinode_security.php';

$VALUE = pn_port(pn_read_value(), 'Monero Free Public RPC port');

pn_write_shell_var('/home/pinodexmr/variables/monero-port-public-free.sh', 'MONERO_PUBLIC_PORT', $VALUE);
pn_write_file('/var/www/html/monero-free-public-port.txt', "Currently set to $VALUE");

echo 'Monero Free Public RPC port set to ' . pn_h($VALUE) . ' ';
