<?php
require_once __DIR__ . '/pinode_security.php';

$VALUE = pn_port(pn_read_value(), 'I2P server/router port');

pn_write_shell_var('/home/pinodexmr/variables/i2p-port.sh', 'I2P_PORT', $VALUE);
pn_write_file('/var/www/html/i2p-port.txt', "Your I2P server/router port is set to: $VALUE");

echo 'Your I2P server/router port is set to: ' . pn_h($VALUE) . ' ';
