<?php
require_once __DIR__ . '/pinode_security.php';

$VALUE = pn_monero_address(pn_read_value(), 'Mining address');

pn_write_shell_var('/home/pinodexmr/variables/mining-address.sh', 'MINING_ADDRESS', $VALUE);
pn_write_file('/var/www/html/mining_address.txt', "Currently set to $VALUE");

echo 'Mining address set to ' . pn_h($VALUE) . ' ';
