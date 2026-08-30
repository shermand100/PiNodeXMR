<?php
require_once __DIR__ . '/pinode_security.php';

$VALUE = pn_i2p_address(pn_read_value(), 'I2P address');

pn_write_shell_var('/home/pinodexmr/variables/i2p-address.sh', 'I2P_ADDRESS', $VALUE);
pn_write_file('/var/www/html/i2p-address.txt', "Your I2P address is set to: $VALUE");

echo 'Your I2P address has been set to: ' . pn_h($VALUE) . ' ';
