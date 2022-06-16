<?php
$VALUE = $_POST["value"];
$fp = fopen('/home/pinodexmr/execScripts/moneroCustomNode.sh', 'w');
fwrite($fp, "#!/bin/bash\ncd /home/pinodexmr/monero/build/release/bin/\n$VALUE");
fclose($fp);

$fpa = fopen('/var/www/html/user-set-custom.txt', 'w');
fwrite($fpa, "$VALUE");
fclose($fpa);

echo "$VALUE\n\nHas been set as your custom monero start command";
?>