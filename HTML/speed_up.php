<?php
require_once __DIR__ . '/pinode_security.php';

$VALUE = pn_int_range(pn_read_value(), -1, 1000000, 'Upload speed limit');

pn_write_shell_var('/home/pinodexmr/variables/limit-rate-up.sh', 'LIMIT_RATE_UP', $VALUE);

echo 'Upload Speed limit set to ' . pn_h($VALUE) . ' kB/s';
