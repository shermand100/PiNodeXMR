<?php
require_once __DIR__ . '/pinode_security.php';

$VALUE = pn_port(pn_read_value(), 'I2P TX-Proxy port');

pn_write_shell_var('/home/pinodexmr/variables/i2p-tx-proxy-port.sh', 'I2P_TX_PROXY_PORT', $VALUE);
pn_write_file('/var/www/html/i2p-tx-proxy-port.txt', "Your I2P TX-Proxy port is set to: $VALUE");

echo 'Your I2P TX-Proxy port is set to: ' . pn_h($VALUE) . ' ';
