<?php
require_once __DIR__ . '/pinode_security.php';

// Service control, shutdown and reboot all live behind this switch, so it is
// the most valuable endpoint to protect against cross-site invocation.
pn_require_csrf();

// The console posts with the selector in the query string; accept it from the
// request body too so callers can send everything in one place.
$function = isset($_POST['function']) ? $_POST['function'] : (isset($_GET['function']) ? $_GET['function'] : '');
if (!is_string($function)) {
    pn_fail('Invalid function selector.');
}

switch($function) {
  case 'start-moneroPrivate':
    exec("systemctl start moneroPrivate.service");
    exec("systemctl enable moneroPrivate.service");
    echo "Monero Private Node Started (RPC Required for wallet use - clearnet)";
    break;
  case 'stop-moneroPrivate':
    exec("systemctl stop moneroPrivate.service");
    exec("systemctl disable moneroPrivate.service");
    echo "Stop Command Sent for Private Node";
    exec (". /home/pinodexmr/bootStatusSetIdle.sh");
    break;
  case 'start-moneroPublicFree':
    exec("systemctl start moneroPublicFree.service");
    exec("systemctl enable moneroPublicFree.service");
    echo "Service started for Monero Free Public Node";
    break;
  case 'stop-moneroPublicFree':
    exec("systemctl stop moneroPublicFree.service");
    exec("systemctl disable moneroPublicFree.service");
    echo "Stop Command Sent for Monero Free Public Node";
    exec (". /home/pinodexmr/bootStatusSetIdle.sh");
    break;
  case 'start-moneroMiningNode':
    exec("systemctl start moneroMiningNode.service");
    exec("systemctl enable moneroMiningNode.service");
    echo "Your PiNode-XMR will start a Private node with Mining \n\nBe aware of CPU temp rise";
    break;
  case 'stop-moneroMiningNode':
    exec("systemctl stop moneroMiningNode.service");
    exec("systemctl disable moneroMiningNode.service");
    echo "Stop Command Sent for Monero Mining Node";
    exec (". /home/pinodexmr/bootStatusSetIdle.sh");
    break;
  case 'start-moneroTorPrivate':
    exec("systemctl start moneroTorPrivate.service");
    exec("systemctl enable moneroTorPrivate.service");
    echo "Monero Private Tor Node started. RPC required for wallet use.";
    break;
  case 'stop-moneroTorPrivate':
    exec("systemctl stop moneroTorPrivate.service");
    exec("systemctl disable moneroTorPrivate.service");
    echo "Command Sent to stop sending Monerod traffic via tor SOCKS";
    exec (". /home/pinodexmr/bootStatusSetIdle.sh");
    break;
  case 'start-moneroTorPublic':
    exec("systemctl start moneroTorPublic.service");
    exec("systemctl enable moneroTorPublic.service");
    echo "Command to pass Monerod traffic via tor SOCKS sent (Public tor node)";
    break;
  case 'stop-moneroTorPublic':
    exec("systemctl stop moneroTorPublic.service");
    exec("systemctl disable moneroTorPublic.service");
    echo "Command Sent to stop sending Monerod traffic via tor SOCKS";
    exec (". /home/pinodexmr/bootStatusSetIdle.sh");
    break;
  case 'start-moneroI2PPrivate':
    exec("systemctl start moneroI2PPrivate.service");
    exec("systemctl enable moneroI2PPrivate.service");
    echo "Start Command Sent to bridge transaction broadcast through I2P";
    break;
  case 'stop-moneroI2PPrivate':
    exec("systemctl stop moneroI2PPrivate.service");
    exec("systemctl disable moneroI2PPrivate.service");
    echo "Stop Command Sent for I2P Bridging Node";
    exec (". /home/pinodexmr/bootStatusSetIdle.sh");
    break;
  case 'start-moneroCustomNode':
    exec("systemctl start moneroCustomNode.service");
    exec("systemctl enable moneroCustomNode.service");
    echo "Monero Node Started with your custom settings";
    break;
  case 'stop-moneroCustomNode':
    exec("systemctl stop moneroCustomNode.service");
    exec("systemctl disable moneroCustomNode.service");
    echo "Stop Command Sent for Custom Node";
    exec (". /home/pinodexmr/bootStatusSetIdle.sh");
    break;
  case 'enable-swap':
    exec("pkexec /home/pinodexmr/enable-swap.sh");
    echo "2GB swap-file enabled";
    break;
  case 'disable-swap':
    exec("pkexec /home/pinodexmr/disable-swap.sh");
    echo "2GB swap-file disabled";
    break;
  case 'shutdown':
    exec("systemctl start shutdown.service");
    echo "Your PiNode-XMR has begun shutdown process.\n\nPower off in 60seconds";
    break;
  case 'reboot':
    exec("systemctl start reboot.service");
    echo "Your PiNode-XMR has begun reboot process.\n\nDevice restart in 10 seconds";
    break;    
  case 'monerod-kill':
    exec("systemctl start kill.service");
    echo "The command 'sudo killall -9 monerod' has been sent\n\nTo avoid corruption of the blockchain this command should be avoided where possible\n\nSorry something went wrong though...";
    break;
  case 'restart-logio':
    exec("systemctl restart log-io-file");
    exec("systemctl restart log-io-server");
    echo "PiNodeXMR has restarted the Log-io services";
    break;
  case 'p2pool-start':
    exec("systemctl start p2pool.service");
    exec("systemctl enable p2pool.service");
    echo "Start Command Sent for P2Pool";
    break;
  case 'p2pool-stop':
    exec("systemctl stop p2pool.service");
    exec("systemctl disable p2pool.service");
    echo "Stop Command Sent for P2Pool";
    break;
  case 'explorer-start':
    exec("systemctl start blockExplorer.service");
    exec("systemctl enable blockExplorer.service");
    echo "Start Command Sent for Block Explorer";
    break;
  case 'explorer-stop':
    exec("systemctl stop blockExplorer.service");
    exec("systemctl disable blockExplorer.service");
    echo "Stop Command Sent for Block Explorer";
    break;
  case 'swap-start':
    exec("systemctl start atomic-swap.service");
    exec("systemctl enable atomic-swap.service");
    echo "Start Command Sent for Atomic Swap service";
    break;
  case 'swap-stop':
    exec("systemctl stop atomic-swap.service");
    exec("systemctl disable atomic-swap.service");
    echo "Stop Command Sent for Atomic Swap service";
    break;
  case 'p2poolMining-start':
    exec("systemctl start p2poolMining.service");
    exec("systemctl enable p2poolMining.service");
    echo "Start Command Sent for P2Pool Mining service";
    break;  
  case 'p2poolMining-stop':
    exec("systemctl stop p2poolMining.service");
    exec("systemctl disable p2poolMining.service");
    echo "Stop Command Sent for P2Pool Mining service";
    break;      
  default:
    http_response_code(400);
    echo "Error: No function specified";
}