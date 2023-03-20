<?php
include_once('./common.php');
$VALUE = $_POST["value"];
putvar("monero_public_port", $VALUE);

echo "Monero Restricted Public RPC port set to $VALUE ";
?>
