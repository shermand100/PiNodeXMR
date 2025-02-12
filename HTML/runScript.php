<?php

$function = $_GET['function'];

switch($function) {
  case 'start-moneroPrivate':
    exec("sudo systemctl start moneroPrivate.service");
    exec("sudo systemctl enable moneroPrivate.service");
    echo "Monero Private Node Started (RPC Required for wallet use - clearnet)";
    break;
  case 'stop-moneroPrivate':
    exec("sudo systemctl stop moneroPrivate.service");
    exec("sudo systemctl disable moneroPrivate.service");
    echo "Stop Command Sent for Private Node";
    exec (". /home/pinodexmr/bootStatusSetIdle.sh");
    break;
  case 'start-moneroPublicFree':
    exec("sudo systemctl start moneroPublicFree.service");
    exec("sudo systemctl enable moneroPublicFree.service");
    echo "Service started for Monero Free Public Node";
    break;
  case 'stop-moneroPublicFree':
    exec("sudo systemctl stop moneroPublicFree.service");
    exec("sudo systemctl disable moneroPublicFree.service");
    echo "Stop Command Sent for Private Node";
    exec (". /home/pinodexmr/bootStatusSetIdle.sh");
    break;
  case 'start-moneroMiningNode':
    exec("sudo systemctl start moneroMiningNode.service");
    exec("sudo systemctl enable moneroMiningNode.service");
    echo "Your PiNode-XMR will start a Private node with Mining \n\nBe aware of CPU temp rise";
    break;
  case 'stop-moneroMiningNode':
    exec("sudo systemctl stop moneroMiningNode.service");
    exec("sudo systemctl disable moneroMiningNode.service");
    echo "Stop Command Sent for Monero Mining Node";
    exec (". /home/pinodexmr/bootStatusSetIdle.sh");
    break;
  case 'start-moneroTorPrivate':
    exec("sudo systemctl start moneroTorPrivate.service");
    exec("sudo systemctl enable moneroTorPrivate.service");
    echo "Monero Private Tor Node started. RPC required for wallet use.";
    break;
  case 'stop-moneroTorPrivate':
    exec("sudo systemctl stop moneroTorPrivate.service");
    exec("sudo systemctl disable moneroTorPrivate.service");
    echo "Command Sent to stop sending Monerod traffic via tor SOCKS";
    exec (". /home/pinodexmr/bootStatusSetIdle.sh");
    break;
  case 'start-moneroTorPublic':
    exec("sudo systemctl start moneroTorPublic.service");
    exec("sudo systemctl enable moneroTorPublic.service");
    echo "Command to pass Monerod traffic via tor SOCKS sent (Public tor node)";
    break;
  case 'stop-moneroTorPublic':
    exec("sudo systemctl stop moneroTorPublic.service");
    exec("sudo systemctl disable moneroTorPublic.service");
    echo "Command Sent to stop sending Monerod traffic via tor SOCKS";
    exec (". /home/pinodexmr/bootStatusSetIdle.sh");
    break;
  case 'start-moneroI2PPrivate':
    exec("sudo systemctl start moneroI2PPrivate.service");
    exec("sudo systemctl enable moneroI2PPrivate.service");
    echo "Start Command Sent to bridge transaction broadcast through I2P";
    break;
  case 'stop-moneroI2PPrivate':
    exec("sudo systemctl stop moneroI2PPrivate.service");
    exec("sudo systemctl disable moneroI2PPrivate.service");
    echo "Stop Command Sent for I2P Bridging Node";
    exec (". /home/pinodexmr/bootStatusSetIdle.sh");
    break;
  case 'start-moneroCustomNode':
    exec("sudo systemctl start moneroCustomNode.service");
    exec("sudo systemctl enable moneroCustomNode.service");
    echo "Monero Node Started with your custom settings";
    break;
  case 'stop-moneroCustomNode':
    exec("sudo systemctl stop moneroCustomNode.service");
    exec("sudo systemctl disable moneroCustomNode.service");
    echo "Stop Command Sent for Custom Node";
    exec (". /home/pinodexmr/bootStatusSetIdle.sh");
    break;
  case 'enable-swap':
    exec("sudo /home/pinodexmr/enable-swap.sh");
    echo "2GB swap-file enabled";
    break;
  case 'disable-swap':
    exec("sudo /home/pinodexmr/disable-swap.sh");
    echo "2GB swap-file disabled";
    break;
  case 'shutdown':
    exec("sudo systemctl start shutdown.service");
    echo "Your PiNode-XMR has begun shutdown process.\n\nPower off in 60seconds";
    break;
  case 'reboot':
    exec("sudo systemctl start reboot.service");
    echo "Your PiNode-XMR has begun reboot process.\n\nDevice restart in 10 seconds";
    break;    
  case 'monerod-kill':
    exec("sudo systemctl start kill.service");
    echo "The command 'sudo killall -9 monerod' has been sent\n\nTo avoid corruption of the blockchain this command should be avoided where possible\n\nSorry something went wrong though...";
    break;
  case 'restart-logio':
    exec("sudo systemctl restart log-io-file");
    exec("sudo systemctl restart log-io-server");
    echo "PiNodeXMR has restarted the Log-io services";
    break;
  case 'p2pool-start':
    exec("sudo systemctl start p2pool.service");
    exec("sudo systemctl enable p2pool.service");
    echo "Start Command Sent for P2Pool";
    break;
  case 'p2pool-stop':
    exec("sudo systemctl stop p2pool.service");
    exec("sudo systemctl disable p2pool.service");
    echo "Stop Command Sent for P2Pool";
    break;
  case 'explorer-start':
    exec("sudo systemctl start blockExplorer.service");
    exec("sudo systemctl enable blockExplorer.service");
    echo "Start Command Sent for Block Explorer";
    break;
  case 'explorer-stop':
    exec("sudo systemctl stop blockExplorer.service");
    exec("sudo systemctl disable blockExplorer.service");
    echo "Stop Command Sent for Block Explorer";
    break;
  case 'swap-start':
    exec("sudo systemctl start atomic-swap.service");
    exec("sudo systemctl enable atomic-swap.service");
    echo "Start Command Sent for Atomic Swap service";
    break;
  case 'swap-stop':
    exec("sudo systemctl stop atomic-swap.service");
    exec("sudo systemctl disable atomic-swap.service");
    echo "Stop Command Sent for Atomic Swap service";
    break;
  case 'p2poolMining-start':
    exec("sudo systemctl start p2poolMining.service");
    exec("sudo systemctl enable p2poolMining.service");
    echo "Start Command Sent for P2Pool Mining service";
    break;  
  case 'p2poolMining-stop':
    exec("sudo systemctl stop p2poolMining.service");
    exec("sudo systemctl disable p2poolMining.service");
    echo "Stop Command Sent for P2Pool Mining service";
    break;      
  default:
    echo "Error: No function specified";
}