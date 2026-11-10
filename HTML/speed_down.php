<?php
require_once __DIR__ . '/pinode_security.php';

$VALUE = pn_int_range(pn_read_value(), -1, 1000000, 'Download speed limit');

pn_write_shell_var('/home/pinodexmr/variables/limit-rate-down.sh', 'LIMIT_RATE_DOWN', $VALUE);

echo 'Download Speed limit set to ' . pn_h($VALUE) . ' kB/s';
