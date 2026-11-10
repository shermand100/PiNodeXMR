<?php
require_once __DIR__ . '/pinode_security.php';

$VALUE = pn_custom_monero_command(pn_read_value());

// The value is validated to be a single monerod invocation with no shell
// metacharacters, so it cannot chain or inject additional commands when the
// execScript is run by the moneroCustomNode service.
$script = "#!/bin/bash\ncd /home/pinodexmr/monero/build/release/bin/\n$VALUE\n";
pn_write_file('/home/pinodexmr/execScripts/moneroCustomNode.sh', $script);
pn_write_file('/var/www/html/user-set-custom.txt', $VALUE);

echo pn_h($VALUE) . "\n\nHas been set as your custom monero start command";
