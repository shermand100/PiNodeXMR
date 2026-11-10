<?php
require_once __DIR__ . '/pinode_security.php';

$VALUE = pn_int_range(pn_read_value(), 1, 256, 'Mining threads');

pn_write_shell_var('/home/pinodexmr/variables/mining-threads.sh', 'MINING_THREADS', $VALUE);
pn_write_file('/var/www/html/mining_threads.txt', "Currently set to $VALUE CPU threads");

echo 'CPU threads for mining set to ' . pn_h($VALUE) . ' ';
