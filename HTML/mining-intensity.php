<?php
require_once __DIR__ . '/pinode_security.php';

$VALUE = pn_int_range(pn_read_value(), 0, 100, 'Mining intensity');

pn_write_shell_var('/home/pinodexmr/variables/mining-intensity.sh', 'MINING_INTENSITY', $VALUE);
pn_write_file('/var/www/html/mining_intensity.txt', "Currently set to $VALUE percent");

echo 'Mining intensity set to ' . pn_h($VALUE) . ' percent ';
