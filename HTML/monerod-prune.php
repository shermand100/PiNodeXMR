<?php
require_once __DIR__ . '/pinode_security.php';

// Starts a long-running, one-way blockchain pruning job, so it needs the same
// cross-site protection as the other service-control endpoints.
pn_require_csrf();

exec("sudo systemctl start monerod-prune.service");
echo "One-time sequence started for Monero Blockchain Pruning\n\nThis will take some time.\n\n(If this button has been clicked before the command has not been sent).";
